//
//  S3Manager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import AWSS3
import PromiseKit
import Foundation

class S3Manager {
    
    /// File manger for saving / retreiveing files
    lazy var deviceDirectoryForDownloads: URL? = {
       
        do {
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("download")
            try
                FileManager.default.createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil)
            return url
        } catch let error as NSError {
            print("Creating directory failed. Error: \(error)")
            return nil
        }
    }()
    
    let fileManager = FileManager.default
    
    /// Caching errors handling
    enum CacheErros: Int {
        case miss
        case noSuchKey
    }
    
    /// Shared manager
    static let shared = S3Manager()
    
    // MARK: - Initialization
    /// Initilization with credentials
    init() {
        
        /// Trans manger
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "us-east-1:bebe0c8b-383d-40e2-bea4-deacd4ef17fc")
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
   
    
    /// Checking cache
    ///
    /// - Parameters:
    ///   - bucket: default clark bucket for mobile files
    ///   - key: File name
    /// - Returns: returns path
    fileprivate func checkDownloadCache(bucket: String = "com.hiclark.tutor", key: String) -> Promise<String> {
        
        /// Safety check for directory
        guard var url = deviceDirectoryForDownloads else {
            return Promise(value: "")
        }
        
        let keyFullPath = key.components(separatedBy: "/")
        let keyDirectories = keyFullPath[0..<keyFullPath.count-1]
        keyDirectories.forEach { path in
            url.appendPathComponent(path)
        }
        
        return Promise { fulfill, reject -> Void in
            // create cache folder if needed
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("RuAWSS3 ERROR: Could not create cache folder")
                print(error.localizedDescription)
                return reject(error)
            }
            
            // check if the file exists in cache
            let fileCachePath = url.appendingPathComponent(keyFullPath.last!).systemPath()
            if fileManager.fileExists(atPath: fileCachePath) {
                // the file exists,
                // but we still need to check if it is not obsolete
                let attr = try! fileManager.attributesOfItem(atPath: url.path)
                let modDate = attr[FileAttributeKey.modificationDate] as! Date
                
                let request = AWSS3HeadObjectRequest()!
                request.bucket = bucket
                request.key = key
                AWSS3.default().headObject(request).continueWith(block: {
                    task -> Any? in
                    
                    if let result = task.result {
                        let servDate = result.lastModified!
                        
                        if modDate < servDate {
                            // obsolete cache file; cache miss
                            return reject(NSError(domain: "miss", code: CacheErros.miss.rawValue, userInfo: nil))
                        }
                        
                        // cache hit
                        fulfill(fileCachePath)
                    }
                    else {
                        // file has been deleted from S3; no such key
                        do {
                            try self.fileManager.removeItem(atPath: fileCachePath)
                        } catch let error as NSError {
                            print("RuAWSS3 ERROR: Could not delete old cache file")
                            print(error.localizedDescription)
                        }
                        return reject(NSError(domain: "no such key", code: CacheErros.noSuchKey.rawValue, userInfo: nil))
                    }
                    
                    return nil
                })
            }
            else {
                // file does not exist in cache; cache miss
                return reject(NSError(domain: "miss", code: CacheErros.miss.rawValue, userInfo: nil))
            }
        }
    }
    
    /**
     Download a file from S3
     - Parameter bucket: Bucket's name that you want get a file - default bucket for clark files
     - Parameter key: Full file's path on bucket
     - Returns: Promise with string of the path of the downloaded file
     */
    public func download(bucket: String = "com.hiclark.tutor", key: String) -> Promise<String> {
        return Promise { fulfill, reject in
            firstly {
                checkDownloadCache(bucket: bucket, key: key)
                }.then { downloadPath -> Void in
                    // cache hit; send cache file
                    fulfill(downloadPath)
                }.catch { error in
                    // cache miss
                    let errorCode = CacheErros.init(rawValue: (error as NSError).code)!
                    
                    switch errorCode {
                    case .noSuchKey:
                        // file does not exist in S3
                        reject(NSError(domain: "no such key", code: 0, userInfo: nil))
                    case .miss:
                        // was cache miss; make download
                        let downloadRequest = AWSS3TransferManagerDownloadRequest()!
                        downloadRequest.bucket = bucket
                        downloadRequest.key = key
                        
                        let transferManager = AWSS3TransferManager.default()
                        transferManager.download(downloadRequest).continueWith(block: {
                            task-> Void in
                            
                            // error
                            if let error = task.error {
                                let errorCode = (error._userInfo as! [String: String])["Code"]!
                                
                                return reject(NSError(domain: errorCode, code: 0, userInfo: nil))
                            }
                            
                            // succes
                            let results = task.result! as! AWSS3TransferManagerDownloadOutput
                            let body = results.body as! URL
                            
                            guard let url = self.deviceDirectoryForDownloads else {
                                fulfill(body.systemPath())
                                return
                            }
                            
                            do {
                                let cachePath = url.appendingPathComponent(key)
                                if self.fileManager.fileExists(atPath: cachePath.systemPath()) {
                                    try self.fileManager.removeItem(at: cachePath)
                                }
                                try self.fileManager.moveItem(at: body as URL, to: cachePath)
                                fulfill(cachePath.systemPath())
                            } catch let error as NSError {
                                print("RuAWSS3 ERROR: Error trying to move the file to the cache folder!")
                                print(error.localizedDescription)
                                fulfill(body.systemPath())
                            }
                        })
                    }
            }
        }
    }
}

extension URL {
    func systemPath() -> String {
        return self.absoluteString.replacingOccurrences(of: "file://", with: "")
    }
}

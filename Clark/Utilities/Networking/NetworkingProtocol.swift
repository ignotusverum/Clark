//
//  NetworkingProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

// Networking
import Alamofire

// Parsing
import SwiftyJSON
import EZSwiftExtensions

// Asynch
import PromiseKit

/// General error
let GeneralError = NSError(domain: hostName, code: 1001, userInfo: nil)

let hostName = HostName
let hostVersion = "1"

public let NetworkingManagerAccessTokenKey = "NetworkingManagerAccessTokenKey"
public let NetworkingManagerKickoffTokenKey = "NetworkingManagerKickoffTokenKey"

protocol NetworkingProtocol {
    
    /// Networking header
    var headers: HTTPHeaders { get set }
    
    /// Api header key
    var apiKey: String? { get set }
    
    /// Default networking setup
    var manager: SessionManager { get set }
    
    /// Header configuration
    func configureHeader()
    
    // MARK: - Path builder
    func baseURL(path: String)-> URL
    
    // MARK: - HTTP Request + Promise
    func request(_ method: HTTPMethod, path URLString: String, parameters: [String: Any]?) -> Promise<JSON>
}

extension NetworkingProtocol {
    // MARK: - HTTP Request + Promise
    func request(_ method: HTTPMethod, path URLString: String, parameters: [String: Any]? = nil) -> Promise<JSON> {
        configureHeader()
        
        let path = baseURL(path: URLString)
        
        return Promise { fulfill, reject in
            manager.request(path, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            fulfill(json)
                        }
                        
                    case .failure(let error):

                        if let data = response.data {
                            let responseJSON = JSON(data: data)
                            
                            if let messageJSON = responseJSON["errors"].array?.first {
                                
                                if let message = messageJSON["detail"].string, let status = messageJSON["status"].int {
                                    
                                    let localError = NSError(domain: hostName, code: status, userInfo: [NSLocalizedDescriptionKey : message])
                                    reject(localError)
                                }
                            }
                        }
                        
                        reject(error)
                    }
            }
        }
    }
}


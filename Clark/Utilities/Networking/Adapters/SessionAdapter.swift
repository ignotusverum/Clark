//
//  SessionAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import PromiseKit
import SwiftyJSON

enum SessionInclude: String {
    case student = "student"
    case normal = ""
}

enum SessionFilter: String {
    case upcoming = "time_upcoming"
    case past = "time_past"
    case normal = ""
}

/// Creation struct
struct SessionCreation {
    
    var student: Student?
    
    var startDate: Date?
    var startTime: Date?
    
    var rate: String = ""
    var duration: String = ""
    
    var notes: String = ""
    
    var isRecurring: Bool = false
    var isNeedToRemind: Bool = false
}

/// Creation struct
struct SessionReportCreation {
    
    var progress: String?
    
    /// What went well
    var whatWentWell: [ProgressDimention] = []
    
    /// What needs improvement
    var improvement: [ProgressDimention] = []
    
    var note: String?
    
    var futureNote: String?
}

class SessionAdapter: SynchronizerAdapter {
    
    /// Create session
    ///
    /// - Parameter params: session params
    /// - Returns: session
    class func create(model: SessionCreation?)-> Promise<Session?> {
        
        /// Safety check
        guard let model = model, let studentID = model.student?.id, let startDate = model.startDate, let startTime = model.startTime else {
            return Promise(value: nil)
        }
        
        let dateString = Date.combineDateAndTime(date: startDate, time: startTime).toString(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: dateString) ?? Date()

        /// Rate in cents
        let rateInCents = (model.rate.toInt() ?? 0) * 100
        
        /// Attributes
        let attributes: [String: Any] = ["hourly_rate_in_cents": rateInCents, "duration_in_minutes": model.duration.toInt() ?? 0, "start_time": Date.localDateString(date, format: "yyyy-MM-dd'T'HH:mm:ssZ") ?? "", "is_recurring": model.isRecurring, "tutor_notes": model.notes]
        let params: [String: Any] = ["data": ["attributes" : attributes]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "students/\(studentID)/sessions", parameters: params).then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<Session?> in
        
                /// Safety check
                guard let sessionsJSON = response["data"].json else {
                    return Promise(value: nil)
                }
                
                return DatabaseManager.insertSync(Into<Session>(), source: sessionsJSON)
            }.then { response-> Promise<Session?> in
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<Session?> in
                
                /// Update learning plan with selected dimentions
                return Promise { fulfill, reject in
                    
                    /// Update student with learning plan
                    DatabaseManager.defaultStack.perform(
                        asynchronous: { transaction in
                            
                            let session = transaction.edit(response)
                            let student = transaction.edit(model.student!)
                            
                            session?.student = student
                            
                            fulfill(session)
                    },
                        completion: { _ in })
                }
        }
    }
    
    /// Fetch sessions
    ///
    /// - Parameters:
    ///   - include: include params
    ///   - filter: filter params
    /// - Returns: JSON on success
    class func fetchList(include: SessionInclude = .student, filter: SessionFilter = .normal)-> Promise<[Session]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "sessions?include=\(include.rawValue)&filter=\(filter.rawValue)").then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<[Session]> in
        
                /// Safety check
                guard let sessions = response["data"].array else {
                    return Promise(value: [])
                }
                
                return DatabaseManager.insertASync(Into<Session>(), source: sessions)
            }.then { response-> Promise<[Session]> in
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Fetch session with id
    class func fetch(sessionID: String)-> Promise<Session?> {
        
        /// Api man
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "sessions/\(sessionID)?include=session_report,student").then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<Session?> in
                
                /// Safety check
                guard let sessionJSON = response["data"].json else {
                    return Promise(value: nil)
                }
                
                return DatabaseManager.insertASync(Into<Session>(), source: sessionJSON)
            }.then { response-> Promise<Session?> in
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<Session?> in
                
                return Promise { fulfill, reject in
                    
                    SessionReportAdapter.fetch(session: response, report: response?.sessionReport).then { sessionReport-> Void in
                        
                        /// Update student with learning plan
                        DatabaseManager.defaultStack.perform(
                            asynchronous: { transaction in
                                
                                let session = transaction.edit(response)
                                if let sessionReport = transaction.edit(sessionReport) {
                                    session?.sessionReport = sessionReport
                                }
                        },
                            completion: { _ in })
                        }.catch { error in
                            print(error)
                    }
                    
                    fulfill(response)
                }
        }
    }
    
    class func fetch(session: Session)-> Promise<Session?> {
        return fetch(sessionID: session.id!)
    }
    
    /// Update session with params
    ///
    /// - Parameter dict: Params dict
    /// - Returns: JSON on success
    class func update(_ session: Session, dict: [String: Any]?)-> Promise<Session?> {
        
        /// Safety check
        guard let dict = dict else {
            return Promise(value: nil)
        }
        
        /// Session params
        let dataPams : [String : Any] = ["data":["attributes" : dict]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.patch, path: "sessions/\(session.id!)", parameters: dataPams).then { response-> Promise<Session?> in
            
            guard let tutorDictionary = response["data"].json else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertASync(Into<Session>(), source: tutorDictionary)
            }.then { response-> Promise<Session?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Remove old sessions from database
    ///
    /// - Parameter sessions: students from server
    class func removeOld(_ sessions: [JSON]) {
        
        let sessionsIDs = sessions.flatMap { $0["id"].string }
        
        DatabaseManager.defaultStack.perform(
            asynchronous: { transaction in
                transaction.deleteAll(From<Session>(), Where("NOT (%K IN %@)", ModelAttributes.id.rawValue, sessionsIDs))
        },
            completion: { _ in })
    }
}

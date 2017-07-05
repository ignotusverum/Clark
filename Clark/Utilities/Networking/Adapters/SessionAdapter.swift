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

class SessionAdapter: SynchronizerAdapter {

    /// Fetch sessions
    ///
    /// - Parameters:
    ///   - include: include params
    ///   - filter: filter params
    /// - Returns: JSON on success
    class func sessions(include: SessionInclude = .normal, filter: SessionFilter = .normal)-> Promise<[Session]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "sessions?include=\(include.rawValue)&filter=\(filter.rawValue)").then { response-> Promise<[Session]> in
            
            guard let sessions = response["data"].array else {
                return Promise(value: [])
            }
            
            return DatabaseManager.insertASync(Into<Session>(), source: sessions)
            }.then { response-> Promise<[Session]> in
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Add kickoff session
    ///
    /// - Parameters:
    ///   - tutor: Tutor
    ///   - studentID: Student id
    /// - Returns: JSON on success
    class func add(tutorID: String, studentID: String?)-> Promise<JSON> {
        
        /// Params for request
        var attributes = ["tutor_id": tutorID]
        if let studentId = studentID {
            attributes["student_id"] = studentId
        }
        
        let params = ["data": ["attributes" : attributes]]
        
        /// Networking
        let kickoffMan = KickoffManager.shared
        return kickoffMan.request(.post, path: "add-sessions", parameters: params)
    }
    
    /// Add sesssion feedback
    ///
    /// - Parameters:
    ///   - sessionID: Session id
    ///   - tutorID: tutor id
    /// - Returns: JSON on success
    class func addFeedback(sessionID: String, tutorID: String)-> Promise<JSON> {
        
        /// Params for request
        let attributes = ["tutor_id": tutorID, "session_id": sessionID]
        let params = ["data":["attributes" : attributes]]
        
        /// Networking
        let kickoffMan = KickoffManager.shared
        return kickoffMan.request(.post, path: "init-session-progress-report", parameters: params)
    }
}

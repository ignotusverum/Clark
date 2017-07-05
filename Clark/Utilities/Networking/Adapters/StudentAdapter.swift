//
//  StudentAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Filtering
enum StudentsInclude: String {
    case upcomingSessions = "next_upcoming_session"
    case normal = ""
}

class StudentAdapter: SynchronizerAdapter {

    /// Fetch student with ID
    ///
    /// - Parameter studentID: Student is
    /// - Returns: JSON on success
    class func fetch(studentID: String)-> Promise<JSON> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(studentID)")
    }
    
    /// Fetch list of students for current tutor
    ///
    /// - Parameter filtering: Filtering enum, default empty
    /// - Returns: JSON on success
    class func fetchList(include: StudentsInclude = .normal)-> Promise<[Student]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students?include=\(include.rawValue)").then { response-> Promise<[Student]> in
            
            guard let studentsJSON = response["data"].array else {
                return Promise(value: [])
            }
            
            return DatabaseManager.insertASync(Into<Student>(), source: studentsJSON)
            }.then { response-> Promise<[Student]> in
                
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Fetch sessions for student
    ///
    /// - Parameters:
    ///   - studentID: Strudent s_collection
    ///   - filter: Filter params
    /// - Returns: JSON on success
    class func sessions(studentID: String, filter: SessionFilter = .normal)-> Promise<JSON> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(studentID)+/sessions?filter=\(filter.rawValue)")
    }
}

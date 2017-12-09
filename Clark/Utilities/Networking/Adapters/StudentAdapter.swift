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
    case sessions = "sessions"
    case learningPlans = "active_learning_plan"
    case normal = ""
}

/// Creation struct
struct StudentCreation {
    
    var firstName: String = ""
    var lastName: String = ""
    
    var isUnder13: Bool = false
    
    var phone: String = ""
    var email: String = ""
    
    var subject: Subject?
    
    var rate: String = ""
    var duration: String = ""
    
    var proxy: ProxyCreation?
}

/// Proxy creation
struct ProxyCreation {
    
    var firstName: String = ""
    var lastName: String = ""
    
    var phoneNumber: String = ""
    var email: String = ""
    
    var relation: String = ""
}

/// Learning plan creation
struct LearningPlanCreation {
    
    var subject: Subject?
    
    var cancelation: String = ""
    
    var frequency: String = ""
    var endDate: Date?
    
    var goalsNote: String = ""
    
    var progressDimention: [ProgressDimention] = []
    
    var outsideWork: String = ""
    var expectedNode: String = ""
}

class StudentAdapter: SynchronizerAdapter {
    
    /// Fetch student with ID
    ///
    /// - Parameter studentID: Student is
    /// - Returns: JSON on success
    class func fetch(studentID: String, include: StudentsInclude = .learningPlans)-> Promise<Student?> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(studentID)?include=\(include.rawValue),primary_proxy,subjects,next_upcoming_session").then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<Student?> in
        
                /// Safety check
                guard let studentsJSON = response["data"].json else {
                    return Promise(value: nil)
                }
                
                return DatabaseManager.insertASync(Into<Student>(), source: studentsJSON)
            }.then { response-> Promise<Student?> in
                
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Student? in
                
                /// Fetch subjects for student
                let _ = SubjectAdapter.subject(student: response)
                
                return response
        }
    }
    
    /// Update student object with rate / duration
    class func update(student: Student, rate: String, duration: String)-> Promise<Student?> {
        
        /// Attributes
        let attributes = ["default_hourly_rate_in_cents": "\((rate.toInt() ?? 0) * 100)", "default_session_length_in_minutes": duration]
        let params: [String: Any] = ["data": ["attributes" : attributes]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "students/\(student.id!)", parameters: params).then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<Student?> in
                
                /// Safety check
                guard let studentsJSON = response["data"].json else {
                    return Promise(value: nil)
                }
                
                return DatabaseManager.insertSync(Into<Student>(), source: studentsJSON)
            }.then { response-> Promise<Student?> in
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Set cancelation for learning plan
    /// - Parameter cancelation: canceltion type
    class func setCancelation(_ cancelation: String, student: Student)-> Promise<JSON> {
        
        let params = ["cancellation_policy_name": cancelation]
        let requestParams: [String: Any] = ["data": ["attributes" : params]]
        
        /// Networking
        let netman = APIManager.shared
        return netman.request(.put, path: "students/\(student.id!)", parameters: requestParams)
    }
    
    /// Fetch sessions for student with ID
    ///
    /// - Parameter studentID: Student is
    /// - Returns: JSON on success
    class func sessions(student: Student)-> Promise<Session?> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(student.id!)/sessions").then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<Session?> in
                
                /// Safety check
                guard let sessionsJSON = response["data"].json else {
                    return Promise(value: nil)
                }
                
                return DatabaseManager.insertASync(Into<Session>(), source: sessionsJSON)
            }.then { response-> Promise<Session?> in
                
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Fetch list of students for current tutor
    ///
    /// - Parameter filtering: Filtering enum, default empty
    /// - Returns: JSON on success
    class func fetchList(include: StudentsInclude = .upcomingSessions)-> Promise<[Student]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students?include=\(include.rawValue)").then { response-> Promise<JSON> in
                
                /// Save include data
                return ModelHelper.include(source: response)
            }.then { response-> Promise<[Student]> in
                
                /// Safety check
                guard let studentsJSON = response["data"].array else {
                    return Promise(value: [])
                }
                
                /// Remove old
                removeOld(studentsJSON)
            
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
        
    /// Create student from temp model
    ///
    /// - Parameter model: temp model
    /// - Returns: student
    class func create(model: StudentCreation?)-> Promise<Student?> {
        
        /// Safety check
        guard let model = model else {
            return Promise(value: nil)
        }
        
        /// Attributes
        let attributes = ["first_name": model.firstName, "last_name": model.lastName, "email": model.email, "phone": model.phone, "default_hourly_rate_in_cents": "\((model.rate.toInt() ?? 0) * 100)", "default_session_length_in_minutes": model.duration]
        let params: [String: Any] = ["data": ["attributes" : attributes]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "students", parameters: params).then { response-> Promise<JSON> in
            
            /// Save include data
            return ModelHelper.include(source: response)
            }.then { response-> Promise<Student?> in
        
                /// Safety check
                guard let studentsJSON = response["data"].json else {
                    return Promise(value: nil)
                }
                
                return DatabaseManager.insertSync(Into<Student>(), source: studentsJSON)
            }.then { response-> Promise<Student?> in
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Create proxy for student
    ///
    /// - Parameters:
    ///   - model: proxy temp model
    ///   - student: student for creation
    class func createProxy(model: ProxyCreation?, student: Student?)-> Promise<Student?> {
        
        guard let proxy = model else {
            return Promise(value: student)
        }
        
        guard let student = student else {
            return Promise(value: nil)
        }
        
        /// Attributes
        let attributes = ["first_name": proxy.firstName, "last_name": proxy.lastName, "email": proxy.email, "phone": proxy.phoneNumber]
        let params: [String: Any] = ["data": ["attributes" : attributes]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "students/\(student.id!)/proxies", parameters: params).then { response-> Student? in
            
            return student
        }
    }
    
    /// Remove old students from database
    ///
    /// - Parameter requests: students from server
    class func removeOld(_ students: [JSON]) {
        
        let studentIDs = students.flatMap { $0["id"].string }
        
        DatabaseManager.defaultStack.perform(
            asynchronous: { transaction in
                transaction.deleteAll(From<Student>(), Where("NOT (%K IN %@)", ModelAttributes.id.rawValue, studentIDs))
        },
            completion: { _ in })
    }
}


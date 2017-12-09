//
//  SubjectAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/28/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import PromiseKit
import SwiftyJSON

class SubjectAdapter: SynchronizerAdapter {

    /// Fetch subjects list
    ///
    /// - Returns: Subjects array
    class func fetch()-> Promise<[Subject]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "available_subjects").then { response-> Promise<[Subject]> in
            
            guard let subjectsJSON = response["data"].array else {
                return Promise(value: [])
            }
            
            /// Remove old
            removeOld(subjectsJSON)
            
            return DatabaseManager.insertASync(Into<Subject>(), source: subjectsJSON)
            }.then { response-> Promise<[Subject]> in
                
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Fetch subjects for current tutor
    ///
    /// - Returns: Subjects array
    class func fetchForMe()-> Promise<[Subject]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "relationships/subjects").then { response-> Promise<[Subject]> in
            
            guard let subjectsJSON = response["data"].array else {
                return Promise(value: [])
            }
            
            return DatabaseManager.insertASync(Into<Subject>(), source: subjectsJSON)
            }.then { response-> Promise<[Subject]> in
                
                return DatabaseManager.fetchExisting(response)
            }.then { response-> [Subject] in
                
                let config = Config.shared
                let tutor = config.currentTutor!
                
                /// Update subjects
                tutor.subjects = NSSet(array: response)
                for subject in response {
                    subject.tutor = tutor
                }
                
                return response
        }
    }
    
    /// Fetch dimentions for subjects
    class func fetchDimentions(subject: Subject?)-> Promise<[ProgressDimention]> {
        
        guard let subject = subject else {
            return Promise(value: [])
        }
        
        /// Networking request
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "available_subjects/\(subject.id!)/available_progress_dimensions").then { response-> Promise<[ProgressDimention]> in
            
            guard let subjectsJSON = response["data"].array else {
                return Promise(value: [])
            }
            
            return DatabaseManager.insertSync(Into<ProgressDimention>(), source: subjectsJSON)
            }.then { response-> Promise<[ProgressDimention]> in
                
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<[ProgressDimention]> in
                
                return Promise { fulfill, reject in
                 
                    DatabaseManager.defaultStack.perform(
                        asynchronous: { transaction in
                            
                            let subject = transaction.edit(subject)
                            let dimentions = response.flatMap { transaction.edit($0) }
                            
                            subject?.addDimentions(NSSet(array: dimentions))
                            
                            fulfill(dimentions)
                    },
                        completion: { _ in })
                }
        }
    }
    
    /// Fetch subjects for student
    class func subject(student: Student?)-> Promise<[Subject]> {
        
        /// Safety check
        guard let student = student else {
            return Promise(value: [])
        }
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(student.id!)/relationships/subjects").then { response-> Promise<[Subject]> in
            
            guard let subjectsJSON = response["data"].array else {
                return Promise(value: [])
            }
            
            return DatabaseManager.insertASync(Into<Subject>(), source: subjectsJSON)
            }.then { response-> Promise<[Subject]> in
                
                return DatabaseManager.fetchExisting(response)
            }.then { response-> [Subject] in
                
                for subject in response {
                    
                    subject.addStudentObject(student)
                    student.addSubjectsObject(subject)
                }
                
                return response
        }
    }
    
    /// Add subject to learning plan
    class func addLearningPlanSubject(subjectID: String?, student: Student?)-> Promise<Bool> {
        
        /// Safety check
        guard let subjectID = subjectID, let student = student, let learningPlan = student.learningPlanArray.first else {
            return Promise(value: false)
        }
        
        /// Params setup
        let dataPams : [String : Any] = ["data": ["type": "subjects", "id": subjectID]]
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "learning_plans/\(learningPlan.id!)/relationships/subjects", parameters: dataPams).then { response-> Bool in
            return true
        }
    }
    
    /// Add subject to student
    class func addSubject(subjectID: String?, student: Student?)-> Promise<Bool> {
        
        /// Safety check
        guard let subjectID = subjectID, let student = student else {
            return Promise(value: false)
        }
        
        /// Params setup
        let dataPams : [String : Any] = ["data": ["type": "subjects", "id": subjectID]]
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "students/\(student.id!)/relationships/subjects", parameters: dataPams).then { response-> Bool in
            
            return true
        }
    }
    
    class func removeOld(_ students: [JSON]) {
        
        let subjectsIDs = students.flatMap { $0["id"].string }
        
        DatabaseManager.defaultStack.perform(
            asynchronous: { transaction in
                transaction.deleteAll(From<Subject>(), Where("NOT (%K IN %@)", ModelAttributes.id.rawValue, subjectsIDs))
        },
            completion: { _ in })
    }
    
    /// Add subject to current tutor with id
    class func addSubjects(subjectIDs: [[String: Any]])-> Promise<[Subject]> {
        
        /// Tutor
        let config = Config.shared
        let tutor = config.currentTutor!
        
        /// Old subjects
        let ids: [[String: Any]] = tutor.subjectsArray.map { ["type": "subjects", "id": $0.id] }
        
        /// Params setup
        let dataPams: [String : Any] = ["data": subjectIDs + ids]
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "relationships/subjects", parameters: dataPams).then { response-> Promise<[Subject]> in
            
            /// Safety check
            guard let subjectJSON = response["data"].array else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertASync(Into<Subject>(), source: subjectJSON)
            }.then { response-> Promise<[Subject]> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
}

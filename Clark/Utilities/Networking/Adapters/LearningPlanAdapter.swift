//
//  LearningPlanAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/12/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import PromiseKit
import SwiftyJSON

class LearningPlanAdapter: SynchronizerAdapter {

    /// Fetch learning plan
    class func fetch(student: Student?, learningPlanID: String?)-> Promise<LearningPlan?> {
        
        /// Safety check
        guard let student = student, let learningPlanID = learningPlanID else {
            return Promise(value: nil)
        }
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(student.id!)/learning_plans/\(learningPlanID)").then { response-> Promise<LearningPlan?> in
            
            /// Safety check
            guard let learningPlanJSON = response["data"].json else {
                throw GeneralError
            }
            
            return DatabaseManager.insertSync(Into<LearningPlan>(), source: learningPlanJSON)
            }.then { response-> Promise<LearningPlan?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<LearningPlan?> in
                /// Update learning plan with selected dimentions
                return Promise { fulfill, reject in
                    
                    /// Update student with learning plan
                    DatabaseManager.defaultStack.perform(
                        asynchronous: { transaction in
                            
                            let student = transaction.edit(student)
                            if let learningPlan = transaction.edit(response) {
                                
                                student?.addLearningPlansObject(learningPlan)
                            }
                    },
                        completion: { _ in })
                    
                    fulfill(response)
                }
        }
    }
    
    /// Add progress dimention to learning plan
    class func addDimentions(dimentionIDs: [ProgressDimention], student: Student?, learningPlan: LearningPlan?)-> Promise<[ProgressDimention]> {
        
        /// Safety check
        guard let student = student, let learningPlan = learningPlan else {
            return Promise(value: [])
        }
        
        /// Dimentions id
        let ids: [[String: Any]] = dimentionIDs.map { ["type": "progress_dimensions", "id": $0.id] }
        
        /// Params setup
        let dataPams: [String : Any] = ["data": ids, "student_id": student.id]
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "learning_plans/\(learningPlan.id!)/relationships/progress_dimensions", parameters: dataPams).then { response-> Promise<[ProgressDimention]> in
            
            /// Safety check
            guard let subjectJSON = response["data"].array else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertSync(Into<ProgressDimention>(), source: subjectJSON)
            }.then { response-> Promise<[ProgressDimention]> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
            }.then { response-> [ProgressDimention] in
                
                /// Update student with learning plan
                DatabaseManager.defaultStack.perform(
                    asynchronous: { transaction in
                        
                        let learningPlan = transaction.edit(learningPlan)
                        let dimentions = response.flatMap { transaction.edit($0) }
                        learningPlan?.addDimentions(NSSet(array: dimentions))
                },
                    completion: { _ in })
                
                return response
        }
    }
    
    /// Fetch learning plan dimentions
    class func fetchDimentions(learningPlan: LearningPlan?)-> Promise<[ProgressDimention]> {
        
        /// Safety check
        guard let learningPlan = learningPlan, let student = learningPlan.student else {
            return Promise(value: [])
        }
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "students/\(student.id!)/learning_plans/\(learningPlan.id!)/relationships/progress_dimensions").then { response-> Promise<[ProgressDimention]> in
            
            /// Safety check
            guard let subjectJSON = response["data"].array else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertSync(Into<ProgressDimention>(), source: subjectJSON)
            }.then { response-> Promise<[ProgressDimention]> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
            }.then { response-> [ProgressDimention] in
                
                /// Update student with learning plan
                DatabaseManager.defaultStack.perform(
                    asynchronous: { transaction in
                        
                        let learningPlan = transaction.edit(learningPlan)
                        let dimentions = response.flatMap { transaction.edit($0) }
                        learningPlan?.addDimentions(NSSet(array: dimentions))
                },
                    completion: { _ in })
                
                return response
        }
    }
    
    /// Send learning plan to the client
    class func sendToClient(learningPlan: LearningPlan?)-> Promise<JSON> {
        
        /// Safety check
        guard let learningPlan = learningPlan else {
            return Promise(value: false)
        }
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "learning_plans/\(learningPlan.id!)/send_to_client")
    }
    
    /// Create learning plan
    class func create(student: Student, model: LearningPlanCreation)-> Promise<LearningPlan?> {
    
        /// Params for request
        let params = ["objectives": model.goalsNote, "engagement_interval": model.frequency.lowercased(), "expected_outside_work_in_hours": model.outsideWork]
        let requestParams: [String: Any] = ["data": ["attributes" : params]]
        
        /// Networking request
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "students/\(student.id!)/learning_plans", parameters: requestParams).then { response-> Promise<LearningPlan?> in
            
            /// Safety check
            guard let learningPlanJSON = response["data"].json else {
                throw GeneralError
            }
            
            return DatabaseManager.insertSync(Into<LearningPlan>(), source: learningPlanJSON)
            }.then { response-> Promise<LearningPlan?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<LearningPlan?> in
                
                /// Update learning plan with selected dimentions
                return Promise { fulfill, reject in
                 
                    /// Update student with learning plan
                    DatabaseManager.defaultStack.perform(
                        asynchronous: { transaction in
                            
                            let student = transaction.edit(student)
                            if let learningPlan = transaction.edit(response) {
                             
                                student?.addLearningPlansObject(learningPlan)
                            }
                    },
                        completion: { _ in })
                    
                    /// Update selected dimentions
                    addDimentions(dimentionIDs: model.progressDimention, student: student, learningPlan: response).then { dimentions-> Void in
                        
                        fulfill(response)
                        }.catch { error in
                            reject(error)
                    }
                }
            }.then { response-> LearningPlan? in
                
                /// Add subjects to lp
                let _ = SubjectAdapter.addLearningPlanSubject(subjectID: model.subject?.id, student: student)
                
                return response
        }
    }
}

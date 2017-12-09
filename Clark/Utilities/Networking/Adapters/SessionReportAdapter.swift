//
//  SessionReportAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import PromiseKit
import SwiftyJSON

enum SessionReportDimentionType: String {
    case improvement = "improvement"
    case regression = "regression"
}

class SessionReportAdapter: SynchronizerAdapter {
    
    /// Assign dimentions
    class func dimentions(session: Session?, sessionReport: SessionReport?, dimention: ProgressDimention, type: SessionReportDimentionType)-> Promise<ProgressDimention?> {
        
        /// Safetty check
        guard let session = session, let sessionReport = sessionReport else {
            return Promise(value: nil)
        }
        
        /// Dimentions id
        let dimentionID: [String: Any] = ["progress_type": type.rawValue]
        
        /// Params setup
        let dataPams: [String: Any] = ["data": ["attributes" : dimentionID]]
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "sessions/\(session.id!)/session_reports/\(sessionReport.id!)/progress/\(dimention.id!)", parameters: dataPams).then { response-> Promise<ProgressDimention?> in
        
            /// Safety check
            guard let dimentionsJSON = response["data"].json else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertSync(Into<ProgressDimention>(), source: dimentionsJSON)
            }.then { response-> Promise<ProgressDimention?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<ProgressDimention?> in
                return Promise { fulfill, reject in
                    
                    /// Update session report with dimentions
                    DatabaseManager.defaultStack.perform(
                        asynchronous: { transaction in
                            
                            /// Safety check
                            guard let response = response, let dimention = transaction.edit(response) else {
                                fulfill(nil)
                                return
                            }
                            
                            let sessionReport = transaction.edit(sessionReport)
                            
                            /// Improvement rype type
                            if type == .regression {
                                sessionReport?.addImprovementDimentionsObject(dimention)
                            }
                            else {
                                /// Recurstion type
                                sessionReport?.addRecursionDimentionsObject(dimention)
                            }
                            
                            fulfill(response)
                    },
                        completion: { _ in })
                }
        }
    }
    
    /// Fetch session reports
    class func fetch(session: Session?, report: SessionReport?)-> Promise<SessionReport?> {
        
        /// Safety check
        guard let session = session, let report = report else {
            return Promise(value: nil)
        }
        
        /// Api call
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "sessions/\(session.id!)/session_reports/\(report.id!)/progress").then { response-> Promise<SessionReport?> in
            
            /// Safety check
            guard let dimentionsJSON = response["data"].json else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertSync(Into<SessionReport>(), source: dimentionsJSON)
            }.then { response-> Promise<SessionReport?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Update session status
    class func statusUpdate(session: Session)-> Promise<Session?> {
        
        /// Safety check
        guard let reportID = session.sessionReport?.id else {
            return Promise(value: nil)
        }
        
        /// Params for request
        let requestParams: [String: Any] = ["data": ["attributes" : ["status": "complete"]]]
        
        /// Networking request
        let apiMan = APIManager.shared
        return apiMan.request(.put, path: "sessions/\(session.id!)/session_reports/\(reportID)", parameters: requestParams).then { response-> Promise<Session?> in
            
            /// Safety check
            guard let sessionReportJSON = response["data"].json else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertSync(Into<Session>(), source: sessionReportJSON)
        }
    }
    
    /// Create session report for session
    class func create(session: Session, model: SessionReportCreation)-> Promise<SessionReport?> {
        
        /// Params for request
        let params = ["body": model.note ?? "", "expected_student_followup": model.futureNote ?? "", "rating": model.progress ?? ""]
        let requestParams: [String: Any] = ["data": ["attributes" : params], "status": "complete"]
        
        /// Networking request
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "sessions/\(session.id!)/session_reports", parameters: requestParams).then { response-> Promise<SessionReport?> in
            
            /// Safety check
            guard let sessionReportJSON = response["data"].json else {
                throw TutorAdapterErrors.update
            }
            
            return DatabaseManager.insertSync(Into<SessionReport>(), source: sessionReportJSON)
            }.then { response-> Promise<SessionReport?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
            }.then { response-> Promise<SessionReport?> in
                
                /// Update learning plan with selected dimentions
                return Promise { fulfill, reject in
                    
                    /// Update student with learning plan
                    DatabaseManager.defaultStack.perform(
                        asynchronous: { transaction in
                            
                            let session = transaction.edit(session)
                            let report = transaction.edit(response)
                            
                            session?.sessionReport = report
                            
                            fulfill(report)
                    },
                        completion: { _ in })
                }
            }.then { response-> Promise<SessionReport?> in
                
                /// Update all dimentinos
                return Promise { fulfill, reject in
        
                    /// Update improvement dimentions
                    for improvementDimention in model.improvement {
                        let _ = dimentions(session: session, sessionReport: response, dimention: improvementDimention, type: .improvement)
                    }
                    
                    /// Update regression dimentions
                    for regression in model.whatWentWell {
                        let _ = dimentions(session: session, sessionReport: response, dimention: regression, type: .regression)
                    }
                    
                    fulfill(response)
                }
        }
    }
}

//
//  ModelHelper.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

public enum ModelType:String {
    case students = "students"
    case sessions = "sessions"
    case learningPlans = "learning_plans"
    case proxies = "proxies"
    case sessionReport = "session_report"
}

class ModelHelper {
    
    class func include(source: JSON)-> Promise<JSON> {
        return Promise { fulfill, reject in
            
            if let includedArray = source["included"].array  {
                for dictionary in includedArray {
                    guard let type = dictionary["type"].string else {
                        continue
                    }
                    
                    switch type {
                    case ModelType.students.rawValue:
                        let _ = DatabaseManager.insertASync(Into<Student>(), source: dictionary)
                    case ModelType.sessions.rawValue:
                        let _ = DatabaseManager.insertASync(Into<Session>(), source: dictionary)
                    case ModelType.learningPlans.rawValue:
                        let _ = DatabaseManager.insertASync(Into<LearningPlan>(), source: dictionary)
                    case ModelType.proxies.rawValue:
                        let _ = DatabaseManager.insertASync(Into<Proxy>(), source: dictionary)
                    case ModelType.sessionReport.rawValue:
                        let _ = DatabaseManager.insertASync(Into<SessionReport>(), source: dictionary)
                    default: break
                    }
                }
            }
            
            fulfill(source)
        }
    }
}


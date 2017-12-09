//
//  KickOffAction.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

enum ActionSheetType: String {
    case student = "Add Student"
    case session = "Schedule Session"
    case feedback = "Create Session Report"
    case profile = "Create Profile"
    case cancel = "Cancel Session"
    case reschedule = "Reschedule Session"
}

struct ActionSheetModel {
    
    /// Title
    var title: String
    
    /// Type
    var type: ActionSheetType
    
    /// Type image
    var image: UIImage {
        
        switch type {
        case .cancel:
            return #imageLiteral(resourceName: "cancel_session_icon")
        case .feedback:
            return #imageLiteral(resourceName: "session_report_icon")
        case .profile:
            return #imageLiteral(resourceName: "create_profile_icon")
        case .reschedule:
            return #imageLiteral(resourceName: "reschedule_icon")
        case .session:
            return #imageLiteral(resourceName: "new_session_icon")
        case .student:
            return #imageLiteral(resourceName: "add_student_icon")
        }
    }
    
    /// Initialization
    init(type: ActionSheetType) {
        self.type = type
        self.title = type.rawValue
    }
}

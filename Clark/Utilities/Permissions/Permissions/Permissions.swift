//
//  Permissions.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

public struct PermissionsJSON {
    
    static let profile = "tutoring_profile"
    
    static let paymentGuarantee = "payment_guarantee"
    
    static let cancellationPolicy = "can_set_cancellation_policy"
    
    static let ccInvoices = "credit_card_invoices"
    static let ccPayments = "credit_card_payments"
    static let ccReminders = "credit_card_payment_reminders"
    
    static let learningPlans = "learning_plans"
    
    static let sessions = "session_add"
    static let sessionsReports = "session_reports"
    static let sessionsReminders = "session_reminders"
    static let sessionsBooking = "automated_session_booking"
    
    static let responseTime = "clarker_response_time"
    
    static let clientContracts = "client_contracts"
    
    static let backgroundCheck = "background_check"
    
    static let students = "student_add"
}

/// Application permissions based on plan
class Permissions {
    
    /// Session report pemission
    var sessionReport: Permission?
    
    /// Tutoring profile permission
    var tutoringProfile: ProfilePermissions?
    
    /// Credit card invoice permission
    var ccInvoice: Permission?
    
    /// Learning plan permission
    var learningPlans: Permission?
    
    /// Clarker response time permission
    var clarkerResponseTime: Permission?
    
    /// Credit card payment reminder permission
    var ccPaymentReminder: Permission?
    
    /// Cancellation policy
    var cancellationPolicy: Permission?
    
    /// Client contracts permission
    var clientContracts: Permission?
    
    /// CC payment permissions
    var ccPayments: Permission?
    
    /// Payment guarantee permission
    var paymentGuarantee: Permission?
    
    /// Session add permission
    var sessionAdd: Permission?
    
    /// Automated session booking permission
    var automatedSessionBooking: Permission?
    
    /// Payment reminders
    var ccReminders: Permission?
    
    /// Session reminders permission
    var sessionReminders: Permission?
    
    /// Background check permission
    var backgroundCheck: BackgroundCheckPermissions?
    
    /// Student add permission
    var studentAdd: StudentAddPermissions?
    
    /// Initialization
    init(source: JSON) {

        /// Session report init
        sessionReport = Permission(source: source[PermissionsJSON.sessionsReports].json)
        
        /// Cancellation policy
        cancellationPolicy = Permission(source: source[PermissionsJSON.sessionsReports].json)
        
        /// Tutoring profile init
        tutoringProfile = ProfilePermissions(source: source[PermissionsJSON.profile].json)
        
        /// Tutoring profile init
        ccInvoice = Permission(source: source[PermissionsJSON.ccInvoices].json)
        
        /// Learning plans init
        learningPlans = Permission(source: source[PermissionsJSON.learningPlans].json)
        
        /// Clarker response time init
        clarkerResponseTime = Permission(source: source[PermissionsJSON.responseTime].json)
        
        /// Credit card payment reminders
        ccReminders = Permission(source: source[PermissionsJSON.ccReminders].json)
        
        /// Client contracts
        clientContracts = Permission(source: source[PermissionsJSON.clientContracts].json)
        
        /// Credit card payments
        ccPayments = Permission(source: source[PermissionsJSON.ccPayments].json)
        
        /// Payment guarantee
        paymentGuarantee = Permission(source: source[PermissionsJSON.paymentGuarantee].json)
        
        /// Session add
        sessionAdd = Permission(source: source[PermissionsJSON.sessions].json)
        
        /// Automated session booking
        automatedSessionBooking = Permission(source: source[PermissionsJSON.sessionsBooking].json)
        
        /// Session reminders
        sessionReminders = Permission(source: source[PermissionsJSON.sessionsReminders].json)
        
        /// Background check
        backgroundCheck = BackgroundCheckPermissions(source: source[PermissionsJSON.backgroundCheck].json)
        
        /// Background check
        studentAdd = StudentAddPermissions(source: source[PermissionsJSON.backgroundCheck].json)
    }
}

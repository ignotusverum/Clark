//
//  FlowsProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

protocol FlowsProtocol {
    
    /// Flow controllers
    var controllers: [UIViewController] { get set }
    
    /// Title
    var navTitle: String { get set }
    
    /// Number of steps
    var numberOfSteps: Int { get set }
    
    /// Current step
    var currentStep: Int { get set }
}

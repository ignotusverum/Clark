//
//  ConfettiView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import QuartzCore

class ConfettiView: UIView {
    
    var emitter: CAEmitterLayer!
    var colors: [UIColor]!
    var intensity: Float!
    
    fileprivate var active :Bool!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
    }
    
    func setup() {
        emitter = CAEmitterLayer()
        
        colors = [UIColor.ColorWith(red: 255, green: 103, blue: 93, alpha: 1),
                  UIColor.ColorWith(red: 252, green: 203, blue: 232, alpha: 1),
                  UIColor.ColorWith(red: 273, green: 180, blue: 135, alpha: 1),
                  UIColor.magenta,
                  UIColor.orange
        ]
        
        intensity = 0.6
        
        active = false
    }
    
    func startConfetti() {
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: -20)
        emitter.emitterShape = kCAEmitterLayerLine
        
        var cells = [CAEmitterCell]()
        for (index, color) in colors.enumerated() {
            cells.append(confettiWithColor(color, index: index))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    func confettiWithColor(_ color: UIColor, index: Int) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        
        confetti.name = "\(index)"
        confetti.birthRate = 4 * intensity
        confetti.lifetime = 180 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(250 * intensity)
        confetti.velocityRange = CGFloat(80 * intensity)
        confetti.emissionLongitude = CGFloat.pi
        confetti.emissionRange = CGFloat.pi/4
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4 * intensity)
        
        confetti.alphaSpeed = -1 / 180 * intensity
        confetti.redSpeed = -1 / 180 * intensity
        confetti.blueSpeed = -1 / 180 * intensity
        confetti.greenSpeed = -1 / 180 * intensity
        
        confetti.contents = UIImage(named: "confetti")?.cgImage
        return confetti
    }
    
    internal func isActive() -> Bool {
        return self.active
    }
}

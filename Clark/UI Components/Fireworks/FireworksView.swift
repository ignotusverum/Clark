//
//  FireworksView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/14/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import QuartzCore

class FireworksView: UIView {
    
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
        emitter.emitterPosition = CGPoint(x: frame.size.width / 4.0, y: -20)
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
        
        confetti.emissionLongitude = CGFloat.pi/2
        confetti.emissionLatitude = 0
        confetti.lifetime = 2.6
        confetti.birthRate = 3
        confetti.velocity = 300
        confetti.velocityRange = 100
        confetti.yAcceleration = 150
        confetti.emissionRange = CGFloat.pi/4

        confetti.redRange = 0.9;
        confetti.greenRange = 0.9;
        confetti.blueRange = 0.9;
        confetti.name = "base"
        
        let flareCell =  CAEmitterCell()
        flareCell.contents = UIImage(named: "confetti")?.cgImage
        flareCell.emissionLongitude = 2 * CGFloat.pi
        flareCell.scale = 0.4;
        flareCell.velocity = 80;
        flareCell.birthRate = 25;
        flareCell.lifetime = 0.5;
        flareCell.yAcceleration = -350;
        flareCell.emissionRange = CGFloat.pi/7
        flareCell.alphaSpeed = -0.7;
        flareCell.scaleSpeed = -0.1;
        flareCell.scaleRange = 0.1;
        flareCell.beginTime = 0.01;
        flareCell.duration = 1.7;
        
        let fireworkCell = CAEmitterCell()
        
        fireworkCell.contents = UIImage(named: "confetti")?.cgImage
        fireworkCell.birthRate = 250;
        fireworkCell.scale = 0.6;
        fireworkCell.velocity = 130;
        fireworkCell.lifetime = 100;
        fireworkCell.alphaSpeed = -0.2;
        fireworkCell.yAcceleration = -80;
        fireworkCell.beginTime = 1.5;
        fireworkCell.duration = 0.1;
        fireworkCell.emissionRange = CGFloat.pi * 2
        fireworkCell.scaleSpeed = -0.1;
        fireworkCell.spin = 2;
        
        confetti.emitterCells = [flareCell, fireworkCell]
        
        return confetti
    }
    
    internal func isActive() -> Bool {
        return self.active
    }
}


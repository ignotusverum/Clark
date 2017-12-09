//
//  BearLogoView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import EZSwiftExtensions

struct BearAnimationModel {
    
    var rightEarLayer: CAShapeLayer?
    var colorLayers: [CAShapeLayer] = []
    
    var noseTipLayer: CAShapeLayer?
    
    var fillColor = UIColor(red: 0.922, green: 0.914, blue: 0.882, alpha: 1)
    var strokeColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.000)
}

class BearLogoView: UIView {
    
    var animationModel = BearAnimationModel()
    
    var pencilLoaderLayer: CAShapeLayer!
    
    var pencilBaseLayer: CAShapeLayer!
    
    override func draw(_ rect: CGRect) {
        self.drawFace(frame: bounds)
        self.drawLoader(frame: CGRect(x: 0, y: 90, width: 65, height: 22))
        
        loaderAnimation()
        
        let _ = ez.runThisEvery(seconds: 5, startAfterSeconds: 2) { _ in
            self.rightEarAnimation()
        }
    }
    
    func drawLoader(frame: CGRect = CGRect(x: 0, y: 0, width: 130, height: 45)) {
        //// Color Declarations
        let fillColor = UIColor(red: 0.780, green: 0.651, blue: 0.553, alpha: 1.000)
        let fillColor2 = UIColor(red: 0.257, green: 0.253, blue: 0.261, alpha: 1.000)
        let strokeColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.000)
        
        //// Subframes
        let mainFrame: CGRect = CGRect(x: frame.minX + 6, y: frame.minY + 3, width: frame.width - 10.1, height: frame.height - 3.95)
        
        pencilLoaderLayer = CAShapeLayer()
        pencilLoaderLayer.path = UIBezierPath(rect: frame).cgPath
        
        pencilLoaderLayer.fillColor = UIColor.clear.cgColor
        
        //// Group 2
        //// Clip Drawing
        let pencilPath = UIBezierPath()
        pencilPath.move(to: CGPoint(x: mainFrame.minX + 0.84020 * mainFrame.width, y: mainFrame.minY + 0.78849 * mainFrame.height))
        pencilPath.addLine(to: CGPoint(x: mainFrame.minX + 0.72283 * mainFrame.width, y: mainFrame.minY + 0.92010 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.67689 * mainFrame.width, y: mainFrame.minY + 0.97163 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.70752 * mainFrame.width, y: mainFrame.minY + 0.93728 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.69220 * mainFrame.width, y: mainFrame.minY + 0.95445 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.65993 * mainFrame.width, y: mainFrame.minY + 0.99065 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.67124 * mainFrame.width, y: mainFrame.minY + 0.97796 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.66560 * mainFrame.width, y: mainFrame.minY + 0.98448 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.64179 * mainFrame.width, y: mainFrame.minY + 0.97438 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.64981 * mainFrame.width, y: mainFrame.minY + 1.00166 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.64344 * mainFrame.width, y: mainFrame.minY + 1.00962 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.64113 * mainFrame.width, y: mainFrame.minY + 0.63586 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.63667 * mainFrame.width, y: mainFrame.minY + 0.86506 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.64073 * mainFrame.width, y: mainFrame.minY + 0.74588 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.64576 * mainFrame.width, y: mainFrame.minY + 0.29793 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.64154 * mainFrame.width, y: mainFrame.minY + 0.52311 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.64282 * mainFrame.width, y: mainFrame.minY + 0.41036 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.65240 * mainFrame.width, y: mainFrame.minY + 0.15219 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.64703 * mainFrame.width, y: mainFrame.minY + 0.24909 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.64861 * mainFrame.width, y: mainFrame.minY + 0.20010 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.66898 * mainFrame.width, y: mainFrame.minY + 0.12664 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.65532 * mainFrame.width, y: mainFrame.minY + 0.11536 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.65745 * mainFrame.width, y: mainFrame.minY + 0.11048 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.69984 * mainFrame.width, y: mainFrame.minY + 0.17258 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.67940 * mainFrame.width, y: mainFrame.minY + 0.14123 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.68957 * mainFrame.width, y: mainFrame.minY + 0.15728 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.79795 * mainFrame.width, y: mainFrame.minY + 0.31861 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.73254 * mainFrame.width, y: mainFrame.minY + 0.22125 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.76525 * mainFrame.width, y: mainFrame.minY + 0.26993 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.98411 * mainFrame.width, y: mainFrame.minY + 0.59569 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.86000 * mainFrame.width, y: mainFrame.minY + 0.41097 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.92206 * mainFrame.width, y: mainFrame.minY + 0.50333 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.99615 * mainFrame.width, y: mainFrame.minY + 0.61362 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.98812 * mainFrame.width, y: mainFrame.minY + 0.60168 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.99214 * mainFrame.width, y: mainFrame.minY + 0.60765 * mainFrame.height))
        pencilPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.84020 * mainFrame.width, y: mainFrame.minY + 0.78849 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.94416 * mainFrame.width, y: mainFrame.minY + 0.67191 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.89218 * mainFrame.width, y: mainFrame.minY + 0.73020 * mainFrame.height))
        
        let pencilLayer = CAShapeLayer()
        pencilLayer.path = pencilPath.cgPath
        
        pencilLayer.fillColor = fillColor.cgColor
        
        //// Clip 2 Drawing
        let pencilTipPath = UIBezierPath()
        pencilTipPath.move(to: CGPoint(x: mainFrame.minX + 0.89093 * mainFrame.width, y: mainFrame.minY + 0.45408 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.90344 * mainFrame.width, y: mainFrame.minY + 0.47168 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.89604 * mainFrame.width, y: mainFrame.minY + 0.46224 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.89900 * mainFrame.width, y: mainFrame.minY + 0.46630 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.92713 * mainFrame.width, y: mainFrame.minY + 0.50239 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.90957 * mainFrame.width, y: mainFrame.minY + 0.47913 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.92148 * mainFrame.width, y: mainFrame.minY + 0.49257 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.98966 * mainFrame.width, y: mainFrame.minY + 0.59702 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.94894 * mainFrame.width, y: mainFrame.minY + 0.54033 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.96685 * mainFrame.width, y: mainFrame.minY + 0.56358 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 1.00000 * mainFrame.width, y: mainFrame.minY + 0.61605 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.99334 * mainFrame.width, y: mainFrame.minY + 0.60242 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.99703 * mainFrame.width, y: mainFrame.minY + 0.60811 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.96227 * mainFrame.width, y: mainFrame.minY + 0.65491 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.98743 * mainFrame.width, y: mainFrame.minY + 0.62900 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.97485 * mainFrame.width, y: mainFrame.minY + 0.64195 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.93824 * mainFrame.width, y: mainFrame.minY + 0.68114 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.95420 * mainFrame.width, y: mainFrame.minY + 0.66323 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.94612 * mainFrame.width, y: mainFrame.minY + 0.67155 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.92252 * mainFrame.width, y: mainFrame.minY + 0.69815 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.93306 * mainFrame.width, y: mainFrame.minY + 0.68746 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.92787 * mainFrame.width, y: mainFrame.minY + 0.69287 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.89700 * mainFrame.width, y: mainFrame.minY + 0.72837 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.91392 * mainFrame.width, y: mainFrame.minY + 0.70665 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.90597 * mainFrame.width, y: mainFrame.minY + 0.72059 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.88672 * mainFrame.width, y: mainFrame.minY + 0.73831 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.89448 * mainFrame.width, y: mainFrame.minY + 0.73055 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.88672 * mainFrame.width, y: mainFrame.minY + 0.73831 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.88706 * mainFrame.width, y: mainFrame.minY + 0.70144 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.88672 * mainFrame.width, y: mainFrame.minY + 0.73831 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.88690 * mainFrame.width, y: mainFrame.minY + 0.70990 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.88981 * mainFrame.width, y: mainFrame.minY + 0.54152 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.88812 * mainFrame.width, y: mainFrame.minY + 0.64816 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.88903 * mainFrame.width, y: mainFrame.minY + 0.59484 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.89042 * mainFrame.width, y: mainFrame.minY + 0.49681 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.89002 * mainFrame.width, y: mainFrame.minY + 0.52662 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.89022 * mainFrame.width, y: mainFrame.minY + 0.51172 * mainFrame.height))
        pencilTipPath.addCurve(to: CGPoint(x: mainFrame.minX + 0.89093 * mainFrame.width, y: mainFrame.minY + 0.45408 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.89052 * mainFrame.width, y: mainFrame.minY + 0.48901 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.89109 * mainFrame.width, y: mainFrame.minY + 0.46153 * mainFrame.height))
        
        
        let pencilTipLayer = CAShapeLayer()
        pencilTipLayer.path = pencilTipPath.cgPath
        
        pencilTipLayer.fillColor = fillColor2.cgColor
        
        //// Clip 3 Drawing
        let pencilBasePath = UIBezierPath()
        pencilBasePath.move(to: CGPoint(x: mainFrame.minX + 0.00052 * mainFrame.width, y: mainFrame.minY + 0.20396 * mainFrame.height))
        pencilBasePath.addLine(to: CGPoint(x: mainFrame.minX + 0.00135 * mainFrame.width, y: mainFrame.minY + 0.15861 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.03702 * mainFrame.width, y: mainFrame.minY + 0.00006 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.00263 * mainFrame.width, y: mainFrame.minY + 0.08908 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.01685 * mainFrame.width, y: mainFrame.minY + 0.03023 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.62258 * mainFrame.width, y: mainFrame.minY + 0.12571 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.27445 * mainFrame.width, y: mainFrame.minY + -0.00227 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.39861 * mainFrame.width, y: mainFrame.minY + 0.06732 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.62162 * mainFrame.width, y: mainFrame.minY + 0.90827 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.61146 * mainFrame.width, y: mainFrame.minY + 0.38509 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.61114 * mainFrame.width, y: mainFrame.minY + 0.64716 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.56428 * mainFrame.width, y: mainFrame.minY + 0.98586 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.60876 * mainFrame.width, y: mainFrame.minY + 0.95824 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.58761 * mainFrame.width, y: mainFrame.minY + 0.98934 * mainFrame.height))
        pencilBasePath.addLine(to: CGPoint(x: mainFrame.minX + 0.08550 * mainFrame.width, y: mainFrame.minY + 0.91433 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.04045 * mainFrame.width, y: mainFrame.minY + 0.90340 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.07077 * mainFrame.width, y: mainFrame.minY + 0.91091 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.05577 * mainFrame.width, y: mainFrame.minY + 0.90727 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.00987 * mainFrame.width, y: mainFrame.minY + 0.85192 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.02860 * mainFrame.width, y: mainFrame.minY + 0.89431 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + 0.01810 * mainFrame.width, y: mainFrame.minY + 0.87620 * mainFrame.height))
        pencilBasePath.addCurve(to: CGPoint(x: mainFrame.minX + 0.00052 * mainFrame.width, y: mainFrame.minY + 0.20396 * mainFrame.height), controlPoint1: CGPoint(x: mainFrame.minX + 0.00558 * mainFrame.width, y: mainFrame.minY + 0.75715 * mainFrame.height), controlPoint2: CGPoint(x: mainFrame.minX + -0.00205 * mainFrame.width, y: mainFrame.minY + 0.53776 * mainFrame.height))
        
        let pencilBaseLayer = CAShapeLayer()
        pencilBaseLayer.path = pencilBasePath.cgPath
        
        pencilBaseLayer.fillColor = UIColor.trinidad.cgColor
        pencilBaseLayer.strokeColor = strokeColor.cgColor
        
        self.pencilBaseLayer = pencilBaseLayer
        
        /// Add layers
        pencilLoaderLayer.addSublayer(pencilLayer)
        pencilLoaderLayer.addSublayer(pencilTipLayer)
        pencilLoaderLayer.addSublayer(pencilBaseLayer)
        
        /// Add main layer
        layer.addSublayer(pencilLoaderLayer)
    }
    
    func drawFace(frame: CGRect = CGRect(x: 0, y: 0, width: 391, height: 399)) {
        //// General Declarations

        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let fillColor4 = UIColor(red: 0.922, green: 0.914, blue: 0.882, alpha: 1.000)
        let fillColor5 = UIColor(red: 0.780, green: 0.651, blue: 0.553, alpha: 1.000)
        let fillColor6 = UIColor(red: 0.257, green: 0.253, blue: 0.261, alpha: 1.000)
        
        //// Subframes
        let faceGroup: CGRect = CGRect(x: frame.minX + 2, y: frame.minY + 1, width: frame.width - 5.63, height: frame.height - 3.83)
        
        //// Face
        let facePath = UIBezierPath()
        facePath.move(to: CGPoint(x: faceGroup.minX + 0.99959 * faceGroup.width, y: faceGroup.minY + 0.57266 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.98659 * faceGroup.width, y: faceGroup.minY + 0.50584 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.99784 * faceGroup.width, y: faceGroup.minY + 0.55003 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.99390 * faceGroup.width, y: faceGroup.minY + 0.52741 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.96191 * faceGroup.width, y: faceGroup.minY + 0.45447 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.98035 * faceGroup.width, y: faceGroup.minY + 0.48744 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.96835 * faceGroup.width, y: faceGroup.minY + 0.47255 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.96285 * faceGroup.width, y: faceGroup.minY + 0.44320 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.96056 * faceGroup.width, y: faceGroup.minY + 0.45067 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.95883 * faceGroup.width, y: faceGroup.minY + 0.44402 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.98312 * faceGroup.width, y: faceGroup.minY + 0.44952 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.96892 * faceGroup.width, y: faceGroup.minY + 0.44196 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.98058 * faceGroup.width, y: faceGroup.minY + 0.45408 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.95798 * faceGroup.width, y: faceGroup.minY + 0.39786 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.97853 * faceGroup.width, y: faceGroup.minY + 0.43332 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.96658 * faceGroup.width, y: faceGroup.minY + 0.41211 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.93560 * faceGroup.width, y: faceGroup.minY + 0.35153 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.94912 * faceGroup.width, y: faceGroup.minY + 0.38317 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.94512 * faceGroup.width, y: faceGroup.minY + 0.37083 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.91159 * faceGroup.width, y: faceGroup.minY + 0.30639 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.90789 * faceGroup.width, y: faceGroup.minY + 0.29533 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.91553 * faceGroup.width, y: faceGroup.minY + 0.31516 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.90563 * faceGroup.width, y: faceGroup.minY + 0.29639 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.91089 * faceGroup.width, y: faceGroup.minY + 0.30483 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.90914 * faceGroup.width, y: faceGroup.minY + 0.30086 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.89626 * faceGroup.width, y: faceGroup.minY + 0.28723 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.90236 * faceGroup.width, y: faceGroup.minY + 0.29225 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.89932 * faceGroup.width, y: faceGroup.minY + 0.29045 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.88348 * faceGroup.width, y: faceGroup.minY + 0.27307 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.88903 * faceGroup.width, y: faceGroup.minY + 0.27963 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.88369 * faceGroup.width, y: faceGroup.minY + 0.27331 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.85708 * faceGroup.width, y: faceGroup.minY + 0.24558 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.87426 * faceGroup.width, y: faceGroup.minY + 0.26217 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.86760 * faceGroup.width, y: faceGroup.minY + 0.25649 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.82556 * faceGroup.width, y: faceGroup.minY + 0.20893 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.85005 * faceGroup.width, y: faceGroup.minY + 0.23829 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.84189 * faceGroup.width, y: faceGroup.minY + 0.22850 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.78724 * faceGroup.width, y: faceGroup.minY + 0.16228 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.80931 * faceGroup.width, y: faceGroup.minY + 0.18944 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.80532 * faceGroup.width, y: faceGroup.minY + 0.18403 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.76765 * faceGroup.width, y: faceGroup.minY + 0.13896 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.77884 * faceGroup.width, y: faceGroup.minY + 0.15218 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.77195 * faceGroup.width, y: faceGroup.minY + 0.14403 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.74951 * faceGroup.width, y: faceGroup.minY + 0.12377 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.76319 * faceGroup.width, y: faceGroup.minY + 0.13516 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.75699 * faceGroup.width, y: faceGroup.minY + 0.12992 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.72630 * faceGroup.width, y: faceGroup.minY + 0.10514 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.74323 * faceGroup.width, y: faceGroup.minY + 0.11861 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.73466 * faceGroup.width, y: faceGroup.minY + 0.11151 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.64557 * faceGroup.width, y: faceGroup.minY + 0.06702 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69865 * faceGroup.width, y: faceGroup.minY + 0.08407 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.68967 * faceGroup.width, y: faceGroup.minY + 0.07491 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.59707 * faceGroup.width, y: faceGroup.minY + 0.06247 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.63947 * faceGroup.width, y: faceGroup.minY + 0.06593 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.59707 * faceGroup.width, y: faceGroup.minY + 0.06247 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.58965 * faceGroup.width, y: faceGroup.minY + 0.42463 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.60805 * faceGroup.width, y: faceGroup.minY + 0.21364 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.59559 * faceGroup.width, y: faceGroup.minY + 0.28740 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39137 * faceGroup.width, y: faceGroup.minY + 0.43564 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52348 * faceGroup.width, y: faceGroup.minY + 0.42051 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.45700 * faceGroup.width, y: faceGroup.minY + 0.42420 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39293 * faceGroup.width, y: faceGroup.minY + 0.07737 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39063 * faceGroup.width, y: faceGroup.minY + 0.30426 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.38686 * faceGroup.width, y: faceGroup.minY + 0.21242 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.33501 * faceGroup.width, y: faceGroup.minY + 0.08676 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.37373 * faceGroup.width, y: faceGroup.minY + 0.08062 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.35367 * faceGroup.width, y: faceGroup.minY + 0.08097 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.28564 * faceGroup.width, y: faceGroup.minY + 0.10982 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.31756 * faceGroup.width, y: faceGroup.minY + 0.09218 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.30217 * faceGroup.width, y: faceGroup.minY + 0.10236 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.24425 * faceGroup.width, y: faceGroup.minY + 0.12836 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.27186 * faceGroup.width, y: faceGroup.minY + 0.11603 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.25800 * faceGroup.width, y: faceGroup.minY + 0.12208 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.20723 * faceGroup.width, y: faceGroup.minY + 0.15645 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22823 * faceGroup.width, y: faceGroup.minY + 0.13862 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.21598 * faceGroup.width, y: faceGroup.minY + 0.14860 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.17997 * faceGroup.width, y: faceGroup.minY + 0.18394 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.19623 * faceGroup.width, y: faceGroup.minY + 0.16631 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.18780 * faceGroup.width, y: faceGroup.minY + 0.17545 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.16464 * faceGroup.width, y: faceGroup.minY + 0.20143 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.17343 * faceGroup.width, y: faceGroup.minY + 0.19103 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.16966 * faceGroup.width, y: faceGroup.minY + 0.19512 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.14931 * faceGroup.width, y: faceGroup.minY + 0.22142 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.15490 * faceGroup.width, y: faceGroup.minY + 0.21369 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.15556 * faceGroup.width, y: faceGroup.minY + 0.21533 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.12802 * faceGroup.width, y: faceGroup.minY + 0.23725 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.14752 * faceGroup.width, y: faceGroup.minY + 0.22317 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.14800 * faceGroup.width, y: faceGroup.minY + 0.22251 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.11354 * faceGroup.width, y: faceGroup.minY + 0.24891 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.12025 * faceGroup.width, y: faceGroup.minY + 0.24298 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.11737 * faceGroup.width, y: faceGroup.minY + 0.24515 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.10332 * faceGroup.width, y: faceGroup.minY + 0.26057 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.10878 * faceGroup.width, y: faceGroup.minY + 0.25359 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.10529 * faceGroup.width, y: faceGroup.minY + 0.25803 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.09525 * faceGroup.width, y: faceGroup.minY + 0.27212 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.09985 * faceGroup.width, y: faceGroup.minY + 0.26503 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.09719 * faceGroup.width, y: faceGroup.minY + 0.26902 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.05775 * faceGroup.width, y: faceGroup.minY + 0.34779 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.08273 * faceGroup.width, y: faceGroup.minY + 0.29748 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.07240 * faceGroup.width, y: faceGroup.minY + 0.32370 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.03879 * faceGroup.width, y: faceGroup.minY + 0.38988 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.04983 * faceGroup.width, y: faceGroup.minY + 0.36079 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.04434 * faceGroup.width, y: faceGroup.minY + 0.37564 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.02571 * faceGroup.width, y: faceGroup.minY + 0.42917 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.03458 * faceGroup.width, y: faceGroup.minY + 0.40070 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.02472 * faceGroup.width, y: faceGroup.minY + 0.41759 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.03815 * faceGroup.width, y: faceGroup.minY + 0.42970 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.03035 * faceGroup.width, y: faceGroup.minY + 0.43288 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.03425 * faceGroup.width, y: faceGroup.minY + 0.42611 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.01986 * faceGroup.width, y: faceGroup.minY + 0.46302 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.03887 * faceGroup.width, y: faceGroup.minY + 0.43957 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.02467 * faceGroup.width, y: faceGroup.minY + 0.45470 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.00412 * faceGroup.width, y: faceGroup.minY + 0.50686 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.01565 * faceGroup.width, y: faceGroup.minY + 0.47028 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.00341 * faceGroup.width, y: faceGroup.minY + 0.49841 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.01859 * faceGroup.width, y: faceGroup.minY + 0.49506 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.00803 * faceGroup.width, y: faceGroup.minY + 0.50854 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.01477 * faceGroup.width, y: faceGroup.minY + 0.49342 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.00436 * faceGroup.width, y: faceGroup.minY + 0.61122 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.01566 * faceGroup.width, y: faceGroup.minY + 0.50703 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + -0.01006 * faceGroup.width, y: faceGroup.minY + 0.61319 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.02055 * faceGroup.width, y: faceGroup.minY + 0.59420 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.00930 * faceGroup.width, y: faceGroup.minY + 0.60487 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.01331 * faceGroup.width, y: faceGroup.minY + 0.59801 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.02457 * faceGroup.width, y: faceGroup.minY + 0.63324 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.02868 * faceGroup.width, y: faceGroup.minY + 0.60081 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.02389 * faceGroup.width, y: faceGroup.minY + 0.62373 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.02945 * faceGroup.width, y: faceGroup.minY + 0.67916 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.02557 * faceGroup.width, y: faceGroup.minY + 0.64697 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.02378 * faceGroup.width, y: faceGroup.minY + 0.66616 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.04494 * faceGroup.width, y: faceGroup.minY + 0.70501 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.03373 * faceGroup.width, y: faceGroup.minY + 0.68897 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.04229 * faceGroup.width, y: faceGroup.minY + 0.69287 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.05776 * faceGroup.width, y: faceGroup.minY + 0.73731 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.04727 * faceGroup.width, y: faceGroup.minY + 0.71569 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.04108 * faceGroup.width, y: faceGroup.minY + 0.73896 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.07978 * faceGroup.width, y: faceGroup.minY + 0.76389 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.07085 * faceGroup.width, y: faceGroup.minY + 0.73602 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.07658 * faceGroup.width, y: faceGroup.minY + 0.75399 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.09046 * faceGroup.width, y: faceGroup.minY + 0.79973 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.08227 * faceGroup.width, y: faceGroup.minY + 0.77159 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.08598 * faceGroup.width, y: faceGroup.minY + 0.79301 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.09822 * faceGroup.width, y: faceGroup.minY + 0.78729 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.09426 * faceGroup.width, y: faceGroup.minY + 0.79996 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.09480 * faceGroup.width, y: faceGroup.minY + 0.78708 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.13109 * faceGroup.width, y: faceGroup.minY + 0.85520 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.11247 * faceGroup.width, y: faceGroup.minY + 0.83161 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.11754 * faceGroup.width, y: faceGroup.minY + 0.84403 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.14032 * faceGroup.width, y: faceGroup.minY + 0.84588 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.13280 * faceGroup.width, y: faceGroup.minY + 0.85662 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.13421 * faceGroup.width, y: faceGroup.minY + 0.84401 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.15842 * faceGroup.width, y: faceGroup.minY + 0.86665 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.14745 * faceGroup.width, y: faceGroup.minY + 0.84806 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.15547 * faceGroup.width, y: faceGroup.minY + 0.86063 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.17150 * faceGroup.width, y: faceGroup.minY + 0.88959 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.16214 * faceGroup.width, y: faceGroup.minY + 0.87427 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.16176 * faceGroup.width, y: faceGroup.minY + 0.88641 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.19894 * faceGroup.width, y: faceGroup.minY + 0.89376 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.18203 * faceGroup.width, y: faceGroup.minY + 0.88686 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.18857 * faceGroup.width, y: faceGroup.minY + 0.89028 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.20742 * faceGroup.width, y: faceGroup.minY + 0.91591 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.20653 * faceGroup.width, y: faceGroup.minY + 0.89917 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.20728 * faceGroup.width, y: faceGroup.minY + 0.90488 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.22237 * faceGroup.width, y: faceGroup.minY + 0.90902 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.21543 * faceGroup.width, y: faceGroup.minY + 0.91953 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.21490 * faceGroup.width, y: faceGroup.minY + 0.90653 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.23555 * faceGroup.width, y: faceGroup.minY + 0.92433 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22859 * faceGroup.width, y: faceGroup.minY + 0.91109 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.23186 * faceGroup.width, y: faceGroup.minY + 0.91954 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.25130 * faceGroup.width, y: faceGroup.minY + 0.93593 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.23954 * faceGroup.width, y: faceGroup.minY + 0.92951 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.24448 * faceGroup.width, y: faceGroup.minY + 0.93471 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.27950 * faceGroup.width, y: faceGroup.minY + 0.94026 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.26105 * faceGroup.width, y: faceGroup.minY + 0.93767 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.27024 * faceGroup.width, y: faceGroup.minY + 0.93571 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.30143 * faceGroup.width, y: faceGroup.minY + 0.95310 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.28705 * faceGroup.width, y: faceGroup.minY + 0.94397 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.29619 * faceGroup.width, y: faceGroup.minY + 0.94615 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.31637 * faceGroup.width, y: faceGroup.minY + 0.97065 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.30619 * faceGroup.width, y: faceGroup.minY + 0.95943 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.30946 * faceGroup.width, y: faceGroup.minY + 0.96685 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.31773 * faceGroup.width, y: faceGroup.minY + 0.96354 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.31715 * faceGroup.width, y: faceGroup.minY + 0.96840 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.31673 * faceGroup.width, y: faceGroup.minY + 0.96564 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.34070 * faceGroup.width, y: faceGroup.minY + 0.96796 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.32144 * faceGroup.width, y: faceGroup.minY + 0.95579 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.33597 * faceGroup.width, y: faceGroup.minY + 0.96693 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.35699 * faceGroup.width, y: faceGroup.minY + 0.96243 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.34823 * faceGroup.width, y: faceGroup.minY + 0.96958 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.35140 * faceGroup.width, y: faceGroup.minY + 0.96247 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.36939 * faceGroup.width, y: faceGroup.minY + 0.97663 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.36225 * faceGroup.width, y: faceGroup.minY + 0.96238 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.36466 * faceGroup.width, y: faceGroup.minY + 0.97662 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.38589 * faceGroup.width, y: faceGroup.minY + 0.96757 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.37286 * faceGroup.width, y: faceGroup.minY + 0.97664 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.37334 * faceGroup.width, y: faceGroup.minY + 0.96449 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.40168 * faceGroup.width, y: faceGroup.minY + 0.97618 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39486 * faceGroup.width, y: faceGroup.minY + 0.96978 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.39182 * faceGroup.width, y: faceGroup.minY + 0.97680 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.41041 * faceGroup.width, y: faceGroup.minY + 0.97396 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.40495 * faceGroup.width, y: faceGroup.minY + 0.97598 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.40617 * faceGroup.width, y: faceGroup.minY + 0.97330 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.42163 * faceGroup.width, y: faceGroup.minY + 0.98268 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.41509 * faceGroup.width, y: faceGroup.minY + 0.97468 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.41828 * faceGroup.width, y: faceGroup.minY + 0.97992 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.45367 * faceGroup.width, y: faceGroup.minY + 0.98801 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.43171 * faceGroup.width, y: faceGroup.minY + 0.99100 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.44258 * faceGroup.width, y: faceGroup.minY + 0.98525 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.46858 * faceGroup.width, y: faceGroup.minY + 0.99782 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.45879 * faceGroup.width, y: faceGroup.minY + 0.98929 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46363 * faceGroup.width, y: faceGroup.minY + 0.99480 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.47886 * faceGroup.width, y: faceGroup.minY + 0.97352 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.48528 * faceGroup.width, y: faceGroup.minY + 1.00803 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.47172 * faceGroup.width, y: faceGroup.minY + 0.97939 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.51668 * faceGroup.width, y: faceGroup.minY + 0.98767 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.49185 * faceGroup.width, y: faceGroup.minY + 0.96285 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51159 * faceGroup.width, y: faceGroup.minY + 0.98703 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.52246 * faceGroup.width, y: faceGroup.minY + 0.96907 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52052 * faceGroup.width, y: faceGroup.minY + 0.98815 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.52128 * faceGroup.width, y: faceGroup.minY + 0.97168 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.54644 * faceGroup.width, y: faceGroup.minY + 0.97535 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52793 * faceGroup.width, y: faceGroup.minY + 0.95706 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.54157 * faceGroup.width, y: faceGroup.minY + 0.96805 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.55987 * faceGroup.width, y: faceGroup.minY + 0.98652 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.55024 * faceGroup.width, y: faceGroup.minY + 0.98104 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.55132 * faceGroup.width, y: faceGroup.minY + 0.98649 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.58709 * faceGroup.width, y: faceGroup.minY + 0.96410 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.57199 * faceGroup.width, y: faceGroup.minY + 0.98658 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.56570 * faceGroup.width, y: faceGroup.minY + 0.95680 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.61502 * faceGroup.width, y: faceGroup.minY + 0.97964 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.59626 * faceGroup.width, y: faceGroup.minY + 0.96723 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.60264 * faceGroup.width, y: faceGroup.minY + 0.98674 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.64398 * faceGroup.width, y: faceGroup.minY + 0.95303 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.62666 * faceGroup.width, y: faceGroup.minY + 0.97297 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.63316 * faceGroup.width, y: faceGroup.minY + 0.96057 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.66197 * faceGroup.width, y: faceGroup.minY + 0.94503 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.64862 * faceGroup.width, y: faceGroup.minY + 0.94979 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.65568 * faceGroup.width, y: faceGroup.minY + 0.94404 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.66625 * faceGroup.width, y: faceGroup.minY + 0.95357 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.66708 * faceGroup.width, y: faceGroup.minY + 0.94584 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.66447 * faceGroup.width, y: faceGroup.minY + 0.95329 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69780 * faceGroup.width, y: faceGroup.minY + 0.94167 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.67838 * faceGroup.width, y: faceGroup.minY + 0.95550 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.68601 * faceGroup.width, y: faceGroup.minY + 0.94294 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.71822 * faceGroup.width, y: faceGroup.minY + 0.94440 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.70449 * faceGroup.width, y: faceGroup.minY + 0.94096 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.71158 * faceGroup.width, y: faceGroup.minY + 0.94855 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.73628 * faceGroup.width, y: faceGroup.minY + 0.91816 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.72550 * faceGroup.width, y: faceGroup.minY + 0.93986 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.73206 * faceGroup.width, y: faceGroup.minY + 0.92530 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.77217 * faceGroup.width, y: faceGroup.minY + 0.88293 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.74453 * faceGroup.width, y: faceGroup.minY + 0.90416 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.75337 * faceGroup.width, y: faceGroup.minY + 0.88477 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.77752 * faceGroup.width, y: faceGroup.minY + 0.88418 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.77406 * faceGroup.width, y: faceGroup.minY + 0.88275 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.77620 * faceGroup.width, y: faceGroup.minY + 0.88285 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.77857 * faceGroup.width, y: faceGroup.minY + 0.88991 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.77895 * faceGroup.width, y: faceGroup.minY + 0.88563 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.77885 * faceGroup.width, y: faceGroup.minY + 0.88792 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.77646 * faceGroup.width, y: faceGroup.minY + 0.90385 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.77787 * faceGroup.width, y: faceGroup.minY + 0.89478 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.77637 * faceGroup.width, y: faceGroup.minY + 0.89903 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.81289 * faceGroup.width, y: faceGroup.minY + 0.85880 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.79529 * faceGroup.width, y: faceGroup.minY + 0.90206 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.80379 * faceGroup.width, y: faceGroup.minY + 0.87241 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.83880 * faceGroup.width, y: faceGroup.minY + 0.82228 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.82035 * faceGroup.width, y: faceGroup.minY + 0.84765 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.82795 * faceGroup.width, y: faceGroup.minY + 0.83011 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.84989 * faceGroup.width, y: faceGroup.minY + 0.83135 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.84417 * faceGroup.width, y: faceGroup.minY + 0.82404 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.84340 * faceGroup.width, y: faceGroup.minY + 0.83129 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.86834 * faceGroup.width, y: faceGroup.minY + 0.80680 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.85674 * faceGroup.width, y: faceGroup.minY + 0.82598 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.86289 * faceGroup.width, y: faceGroup.minY + 0.81379 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.88625 * faceGroup.width, y: faceGroup.minY + 0.77948 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.87512 * faceGroup.width, y: faceGroup.minY + 0.79810 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.87765 * faceGroup.width, y: faceGroup.minY + 0.78701 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.89355 * faceGroup.width, y: faceGroup.minY + 0.78196 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.88916 * faceGroup.width, y: faceGroup.minY + 0.78047 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.89146 * faceGroup.width, y: faceGroup.minY + 0.78125 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.90688 * faceGroup.width, y: faceGroup.minY + 0.74273 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.90253 * faceGroup.width, y: faceGroup.minY + 0.77447 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.90389 * faceGroup.width, y: faceGroup.minY + 0.75328 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.92168 * faceGroup.width, y: faceGroup.minY + 0.70663 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.91029 * faceGroup.width, y: faceGroup.minY + 0.73072 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.91236 * faceGroup.width, y: faceGroup.minY + 0.71558 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.93869 * faceGroup.width, y: faceGroup.minY + 0.72916 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.92003 * faceGroup.width, y: faceGroup.minY + 0.70822 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.93124 * faceGroup.width, y: faceGroup.minY + 0.73248 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.94421 * faceGroup.width, y: faceGroup.minY + 0.72232 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.94146 * faceGroup.width, y: faceGroup.minY + 0.72793 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.94294 * faceGroup.width, y: faceGroup.minY + 0.72502 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.96242 * faceGroup.width, y: faceGroup.minY + 0.66101 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.95332 * faceGroup.width, y: faceGroup.minY + 0.70293 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.96090 * faceGroup.width, y: faceGroup.minY + 0.68245 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.96556 * faceGroup.width, y: faceGroup.minY + 0.62686 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.96315 * faceGroup.width, y: faceGroup.minY + 0.65066 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.95885 * faceGroup.width, y: faceGroup.minY + 0.63569 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.99068 * faceGroup.width, y: faceGroup.minY + 0.63440 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.97582 * faceGroup.width, y: faceGroup.minY + 0.61335 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.97533 * faceGroup.width, y: faceGroup.minY + 0.63917 * faceGroup.height))
        facePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.99959 * faceGroup.width, y: faceGroup.minY + 0.57266 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 1.00149 * faceGroup.width, y: faceGroup.minY + 0.63103 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 1.00024 * faceGroup.width, y: faceGroup.minY + 0.58109 * faceGroup.height))
        
        let faceLayer = CAShapeLayer()
        faceLayer.path = facePath.cgPath
    
        faceLayer.fillColor = animationModel.fillColor.cgColor
        faceLayer.strokeColor = animationModel.strokeColor.cgColor
        
        /// Adding layer to animation array
        animationModel.colorLayers.append(faceLayer)
        
        //// Hair Drawing
        let hairPath = UIBezierPath()
        hairPath.move(to: CGPoint(x: faceGroup.minX + 0.59589 * faceGroup.width, y: faceGroup.minY + 0.03356 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.59945 * faceGroup.width, y: faceGroup.minY + 0.00446 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.59794 * faceGroup.width, y: faceGroup.minY + 0.02394 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.60244 * faceGroup.width, y: faceGroup.minY + 0.01420 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.58644 * faceGroup.width, y: faceGroup.minY + 0.00395 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.59721 * faceGroup.width, y: faceGroup.minY + -0.00284 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.59112 * faceGroup.width, y: faceGroup.minY + 0.00017 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.56194 * faceGroup.width, y: faceGroup.minY + 0.03227 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.57667 * faceGroup.width, y: faceGroup.minY + 0.01185 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.57183 * faceGroup.width, y: faceGroup.minY + 0.02482 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.52885 * faceGroup.width, y: faceGroup.minY + 0.04609 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.55246 * faceGroup.width, y: faceGroup.minY + 0.03941 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.54097 * faceGroup.width, y: faceGroup.minY + 0.04510 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.51949 * faceGroup.width, y: faceGroup.minY + 0.04589 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52679 * faceGroup.width, y: faceGroup.minY + 0.04625 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.52125 * faceGroup.width, y: faceGroup.minY + 0.04707 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.51799 * faceGroup.width, y: faceGroup.minY + 0.03952 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.51744 * faceGroup.width, y: faceGroup.minY + 0.04452 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51791 * faceGroup.width, y: faceGroup.minY + 0.04212 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.52156 * faceGroup.width, y: faceGroup.minY + 0.02270 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.51817 * faceGroup.width, y: faceGroup.minY + 0.03379 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51904 * faceGroup.width, y: faceGroup.minY + 0.02794 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.53273 * faceGroup.width, y: faceGroup.minY + 0.00487 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52461 * faceGroup.width, y: faceGroup.minY + 0.01636 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.53017 * faceGroup.width, y: faceGroup.minY + 0.01147 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.49475 * faceGroup.width, y: faceGroup.minY + 0.02134 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52178 * faceGroup.width, y: faceGroup.minY + 0.00178 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.50400 * faceGroup.width, y: faceGroup.minY + 0.01605 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.45742 * faceGroup.width, y: faceGroup.minY + 0.04206 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.48220 * faceGroup.width, y: faceGroup.minY + 0.02852 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.47200 * faceGroup.width, y: faceGroup.minY + 0.03901 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.45727 * faceGroup.width, y: faceGroup.minY + 0.01478 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.45455 * faceGroup.width, y: faceGroup.minY + 0.03418 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46128 * faceGroup.width, y: faceGroup.minY + 0.02081 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39348 * faceGroup.width, y: faceGroup.minY + 0.07563 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.42762 * faceGroup.width, y: faceGroup.minY + 0.01316 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.40143 * faceGroup.width, y: faceGroup.minY + 0.05207 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.59940 * faceGroup.width, y: faceGroup.minY + 0.06072 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39545 * faceGroup.width, y: faceGroup.minY + 0.07531 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46637 * faceGroup.width, y: faceGroup.minY + 0.06072 * faceGroup.height))
        hairPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.59589 * faceGroup.width, y: faceGroup.minY + 0.03356 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.59593 * faceGroup.width, y: faceGroup.minY + 0.05190 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.59390 * faceGroup.width, y: faceGroup.minY + 0.04291 * faceGroup.height))
        
        let hairLayer = CAShapeLayer()
        hairLayer.path = hairPath.cgPath
        
        hairLayer.fillColor = animationModel.fillColor.cgColor
        hairLayer.strokeColor = animationModel.strokeColor.cgColor
        
        /// Adding layer to animation array
        animationModel.colorLayers.append(hairLayer)
        
        //// Nose background
        let noseBackgroundPath = UIBezierPath()
        noseBackgroundPath.move(to: CGPoint(x: faceGroup.minX + 0.55001 * faceGroup.width, y: faceGroup.minY + 0.06326 * faceGroup.height))
        noseBackgroundPath.addLine(to: CGPoint(x: faceGroup.minX + 0.58374 * faceGroup.width, y: faceGroup.minY + 0.06326 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.59730 * faceGroup.width, y: faceGroup.minY + 0.06820 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.58893 * faceGroup.width, y: faceGroup.minY + 0.06326 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.59368 * faceGroup.width, y: faceGroup.minY + 0.06513 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.58946 * faceGroup.width, y: faceGroup.minY + 0.42630 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.60776 * faceGroup.width, y: faceGroup.minY + 0.21642 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.59539 * faceGroup.width, y: faceGroup.minY + 0.29024 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39688 * faceGroup.width, y: faceGroup.minY + 0.43607 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52521 * faceGroup.width, y: faceGroup.minY + 0.42233 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46067 * faceGroup.width, y: faceGroup.minY + 0.42561 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.38923 * faceGroup.width, y: faceGroup.minY + 0.42049 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39222 * faceGroup.width, y: faceGroup.minY + 0.43239 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.38923 * faceGroup.width, y: faceGroup.minY + 0.42678 * faceGroup.height))
        noseBackgroundPath.addLine(to: CGPoint(x: faceGroup.minX + 0.38923 * faceGroup.width, y: faceGroup.minY + 0.12062 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39089 * faceGroup.width, y: faceGroup.minY + 0.07820 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.38968 * faceGroup.width, y: faceGroup.minY + 0.10691 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.39023 * faceGroup.width, y: faceGroup.minY + 0.09281 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.38986 * faceGroup.width, y: faceGroup.minY + 0.07837 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39055 * faceGroup.width, y: faceGroup.minY + 0.07826 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.39021 * faceGroup.width, y: faceGroup.minY + 0.07831 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39008 * faceGroup.width, y: faceGroup.minY + 0.07762 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.38993 * faceGroup.width, y: faceGroup.minY + 0.07812 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.39000 * faceGroup.width, y: faceGroup.minY + 0.07787 * faceGroup.height))
        noseBackgroundPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.55001 * faceGroup.width, y: faceGroup.minY + 0.06326 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39898 * faceGroup.width, y: faceGroup.minY + 0.07593 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.45353 * faceGroup.width, y: faceGroup.minY + 0.06588 * faceGroup.height))

        let noseBackgroundLayer = CAShapeLayer()
        noseBackgroundLayer.path = noseBackgroundPath.cgPath
        
        noseBackgroundLayer.fillColor = UIColor.trinidad.cgColor
        
        /// Adding layer to animation array
        animationModel.colorLayers.append(noseBackgroundLayer)

        //// Nose Drawing
        let nosePath = UIBezierPath()
        nosePath.move(to: CGPoint(x: faceGroup.minX + 0.48882 * faceGroup.width, y: faceGroup.minY + 0.65429 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.44454 * faceGroup.width, y: faceGroup.minY + 0.56511 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.47406 * faceGroup.width, y: faceGroup.minY + 0.62456 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.45930 * faceGroup.width, y: faceGroup.minY + 0.59484 * faceGroup.height))
        nosePath.addLine(to: CGPoint(x: faceGroup.minX + 0.41122 * faceGroup.width, y: faceGroup.minY + 0.49800 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39817 * faceGroup.width, y: faceGroup.minY + 0.47173 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.40687 * faceGroup.width, y: faceGroup.minY + 0.48925 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.40252 * faceGroup.width, y: faceGroup.minY + 0.48049 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39336 * faceGroup.width, y: faceGroup.minY + 0.46203 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39657 * faceGroup.width, y: faceGroup.minY + 0.46850 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.39493 * faceGroup.width, y: faceGroup.minY + 0.46528 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.39636 * faceGroup.width, y: faceGroup.minY + 0.45128 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.39056 * faceGroup.width, y: faceGroup.minY + 0.45624 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.38857 * faceGroup.width, y: faceGroup.minY + 0.45261 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.47176 * faceGroup.width, y: faceGroup.minY + 0.44735 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.42054 * faceGroup.width, y: faceGroup.minY + 0.44715 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.44723 * faceGroup.width, y: faceGroup.minY + 0.44827 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.54721 * faceGroup.width, y: faceGroup.minY + 0.44651 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.49689 * faceGroup.width, y: faceGroup.minY + 0.44641 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.52206 * faceGroup.width, y: faceGroup.minY + 0.44598 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.57990 * faceGroup.width, y: faceGroup.minY + 0.44887 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.55813 * faceGroup.width, y: faceGroup.minY + 0.44675 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.56910 * faceGroup.width, y: faceGroup.minY + 0.44715 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.58616 * faceGroup.width, y: faceGroup.minY + 0.45827 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.58821 * faceGroup.width, y: faceGroup.minY + 0.45018 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.58937 * faceGroup.width, y: faceGroup.minY + 0.45137 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.57698 * faceGroup.width, y: faceGroup.minY + 0.47676 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.58326 * faceGroup.width, y: faceGroup.minY + 0.46450 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.58003 * faceGroup.width, y: faceGroup.minY + 0.47061 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.54779 * faceGroup.width, y: faceGroup.minY + 0.53554 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.56725 * faceGroup.width, y: faceGroup.minY + 0.49635 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.55752 * faceGroup.width, y: faceGroup.minY + 0.51595 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.49241 * faceGroup.width, y: faceGroup.minY + 0.64707 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.52933 * faceGroup.width, y: faceGroup.minY + 0.57272 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51087 * faceGroup.width, y: faceGroup.minY + 0.60989 * faceGroup.height))
        nosePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.48882 * faceGroup.width, y: faceGroup.minY + 0.65429 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.49121 * faceGroup.width, y: faceGroup.minY + 0.64948 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.49002 * faceGroup.width, y: faceGroup.minY + 0.65188 * faceGroup.height))
        
        let noseLayer = CAShapeLayer()
        noseLayer.path = nosePath.cgPath
        noseLayer.fillColor = fillColor5.cgColor
        
        
        //// Nose tip Drawing
        let noseTipPath = UIBezierPath()
        noseTipPath.move(to: CGPoint(x: faceGroup.minX + 0.52069 * faceGroup.width, y: faceGroup.minY + 0.59012 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.51719 * faceGroup.width, y: faceGroup.minY + 0.59761 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.51904 * faceGroup.width, y: faceGroup.minY + 0.59319 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51824 * faceGroup.width, y: faceGroup.minY + 0.59496 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.51116 * faceGroup.width, y: faceGroup.minY + 0.61175 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.51574 * faceGroup.width, y: faceGroup.minY + 0.60126 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51315 * faceGroup.width, y: faceGroup.minY + 0.60835 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.49221 * faceGroup.width, y: faceGroup.minY + 0.64923 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.50345 * faceGroup.width, y: faceGroup.minY + 0.62487 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.49888 * faceGroup.width, y: faceGroup.minY + 0.63557 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.48832 * faceGroup.width, y: faceGroup.minY + 0.65546 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.49113 * faceGroup.width, y: faceGroup.minY + 0.65143 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.48999 * faceGroup.width, y: faceGroup.minY + 0.65365 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.47837 * faceGroup.width, y: faceGroup.minY + 0.63386 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.48501 * faceGroup.width, y: faceGroup.minY + 0.64826 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.48169 * faceGroup.width, y: faceGroup.minY + 0.64106 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.47171 * faceGroup.width, y: faceGroup.minY + 0.62011 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.47625 * faceGroup.width, y: faceGroup.minY + 0.62923 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.47412 * faceGroup.width, y: faceGroup.minY + 0.62460 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.46739 * faceGroup.width, y: faceGroup.minY + 0.61111 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.47013 * faceGroup.width, y: faceGroup.minY + 0.61715 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46874 * faceGroup.width, y: faceGroup.minY + 0.61418 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.45978 * faceGroup.width, y: faceGroup.minY + 0.59654 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.46520 * faceGroup.width, y: faceGroup.minY + 0.60618 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46182 * faceGroup.width, y: faceGroup.minY + 0.60169 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.45722 * faceGroup.width, y: faceGroup.minY + 0.59064 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.45921 * faceGroup.width, y: faceGroup.minY + 0.59509 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.45722 * faceGroup.width, y: faceGroup.minY + 0.59064 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.46544 * faceGroup.width, y: faceGroup.minY + 0.59046 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.45722 * faceGroup.width, y: faceGroup.minY + 0.59064 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.46355 * faceGroup.width, y: faceGroup.minY + 0.59045 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.50117 * faceGroup.width, y: faceGroup.minY + 0.59038 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.47735 * faceGroup.width, y: faceGroup.minY + 0.59051 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.48926 * faceGroup.width, y: faceGroup.minY + 0.59049 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.51115 * faceGroup.width, y: faceGroup.minY + 0.59027 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.50449 * faceGroup.width, y: faceGroup.minY + 0.59035 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.50782 * faceGroup.width, y: faceGroup.minY + 0.59031 * faceGroup.height))
        noseTipPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.52069 * faceGroup.width, y: faceGroup.minY + 0.59012 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.51289 * faceGroup.width, y: faceGroup.minY + 0.59025 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.51903 * faceGroup.width, y: faceGroup.minY + 0.59029 * faceGroup.height))
        
        let noseTipLayer = CAShapeLayer()
        noseTipLayer.path = noseTipPath.cgPath
        noseTipLayer.fillColor = fillColor6.cgColor
        
        animationModel.colorLayers.append(noseTipLayer)
        animationModel.noseTipLayer = noseTipLayer
        
        //// Right Eye
        let rightEyePath = UIBezierPath()
        rightEyePath.move(to: CGPoint(x: faceGroup.minX + 0.75051 * faceGroup.width, y: faceGroup.minY + 0.38676 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.74840 * faceGroup.width, y: faceGroup.minY + 0.39128 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.74974 * faceGroup.width, y: faceGroup.minY + 0.38840 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.74912 * faceGroup.width, y: faceGroup.minY + 0.38973 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.73832 * faceGroup.width, y: faceGroup.minY + 0.40155 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.74434 * faceGroup.width, y: faceGroup.minY + 0.39396 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.74056 * faceGroup.width, y: faceGroup.minY + 0.39723 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.72497 * faceGroup.width, y: faceGroup.minY + 0.40834 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.73417 * faceGroup.width, y: faceGroup.minY + 0.40451 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.72971 * faceGroup.width, y: faceGroup.minY + 0.40624 * faceGroup.height))
        rightEyePath.addLine(to: CGPoint(x: faceGroup.minX + 0.71274 * faceGroup.width, y: faceGroup.minY + 0.40834 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.70023 * faceGroup.width, y: faceGroup.minY + 0.40033 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.70834 * faceGroup.width, y: faceGroup.minY + 0.40644 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.70368 * faceGroup.width, y: faceGroup.minY + 0.40503 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69706 * faceGroup.width, y: faceGroup.minY + 0.39392 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69939 * faceGroup.width, y: faceGroup.minY + 0.39867 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69799 * faceGroup.width, y: faceGroup.minY + 0.39638 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69434 * faceGroup.width, y: faceGroup.minY + 0.38384 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69583 * faceGroup.width, y: faceGroup.minY + 0.39066 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69406 * faceGroup.width, y: faceGroup.minY + 0.38747 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69266 * faceGroup.width, y: faceGroup.minY + 0.37705 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69452 * faceGroup.width, y: faceGroup.minY + 0.38136 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69282 * faceGroup.width, y: faceGroup.minY + 0.37942 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69188 * faceGroup.width, y: faceGroup.minY + 0.37007 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69249 * faceGroup.width, y: faceGroup.minY + 0.37472 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69219 * faceGroup.width, y: faceGroup.minY + 0.37239 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69125 * faceGroup.width, y: faceGroup.minY + 0.36851 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69181 * faceGroup.width, y: faceGroup.minY + 0.36950 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69145 * faceGroup.width, y: faceGroup.minY + 0.36898 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69226 * faceGroup.width, y: faceGroup.minY + 0.36425 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69086 * faceGroup.width, y: faceGroup.minY + 0.36687 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69203 * faceGroup.width, y: faceGroup.minY + 0.36566 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69269 * faceGroup.width, y: faceGroup.minY + 0.36011 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69249 * faceGroup.width, y: faceGroup.minY + 0.36281 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69257 * faceGroup.width, y: faceGroup.minY + 0.36134 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.69683 * faceGroup.width, y: faceGroup.minY + 0.35222 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69404 * faceGroup.width, y: faceGroup.minY + 0.35754 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.69527 * faceGroup.width, y: faceGroup.minY + 0.35519 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.70434 * faceGroup.width, y: faceGroup.minY + 0.34286 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.69922 * faceGroup.width, y: faceGroup.minY + 0.34938 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.70293 * faceGroup.width, y: faceGroup.minY + 0.34668 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.71462 * faceGroup.width, y: faceGroup.minY + 0.33755 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.70771 * faceGroup.width, y: faceGroup.minY + 0.34039 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.71111 * faceGroup.width, y: faceGroup.minY + 0.33919 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.72233 * faceGroup.width, y: faceGroup.minY + 0.33731 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.71704 * faceGroup.width, y: faceGroup.minY + 0.33747 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.71974 * faceGroup.width, y: faceGroup.minY + 0.33739 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.73831 * faceGroup.width, y: faceGroup.minY + 0.34506 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.72813 * faceGroup.width, y: faceGroup.minY + 0.33922 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.73398 * faceGroup.width, y: faceGroup.minY + 0.34066 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.74617 * faceGroup.width, y: faceGroup.minY + 0.35384 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.74087 * faceGroup.width, y: faceGroup.minY + 0.34792 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.74343 * faceGroup.width, y: faceGroup.minY + 0.35078 * faceGroup.height))
        rightEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.75051 * faceGroup.width, y: faceGroup.minY + 0.36448 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.74812 * faceGroup.width, y: faceGroup.minY + 0.35688 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.74907 * faceGroup.width, y: faceGroup.minY + 0.36059 * faceGroup.height))
        rightEyePath.addLine(to: CGPoint(x: faceGroup.minX + 0.75051 * faceGroup.width, y: faceGroup.minY + 0.38676 * faceGroup.height))
        
        let rightEyeLayer = CAShapeLayer()
        rightEyeLayer.path = rightEyePath.cgPath
        rightEyeLayer.fillColor = fillColor6.cgColor
        
        //// left eye path
        let leftEyePath = UIBezierPath()
        leftEyePath.move(to: CGPoint(x: faceGroup.minX + 0.22805 * faceGroup.width, y: faceGroup.minY + 0.40234 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.22429 * faceGroup.width, y: faceGroup.minY + 0.39458 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22665 * faceGroup.width, y: faceGroup.minY + 0.39943 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.22547 * faceGroup.width, y: faceGroup.minY + 0.39702 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.22363 * faceGroup.width, y: faceGroup.minY + 0.39019 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22408 * faceGroup.width, y: faceGroup.minY + 0.39313 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.22400 * faceGroup.width, y: faceGroup.minY + 0.39162 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.22225 * faceGroup.width, y: faceGroup.minY + 0.38703 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22335 * faceGroup.width, y: faceGroup.minY + 0.38906 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.22270 * faceGroup.width, y: faceGroup.minY + 0.38801 * faceGroup.height))
        leftEyePath.addLine(to: CGPoint(x: faceGroup.minX + 0.22225 * faceGroup.width, y: faceGroup.minY + 0.37518 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.22397 * faceGroup.width, y: faceGroup.minY + 0.37021 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22281 * faceGroup.width, y: faceGroup.minY + 0.37356 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.22342 * faceGroup.width, y: faceGroup.minY + 0.37189 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.23368 * faceGroup.width, y: faceGroup.minY + 0.35326 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22601 * faceGroup.width, y: faceGroup.minY + 0.36391 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.22942 * faceGroup.width, y: faceGroup.minY + 0.35835 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.24882 * faceGroup.width, y: faceGroup.minY + 0.34381 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.23767 * faceGroup.width, y: faceGroup.minY + 0.34850 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.24290 * faceGroup.width, y: faceGroup.minY + 0.34563 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.25395 * faceGroup.width, y: faceGroup.minY + 0.34217 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.25026 * faceGroup.width, y: faceGroup.minY + 0.34337 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.25169 * faceGroup.width, y: faceGroup.minY + 0.34289 * faceGroup.height))
        leftEyePath.addLine(to: CGPoint(x: faceGroup.minX + 0.26231 * faceGroup.width, y: faceGroup.minY + 0.34217 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.27357 * faceGroup.width, y: faceGroup.minY + 0.34683 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.26587 * faceGroup.width, y: faceGroup.minY + 0.34353 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.26978 * faceGroup.width, y: faceGroup.minY + 0.34432 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.27766 * faceGroup.width, y: faceGroup.minY + 0.35202 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.27470 * faceGroup.width, y: faceGroup.minY + 0.34828 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.27602 * faceGroup.width, y: faceGroup.minY + 0.35030 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.28293 * faceGroup.width, y: faceGroup.minY + 0.36125 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.28022 * faceGroup.width, y: faceGroup.minY + 0.35470 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.28186 * faceGroup.width, y: faceGroup.minY + 0.35778 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.28627 * faceGroup.width, y: faceGroup.minY + 0.37116 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.28390 * faceGroup.width, y: faceGroup.minY + 0.36436 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.28501 * faceGroup.width, y: faceGroup.minY + 0.36743 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.25782 * faceGroup.width, y: faceGroup.minY + 0.41920 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.29437 * faceGroup.width, y: faceGroup.minY + 0.39514 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.28450 * faceGroup.width, y: faceGroup.minY + 0.41920 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.25272 * faceGroup.width, y: faceGroup.minY + 0.41776 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.25562 * faceGroup.width, y: faceGroup.minY + 0.41855 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.25416 * faceGroup.width, y: faceGroup.minY + 0.41772 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.24118 * faceGroup.width, y: faceGroup.minY + 0.41511 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.24864 * faceGroup.width, y: faceGroup.minY + 0.41785 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.24505 * faceGroup.width, y: faceGroup.minY + 0.41621 * faceGroup.height))
        leftEyePath.addCurve(to: CGPoint(x: faceGroup.minX + 0.22805 * faceGroup.width, y: faceGroup.minY + 0.40234 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.23640 * faceGroup.width, y: faceGroup.minY + 0.41151 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.23233 * faceGroup.width, y: faceGroup.minY + 0.40708 * faceGroup.height))
        
        let leftEyeLayer = CAShapeLayer()
        leftEyeLayer.path = leftEyePath.cgPath
        leftEyeLayer.fillColor = fillColor6.cgColor
        
        //// right ear path
        let rightEarPath = UIBezierPath()
        rightEarPath.move(to: CGPoint(x: faceGroup.minX + 0.88735 * faceGroup.width, y: faceGroup.minY + 0.33909 * faceGroup.height))
        rightEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.94478 * faceGroup.width, y: faceGroup.minY + 0.29221 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.89840 * faceGroup.width, y: faceGroup.minY + 0.31750 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.93146 * faceGroup.width, y: faceGroup.minY + 0.31338 * faceGroup.height))
        rightEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.97096 * faceGroup.width, y: faceGroup.minY + 0.23098 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.95692 * faceGroup.width, y: faceGroup.minY + 0.27289 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.95286 * faceGroup.width, y: faceGroup.minY + 0.24795 * faceGroup.height))
        rightEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.96095 * faceGroup.width, y: faceGroup.minY + 0.14551 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.98980 * faceGroup.width, y: faceGroup.minY + 0.21330 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.97915 * faceGroup.width, y: faceGroup.minY + 0.16184 * faceGroup.height))
        rightEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.87910 * faceGroup.width, y: faceGroup.minY + 0.11110 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.93908 * faceGroup.width, y: faceGroup.minY + 0.12590 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.90733 * faceGroup.width, y: faceGroup.minY + 0.12026 * faceGroup.height))
        rightEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.66948 * faceGroup.width, y: faceGroup.minY + 0.11736 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.80634 * faceGroup.width, y: faceGroup.minY + 0.08748 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.74270 * faceGroup.width, y: faceGroup.minY + 0.10216 * faceGroup.height))

        
        let rightEarLayer = CAShapeLayer()
        rightEarLayer.path = rightEarPath.cgPath
        rightEarLayer.fillColor = fillColor4.cgColor
        
        rightEarLayer.strokeColor = animationModel.strokeColor.cgColor
        
        /// Adding layer to animation array
        animationModel.colorLayers.append(rightEarLayer)
        animationModel.rightEarLayer = rightEarLayer
        
        //// Left ear
        let leftEarPath = UIBezierPath()
        leftEarPath.move(to: CGPoint(x: faceGroup.minX + 0.25468 * faceGroup.width, y: faceGroup.minY + 0.13149 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.17398 * faceGroup.width, y: faceGroup.minY + 0.10727 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.22808 * faceGroup.width, y: faceGroup.minY + 0.12207 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.20081 * faceGroup.width, y: faceGroup.minY + 0.11582 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.14213 * faceGroup.width, y: faceGroup.minY + 0.10274 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.16289 * faceGroup.width, y: faceGroup.minY + 0.10374 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.15366 * faceGroup.width, y: faceGroup.minY + 0.10491 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.10723 * faceGroup.width, y: faceGroup.minY + 0.09951 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.13098 * faceGroup.width, y: faceGroup.minY + 0.10064 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.11865 * faceGroup.width, y: faceGroup.minY + 0.09707 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.05789 * faceGroup.width, y: faceGroup.minY + 0.14374 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.08451 * faceGroup.width, y: faceGroup.minY + 0.10437 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.06502 * faceGroup.width, y: faceGroup.minY + 0.12330 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.04535 * faceGroup.width, y: faceGroup.minY + 0.17798 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.05392 * faceGroup.width, y: faceGroup.minY + 0.15511 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.04561 * faceGroup.width, y: faceGroup.minY + 0.16556 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.05660 * faceGroup.width, y: faceGroup.minY + 0.21014 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.04511 * faceGroup.width, y: faceGroup.minY + 0.18947 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.05092 * faceGroup.width, y: faceGroup.minY + 0.20048 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.06627 * faceGroup.width, y: faceGroup.minY + 0.24494 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.06261 * faceGroup.width, y: faceGroup.minY + 0.22038 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.06164 * faceGroup.width, y: faceGroup.minY + 0.23467 * faceGroup.height))
        leftEarPath.addCurve(to: CGPoint(x: faceGroup.minX + 0.09162 * faceGroup.width, y: faceGroup.minY + 0.29031 * faceGroup.height), controlPoint1: CGPoint(x: faceGroup.minX + 0.07342 * faceGroup.width, y: faceGroup.minY + 0.26079 * faceGroup.height), controlPoint2: CGPoint(x: faceGroup.minX + 0.08265 * faceGroup.width, y: faceGroup.minY + 0.27545 * faceGroup.height))
        
        
        let leftEarLayer = CAShapeLayer()
        leftEarLayer.path = leftEarPath.cgPath
        leftEarLayer.fillColor = fillColor4.cgColor
        
        leftEarLayer.strokeColor = animationModel.strokeColor.cgColor
        
        /// Adding layer to animation array
        animationModel.colorLayers.append(leftEarLayer)
        
        /// adding layers
        
        layer.addSublayer(leftEarLayer)
        layer.addSublayer(rightEarLayer)
        
        layer.addSublayer(faceLayer)
        
        layer.addSublayer(leftEyeLayer)
        layer.addSublayer(rightEyeLayer)
        
        layer.addSublayer(noseBackgroundLayer)
        
        layer.addSublayer(noseLayer)
        layer.addSublayer(noseTipLayer)
        
        layer.addSublayer(hairLayer)
    }
    
    // MARK: - Animation
    func colorChange() {
        
        for layer in animationModel.colorLayers {
            discoTimeFor(layer: layer, keyPath: "strokeColor")
        }
        
        discoTimeFor(layer: animationModel.noseTipLayer, keyPath: "fillColor")
        discoTimeFor(layer: pencilBaseLayer, keyPath: "fillColor")
    }
    
    func loaderAnimation() {
        
        let rotationPoint = CGPoint(x: layer.frame.width / 2.0, y: layer.frame.height / 2.0) // The point we are rotating around
        
        let width: CGFloat = 65
        let height: CGFloat = 22
        let minX = pencilLoaderLayer.frame.minX
        let minY = pencilLoaderLayer.frame.minY
        
        let anchorPoint = CGPoint(x: (rotationPoint.x-minX)/width,
                                  y: (rotationPoint.y-minY)/height)
        
        pencilLoaderLayer.anchorPoint = anchorPoint
        pencilLoaderLayer.position = rotationPoint
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = -2*CGFloat.pi
        rotateAnimation.duration = 2
        rotateAnimation.repeatCount = .infinity
        
        pencilLoaderLayer.add(rotateAnimation, forKey: nil)
    }
    
    func rightEarAnimation() {
        
//        /// Safety checl
//        guard let rightEarLayer = animationModel.rightEarLayer else {
//            return
//        }
//
//        let random = arc4random_uniform(100)
//        
//        if random < 50 {
        
//            rightEarLayer.rotate(-CGFloat.pi/60).duration(0.5).easing(.exponentialIn).then()
//                .rotate(CGFloat.pi/24).duration(0.3).delay(0.2).easing(.exponentialIn).then()
//                .rotate(-CGFloat.pi/24).duration(0.2).easing(.exponentialIn).then()
//                .rotate(CGFloat.pi/24).duration(0.1).easing(.exponentialIn).then()
//                .rotate(-CGFloat.pi/24).duration(0.2).easing(.exponentialIn).then()
//                .rotate(CGFloat.pi/64).duration(0.1).snap(3).animate()
//        }
//        else if random < 25 {
    
//            rightEarLayer.rotate(CGFloat.pi/120).duration(0.5).snap(15).then()
//                .rotate(-CGFloat.pi/48).duration(0.3).delay(0.2).easing(.exponentialOut).then()
//                .rotate(CGFloat.pi/48).duration(0.2).easing(.exponentialOut).then()
//                .rotate(-CGFloat.pi/48).duration(0.1).easing(.exponentialIn).then()
//                .rotate(CGFloat.pi/48).duration(0.2).easing(.circ).then()
//                .rotate(-CGFloat.pi/150).duration(0.1).snap(3).animate()
//        }
    }
    
    // MARK: - Utilities
    func imageOfLogo(_ size: CGSize = CGSize(width: 391, height: 399)) -> UIImage {
        var image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.drawFace(frame: CGRect(origin: CGPoint.zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func discoTimeFor(layer: CAShapeLayer?, keyPath: String) {
        guard let layer = layer else {
            return
        }
        
        let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.magenta]
        
        var animationsArray = [CABasicAnimation]()
        
        let discoAnimation = CAAnimationGroup()
        
        for i in 0..<colors.count {
            
            let colorAnimation = CABasicAnimation(keyPath: keyPath)
            colorAnimation.beginTime = (0.33 / Double(colors.count))  * Double(i)
            colorAnimation.duration = 0.33
            colorAnimation.fromValue = colors[i].cgColor
            colorAnimation.toValue = colors[(i + 1) % colors.count].cgColor
            
            animationsArray.append(colorAnimation)
            
            discoAnimation.duration = 0.33
            discoAnimation.repeatCount = .infinity
            discoAnimation.autoreverses = false
            discoAnimation.animations = animationsArray
            discoAnimation.isRemovedOnCompletion = false
            discoAnimation.beginTime = 0.33 / 10.0 * Double(i)
            
            layer.add(discoAnimation, forKey: "party")
        }
    }
}

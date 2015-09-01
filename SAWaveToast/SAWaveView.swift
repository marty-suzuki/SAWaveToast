//
//  SAWaveView.swift
//  SAWaveToast
//
//  Created by Taiki Suzuki on 2015/08/31.
//
//

import UIKit

class SAWaveView: UIView {
    
    static let Height: CGFloat = 10
    
    private let shapeLayer: CAShapeLayer = CAShapeLayer()
    var color: UIColor? {
        didSet {
            shapeLayer.strokeColor = color?.CGColor
            shapeLayer.fillColor = color?.CGColor
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        layer.addSublayer(shapeLayer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width * 2, height: bounds.size.height)
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        shapeLayer.removeAllAnimations()
        if flag {
            startAnimation()
        }
    }
}

//MARK: Private Methods
extension SAWaveView {
    private func wavePath() -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: frame.height * 0.5))
        
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 0.5, y: frame.height * 0.5), controlPoint: CGPoint(x: frame.width * 0.25, y: -frame.height * 0.5))
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 1, y: frame.height * 0.5), controlPoint: CGPoint(x: frame.width * 0.75, y: frame.height * 1.5))
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 1.5, y: frame.height * 0.5), controlPoint: CGPoint(x: frame.width * 1.25, y: -frame.height * 0.5))
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 2, y: frame.height * 0.5), controlPoint: CGPoint(x: frame.width * 1.75, y: frame.height * 1.5))
        
        path.addLineToPoint(CGPoint(x: frame.width * 2, y: frame.height))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height * 0.5))
        
        return path.CGPath
    }
}

//MARK: Internal Methods
extension SAWaveView {
    func startAnimation() {
        shapeLayer.path = wavePath()
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 0
        animation.toValue = frame.size.width
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.removedOnCompletion = false
        animation.duration = 1
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        shapeLayer.addAnimation(animation, forKey: "move")
    }
}
//
//  SAWaveToast.swift
//  SAWaveToast
//
//  Created by 鈴木大貴 on 2015/08/24.
//
//

import UIKit

public class SAWaveToast: UIViewController {

    private let waveView = SAWaveView()
    private let contentView = UIView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .whiteColor()
        
        view.addSubview(waveView)
        
        waveView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: waveView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: waveView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -100),
            NSLayoutConstraint(item: waveView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: waveView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: SAWaveView.Height)
        ]
        view.addConstraints(constraints)
        
        view.addSubview(contentView)
        contentView.backgroundColor = .cyanColor()
        
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraints2: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: waveView, attribute: .Bottom, multiplier: 1, constant: 0)
        ]
        view.addConstraints(constraints2)
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        waveView.startAnimation()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class SAWaveView: UIView {
    
    static let Height: CGFloat = 10
    
    private let shapeLayer = CAShapeLayer()
    
    private var animationKey = ""
    
    init() {
        super.init(frame: CGRectZero)
        layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.cyanColor().CGColor
        shapeLayer.fillColor = UIColor.cyanColor().CGColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width * 2, height: bounds.size.height)
    }
    
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
    
    private func wavePath() -> CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: frame.height * 0.5))
        
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 0.5, y: frame.height / 2), controlPoint: CGPoint(x: frame.width * 0.25, y: -frame.height * 0.5))
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 1, y: frame.height / 2), controlPoint: CGPoint(x: frame.width * 0.75, y: frame.height * 1.5))
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 1.5, y: frame.height / 2), controlPoint: CGPoint(x: frame.width * 1.25, y: -frame.height * 0.5))
        path.addQuadCurveToPoint(CGPoint(x: frame.width * 2, y: frame.height / 2), controlPoint: CGPoint(x: frame.width * 1.75, y: frame.height * 1.5))
        
        path.addLineToPoint(CGPoint(x: frame.width * 2, y: frame.height))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height * 0.5))
        
        return path.CGPath
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        shapeLayer.removeAllAnimations()
        if (flag) {
            startAnimation()
        }
    }
}
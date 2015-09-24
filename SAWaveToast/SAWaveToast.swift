//
//  SAWaveToast.swift
//  SAWaveToast
//
//  Created by Taiki Suzuki on 2015/08/24.
//
//

import UIKit

public class SAWaveToast: UIViewController {

    static let Spaces = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
    static let ExtraSpace: CGFloat = 5
    
    private let containerView: UIView = UIView()
    private let waveView: SAWaveView = SAWaveView()
    private let contentView: UIView = UIView()
    private let textView: UITextView = UITextView()
    private var waveColor: UIColor = .cyanColor()
    private var attributedText: NSMutableAttributedString = NSMutableAttributedString()
    private var stopAnimation: Bool = false
    private var duration: NSTimeInterval = 5
    
    //Constrants
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private var textViewCenterXConstraint: NSLayoutConstraint?
    
    public convenience init(text: String, font: UIFont? = nil, fontColor: UIColor? = nil, waveColor: UIColor? = nil, duration: NSTimeInterval? = nil) {
        var attributes: [String : AnyObject] = [String : AnyObject]()
        if let font = font {
            attributes[NSFontAttributeName] = font
        }
        if let fontColor = fontColor {
            attributes[NSForegroundColorAttributeName] = fontColor
        }
        self.init(attributedText: NSAttributedString(string: text, attributes: attributes), waveColor: waveColor, duration: duration)
    }
    
    public init(attributedText: NSAttributedString, waveColor: UIColor? = nil, duration: NSTimeInterval? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let waveColor = waveColor {
            self.waveColor = waveColor
        }
        if let duration = duration {
            self.duration = duration
        }
        self.attributedText.appendAttributedString(attributedText)
        waveView.color = self.waveColor
        
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
            case .OrderedSame, .OrderedDescending:
                providesPresentationContextTransitionStyle = true
                definesPresentationContext = true
                modalPresentationStyle = .OverCurrentContext
            case .OrderedAscending:
                modalPresentationStyle = .CurrentContext
        }
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {}
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clearColor()
        
        let width = UIScreen.mainScreen().bounds.size.width - SAWaveToast.Spaces.left + SAWaveToast.Spaces.right
        let textHeight = attributedText.boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil).size.height
        
        setContainerView(textHeight)
        setWaveView(textHeight)
        setContentView(textHeight)
        setTextView(textHeight)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        waveView.startAnimation()
        floatingAnimation()
        
        containerViewBottomConstraint?.constant = 0
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.containerView.layoutIfNeeded()
        }, completion: nil)
        
        let delay = duration * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.stopAnimation = true
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Private Methods
extension SAWaveToast {
    private func setContainerView(textHeight: CGFloat) {
        view.addSubview(containerView)
        containerView.backgroundColor = .clearColor()
        containerView.translatesAutoresizingMaskIntoConstraints  = false
        let height = textHeight + SAWaveView.Height + SAWaveToast.Spaces.top + SAWaveToast.Spaces.bottom + SAWaveToast.ExtraSpace
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant:height)
        view.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            bottomConstraint,
            NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: height)
        ])
        containerViewBottomConstraint = bottomConstraint
    }
    
    private func setWaveView(textHeight: CGFloat) {
        containerView.addSubview(waveView)
        waveView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: waveView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: waveView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: waveView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: waveView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: SAWaveView.Height)
        ])
    }
    
    private func setContentView(textHeight: CGFloat) {
        containerView.addSubview(contentView)
        contentView.backgroundColor = waveColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: waveView, attribute: .Bottom, multiplier: 1, constant: 0)
        ])
    }
    
    private func setTextView(textHeight: CGFloat) {
        contentView.addSubview(textView)
        textView.backgroundColor = .clearColor()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.userInteractionEnabled = false
        textView.contentInset = UIEdgeInsets(top: -10, left: -4, bottom: 0, right: 0)
        let width = UIScreen.mainScreen().bounds.size.width - (SAWaveToast.Spaces.right + SAWaveToast.Spaces.left)
        let centerXConstraint = NSLayoutConstraint(item: textView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        contentView.addConstraints([
            centerXConstraint,
            NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -(SAWaveToast.Spaces.bottom + SAWaveToast.ExtraSpace)),
            NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width),
            NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: SAWaveToast.Spaces.top)
        ])
        textViewCenterXConstraint = centerXConstraint
        textView.attributedText = attributedText
    }
    
    private func willDisappearToast() {
        containerViewBottomConstraint?.constant = containerView.frame.size.height
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
            self.containerView.layoutIfNeeded()
        }) { finished in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    private func floatingAnimation() {
        stopAnimation = false
        let totalValue = (SAWaveToast.Spaces.left + SAWaveToast.Spaces.right) / 4
        let delta = (CGFloat(arc4random_uniform(UINT32_MAX)) / CGFloat(UINT32_MAX) ) * totalValue
        textViewCenterXConstraint?.constant = (arc4random_uniform(UINT32_MAX) % 2 == 0) ? delta : -delta
        if containerViewBottomConstraint?.constant == 0 {
            containerViewBottomConstraint?.constant = SAWaveToast.ExtraSpace
        } else {
            containerViewBottomConstraint?.constant = 0
        }
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.containerView.layoutIfNeeded()
        }) { finished in
            if self.stopAnimation {
                self.willDisappearToast()
            } else {
                self.floatingAnimation()
            }
        }
    }
}
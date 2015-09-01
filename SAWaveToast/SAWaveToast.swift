//
//  SAWaveToast.swift
//  SAWaveToast
//
//  Created by Taiki Suzuki on 2015/08/24.
//
//

import UIKit

public class SAWaveToast: UIViewController {

    static let Spaces = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    private let containerView: UIView = UIView()
    private let waveView: SAWaveView = SAWaveView()
    private let contentView: UIView = UIView()
    private let textView: UITextView = UITextView()
    private var waveColor: UIColor = .cyanColor()
    private var text: String = ""
    
    //Constrants
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    public init(text: String, waveColor: UIColor? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let waveColor = waveColor {
            self.waveColor = waveColor
        }
        self.text = text
        waveView.color = self.waveColor
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .whiteColor()
        
        let width = UIScreen.mainScreen().bounds.size.width
        
        let attributedText = NSAttributedString(string: text)
        let textHeight = attributedText.boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: .UsesLineFragmentOrigin | .UsesFontLeading, context: nil).size.height
        
        
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
        
        containerViewBottomConstraint?.constant = 0
        UIView.animateWithDuration(1) {
            self.containerView.layoutIfNeeded()
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
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let height = textHeight + SAWaveView.Height + SAWaveToast.Spaces.top + SAWaveToast.Spaces.bottom
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
        waveView.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraints([
            NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: SAWaveToast.Spaces.left),
            NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: SAWaveToast.Spaces.bottom),
            NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: SAWaveToast.Spaces.right),
            NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: SAWaveToast.Spaces.top)
        ])
        textView.text = text
    }
}
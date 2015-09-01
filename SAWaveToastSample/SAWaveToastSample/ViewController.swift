//
//  ViewController.swift
//  SAWaveToastSample
//
//  Created by 鈴木大貴 on 2015/08/24.
//  Copyright (c) 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import SAWaveToast

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func showWaveToast(sender: AnyObject) {
        let waveToast = SAWaveToast(text: "This is SAWaveToast!! SAWaveToast has wave and text floating animation. Default appearance time is 5 seconds.", font: .systemFontOfSize(16), fontColor: .darkGrayColor())
        presentViewController(waveToast, animated: false, completion: nil)
    }
}


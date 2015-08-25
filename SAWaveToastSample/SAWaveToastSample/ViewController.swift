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
        
        let controller = SAWaveToast()
        presentViewController(controller, animated: false, completion: nil)
    }
}


//
//  ClosureQueueController.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit

class ClosureQueueController: UIViewController {

    var closureQeeue = [DictionaryClosure]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closureQeeue.enqueue { _ in
            UIAlertController.showMessage("Test 111")
        }
        closureQeeue.enqueue { _ in
            UIAlertController.showMessage("Test 222")
        }
        closureQeeue.enqueue { _ in
            UIAlertController.showMessage("Test 333")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onInQueue(_ sender: UIButton) {
        sender.tag += 1
        let count = sender.tag
        closureQeeue.enqueue { _ in
            UIAlertController.showMessage("Test \(count)")
        }
    }
    
    @IBAction func onDequeue(_ sender: UIButton) {
        closureQeeue.dequeue()
    }
}

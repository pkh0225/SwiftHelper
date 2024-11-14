//
//  ClosureQueueController.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit

class ClosureQueueController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()
        ActionQueue.shared.addAction { _ in
            UIAlertController.alert(title: "Test 111")
        }
        ActionQueue.shared.addAction { _ in
            UIAlertController.alert(title:"Test 222")
        }
        ActionQueue.shared.addAction { _ in
            UIAlertController.alert(title:"Test 333")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onInQueue(_ sender: UIButton) {
        sender.tag += 1
        let count = sender.tag
        ActionQueue.shared.addAction { _ in
            UIAlertController.alert(title:"Test \(count)")
        }
    }
    
    @IBAction func onDequeue(_ sender: UIButton) {
        ActionQueue.shared.nextRun()
    }


    @IBAction func onMainQueue(_ sender: UIButton) {
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 0..<999 {
                DispatchQueue.main.async {
                    print(i)
                }
            }
        }

    }
}

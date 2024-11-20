//
//  ClosureQueueController.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit
import SwiftHelper

class ClosureQueueController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"

    override func viewDidLoad() {
        super.viewDidLoad()
        ActionQueue.shared.addAction { _ in
            alert(title: "Test 111", message: nil)
        }
        ActionQueue.shared.addAction { _ in
            alert(title:"Test 222", message: nil)
        }
        ActionQueue.shared.addAction { _ in
            alert(title:"Test 333", message: nil)
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
            alert(title:"Test \(count)", message: nil)
        }
    }
    
    @IBAction func onDequeue(_ sender: UIButton) {
        ActionQueue.shared.nextRun()
    }

    @IBAction func onMainQueue(_ sender: UIButton) {
        for i in 0..<5 {
            alert(title:"Test __(\(i))", message: nil, cancelButtonTitle: "취소", otherButtonTitles: ["확인"]) { alertVC,buttonIndex in
                print(buttonIndex)
            }
        }
        gcd_main_after(0.5) {
            for i in 10..<15 {
                alert(title:"Test __(\(i))", message: nil, cancelButtonTitle: "취소", otherButtonTitles: ["확인"]) { alertVC,buttonIndex in
                    print(buttonIndex)
                }
            }
        }
    }
}

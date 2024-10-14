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

    var closureQeeue = [DictionaryClosure]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closureQeeue.addAction { _ in
            UIAlertController.alert(title: "Test 111")
        }
        closureQeeue.addAction { _ in
            UIAlertController.alert(title:"Test 222")
        }
        closureQeeue.addAction { _ in
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
        closureQeeue.addAction { _ in
            UIAlertController.alert(title:"Test \(count)")
        }
    }
    
    @IBAction func onDequeue(_ sender: UIButton) {
        closureQeeue.nextRun()
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

//
//  MemoryViewController.swift
//  TestSwiftHelper
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController, PushProtocol {
    static var storyboardName: String = ""

    class AAA {
        var bbb: BBB?

        deinit {
            print("deinit AAA")
        }
    }
    class BBB {
        var array = [WeakWrapper<AAA>]()
//        var array = [AAA]()

        deinit {
            print("deinit BBB")
        }
    }

    var aaa: AAA?

    deinit {
        print("deinit MemoryViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Memory"
        self.view.backgroundColor = .white

        let a = AAA()
        a.bbb = BBB()
        a.bbb?.array.append(WeakWrapper(value: a))
//        a.bbb?.array.append(a)
        self.aaa = a
    }
}

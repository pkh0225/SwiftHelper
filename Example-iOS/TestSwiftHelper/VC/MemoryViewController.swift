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
        weak var bbb: BBB?

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

    var testDataa: AAA?

    deinit {
        print("deinit MemoryViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Memory"
        self.view.backgroundColor = .white

        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100)).apply { [weak self] obj in
            guard let self else { return }
            obj.setTitle("click", for: .normal)
            obj.backgroundColor = .green
            obj.addAction(for: .touchUpInside) { [weak self] btn in
                guard let self else { return }
                print(self.testDataa?.bbb)
            }
        }
        self.view.addSubview(btn)


        let a = AAA()
        let b = BBB()
        a.bbb = b
        a.bbb?.array.append(WeakWrapper(value: a))
//        a.bbb?.array.append(a)
        self.testDataa = a
    }
}

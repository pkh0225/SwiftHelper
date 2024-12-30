//
//  MemoryViewController.swift
//  TestSwiftHelper
//
//  Created by 박길호 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import UIKit
import SwiftHelper
import DeinitChecker

class MemoryViewController: UIViewController, RouterProtocol, DeinitChecker {
    var deinitNotifier: DeinitNotifier?
    
    static var storyboardName: String = ""

    class AAA: DeinitChecker {
        var deinitNotifier: DeinitNotifier?

        var bbb: BBB?

        init () {
            setDeinitNotifier()
        }
    }
    class BBB: DeinitChecker {
        var deinitNotifier: DeinitNotifier?

        var array = [WeakWrapper<AAA>]()
//        var array = [AAA]()
        init () {
            setDeinitNotifier()
        }
    }

    var testDataa: AAA?
    var test2VC: Test2ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Memory"
        self.view.backgroundColor = .white
        DeinitManager.shared.isRun = true

        setDeinitNotifier()

        let btn = TestButton(frame: CGRect(x: 100, y: 100, width: 200, height: 100)).apply { [weak self] obj in
            guard let self else { return }
            obj.setTitle("WeakWrapper test", for: .normal)
            obj.backgroundColor = .green
            obj.addAction(for: .touchUpInside) { [weak self] btn in
                guard let self else { return }
                print(self.testDataa?.bbb ?? "")
            }
        }
        self.view.addSubview(btn)

        let a = AAA()
        let b = BBB()
        a.bbb = b
        a.bbb?.array.append(WeakWrapper(value: a))
//        a.bbb?.array.append(a)


        self.testDataa = a


        let v = TestView(frame: CGRect(x: 10, y: 210, w: 250, h: 100))
        v.backgroundColor = .red
        self.view.addSubview(v)

        let btn2 = TestButton(frame: v.bounds).apply {
            $0.setTitle("push New ViewController", for: .normal)
            $0.addAction(for: .touchUpInside) { _ in
                Self.pushViewController()
//                print(self)
//                print(v)
            }
        }
        v.addSubview(btn2)

        test2VC = Test2ViewController()
        self.addChild(test2VC)
        self.view.addSubview(test2VC.view)
        test2VC.view.frame = CGRect(x: 100, y: 350, width: 200, height: 100)

    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if self.isMovingFromParent {
//            print("------- is being popped")
//            // 여기서 pop 이벤트 처리
//
//
//        }
//    }
}

class Test2ViewController: UIViewController, DeinitChecker {
    var deinitNotifier: DeinitNotifier?

    override func viewDidLoad() {
        super.viewDidLoad()
        setDeinitNotifier()
        view.backgroundColor = .blue

        let button = TestButton()
        button.frame = self.view.bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.setTitle("Test2ViewController", for: .normal)
        button.addAction(for: .touchUpInside) { _ in
            alert(title: "", message: "Test2ViewController")
//            print(self)
        }
        view.addSubview(button)
    }
}

class TestButton: UIButton, DeinitChecker {
    var deinitNotifier: DeinitNotifier?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDeinitNotifier()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDeinitNotifier()
    }
}

class TestView: UIView , DeinitChecker {
    var deinitNotifier: DeinitNotifier?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDeinitNotifier()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDeinitNotifier()
    }
}



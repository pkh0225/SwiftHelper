//
//  MemoryViewController.swift
//  TestSwiftHelper
//
//  Created by 박길호 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController, RouterProtocol {
    static var storyboardName: String = ""

    class AAA {

        var bbb: BBB?

        deinit {
            print("\(#function) \(Self.self)")
        }
    }
    class BBB {

        var array = [WeakWrapper<AAA>]()
//        var array = [AAA]()

        deinit {
            print("\(#function) \(Self.self)")
        }
    }

    var testDataa: AAA?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Memory"
        self.view.backgroundColor = .white

        let btn = TestButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100)).apply { obj in
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


class Deallocator {
    var onDeallocate: () -> Void

    init(onDeallocate: @escaping () -> Void) {
        self.onDeallocate = onDeallocate
    }

    deinit {
        onDeallocate()
    }
}



extension UIViewController {
    private struct AssociatedKeys {
        static var deallocator: UInt8 = 0
    }

    class func swizzleMethodForDealloc() {
        let originalSelector = #selector(viewDidLoad)
        let swizzledSelector = #selector(swizzled_viewDidLoad)
        guard
            let originalMethod = class_getInstanceMethod(Self.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc private func swizzled_viewDidLoad() {
        let deallocator = Deallocator { print("swizzled deinit: \(Self.self)") }
        objc_setAssociatedObject(self, &AssociatedKeys.deallocator, deallocator, .OBJC_ASSOCIATION_RETAIN)
    }
}


class TestButton: UIButton {
    deinit {
        print("\(#function) \(Self.self)")
    }
}

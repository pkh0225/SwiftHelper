//
//  ScopeViewController.swift
//  TestSwiftHelper
//
//  Created by 박길호 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import UIKit
import SwiftHelper

class SccopeViewController: UIViewController, RouterProtocol {
    static var storyboardName: String = ""

    struct TestStruct: ScopeAble {
        var a: Int = 12345
        var b: String = "TestClass"
    }

    class PersonClass: NSObject {
        var name: String = ""
        var age: Int = 0
        var array = [Int]()
        var objArray = [TestStruct]()

        override init() {
            array = [1,2,3,4,5]
            objArray.append(TestStruct().apply {
                $0.a = 1
                $0.b = "1"
            })
            objArray.append(TestStruct().apply {
                $0.a = 2
                $0.b = "2"
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sccope"
        self.view.backgroundColor = .white

        test()

        ToastView(text: "102-39748-01239745-09128390-48123-908-0").show()
    }

    func test() {
        var stringList = [String]()
        
        stringList.append("""
        let testObject = TestStruct().apply {
            $0.a = 1111
            $0.b = "9999"
        }
        stringList.append("### 1 \\(testObject.des())")

        testObject.run {
            stringList.append("### 2 run a \\($0.a)")
            stringList.append("### 2 run b \\($0.b)")
        }
        stringList.append("### 2 \\(testObject.des())")

        let runTestObject = testObject.run {
            return $0.a + 100
        }
        stringList.append("### 3 \\(testObject.des())")
        stringList.append("### 3 runTestObject result = \\(runTestObject)")

        let o = PersonClass().apply {
            $0.name = "park"
            $0.age = 10
        }
        stringList.append("### 4 \\(o.des())")

        o.run {
            $0.name = "han"
            $0.age = 28
        }
        stringList.append("### 5 \\(o.des())")

        let runTest = o.run {
            $0.name = "han2"
            $0.age = 28
            return $0.age > 18
        }
        stringList.append("### 6 \\(o.des())")
        stringList.append("### 6 runTest result = \\(runTest)")

        let withTest = with(o) {
            $0.name = "Kim"
            $0.age = 12
            return $0.age > 18
        }
        stringList.append("### 7 \\(o.des())")
        stringList.append("### 7 withTest result = \\(withTest)")

        with(o) {
            $0.name = "Kim2"
            $0.age = 18
        }

        o.takeIf { $0.age > 10 }?.run { obj in
            stringList.append("### 8 takeIf \\(obj)")
        }

        stringList.append("### 99 \\(o.des())")

        ⬇️⬇️⬇️⬇️⬇️⬇️  Result ⬇️⬇️⬇️⬇️⬇️⬇️

        """)

        let testObject = TestStruct().apply {
            $0.a = 1111
            $0.b = "9999"
        }
        stringList.append("### 1 \(testObject.des())")

        testObject.run {
            stringList.append("### 2 run a \($0.a)")
            stringList.append("### 2 run b \($0.b)")
        }
        stringList.append("### 2 \(testObject.des())")

        let runTestObject = testObject.run {
            return $0.a + 100
        }
        stringList.append("### 3 \(testObject.des())")
        stringList.append("### 3 runTestObject result = \(runTestObject)")

        let o = PersonClass().apply {
            $0.name = "park"
            $0.age = 10
        }
        stringList.append("### 4 \(o.des())")

        o.run {
            $0.name = "han"
            $0.age = 28
        }
        stringList.append("### 5 \(o.des())")

        let runTest = o.run {
            $0.name = "han2"
            $0.age = 28
            return $0.age > 18
        }
        stringList.append("### 6 \(o.des())")
        stringList.append("### 6 runTest result = \(runTest)")

        let withTest = with(o) {
            $0.name = "Kim"
            $0.age = 12
            return $0.age > 18
        }
        stringList.append("### 7 \(o.des())")
        stringList.append("### 7 withTest result = \(withTest)")

        with(o) {
            $0.name = "Kim2"
            $0.age = 18
        }

        o.takeIf { $0.age > 10 }?.run { obj in
            stringList.append("### 8 takeIf \(obj)")
        }

        stringList.append("### 99 \(o.des())")

        let result = stringList.joined(separator: "\n")

        makeDebugTextView(value: result)
    }
}


//
//  ViewController.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit

class TestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self)

        let testObject = TestClass().apply {
            $0.a = 1111
            $0.b = "9999"
        }
        print("### 1 \(testObject.des())")

        testObject.run {
            print("### 2 run a \($0.a)")
            print("### 2 run b \($0.b)")
        }
        print("### 2 \(testObject.des())")

        let runTestObject = testObject.run {
            return $0.a + 100
        }
        print("### 3 \(testObject.des())")
        print("### 3 runTestObject result = \(runTestObject)")

        let o = Person().apply {
            $0.name = "park"
            $0.age = 10
        }
        print("### 4 \(o.des())")

        o.run {
            $0.name = "han"
            $0.age = 28
        }
        print("### 5 \(o.des())")

        let runTest = o.run {
            $0.name = "han2"
            $0.age = 28
            return $0.age > 18
        }
        print("### 6 \(o.des())")
        print("### 6 runTest result = \(runTest)")

        let withTest = with(o) {
            $0.name = "Kim"
            $0.age = 12
            return $0.age > 18
        }
        print("### 7 \(o.des())")
        print("### 7 withTest result = \(withTest)")

        with(o) {
            $0.name = "Kim2"
            $0.age = 18
        }

        print("### 8 \(o.des())")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func assembleModule(identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "UIView AutoLayout Extensions"
        case 1:
            cell.textLabel?.text = "Closure Queue"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = assembleModule(identifier: AutoLayoutController.className)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let vc = assembleModule(identifier: ClosureQueueController.className)
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}


struct TestClass: Appliable {
    var a: Int = 12345
    var b: String = "TestClass"
}
class Person: NSObject {
    var name: String = ""
    var age: Int = 0
    var array = [Int]()
    var objArray = [TestClass]()

    override init() {
        array = [1,2,3,4,5]
        objArray.append(TestClass().apply {
            $0.a = 1
            $0.b = "1"
        })
        objArray.append(TestClass().apply {
            $0.a = 2
            $0.b = "2"
        })
    }
}

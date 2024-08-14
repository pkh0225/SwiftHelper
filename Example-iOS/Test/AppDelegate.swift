//
//  AppDelegate.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


//
//  PushProtocol.swift
//  TestSwiftHelper
//
//  Created by 박길호 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import UIKit

@inline(__always) public func KeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scenes?.windows.first
    } 
    else {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}

@inline(__always) public func MainNavigation() -> UINavigationController? {
    guard let navigationController = KeyWindow()?.rootViewController as? UINavigationController else { return nil }
    return navigationController
}

public class ViewControllerCache {
    @Atomic static var cacheViewControllers: NSCache<NSString, UIViewController> = {
        var c = NSCache<NSString, UIViewController>()
        c.countLimit = 150
        return c
    }()
    @Atomic static var cacheStoryBoardInstance: NSCache<NSString, UIStoryboard> = {
        var c = NSCache<NSString, UIStoryboard>()
        c.countLimit = 150
        return c
    }()

    public static func cacheRemoveAll() {
        self.cacheViewControllers.removeAllObjects()
        self.cacheStoryBoardInstance.removeAllObjects()
    }
}

protocol PushProtocol: UIViewController {
    /// 초기화 시 vc를 init하는 데 필요한 스토리보드 이름, 없거나 xib만 존재 시 해당 필드는 빈 값("")으로 정의 가능.
    static var storyboardName: String { get }
    
    /// 같은 ViewController를 중복으로 push를 막아 주는 기능
    /// - Returns: 중복 push 허용 여부
    static func isAllowSameVCPush() -> Bool
}

extension PushProtocol {
    static func isAllowSameVCPush() -> Bool {
        return false
    }

    // MARK:- assembleModule
    private static func assembleModule(cache: Bool = false) -> Self {
        if self.storyboardName.isValid {
            if let storyboard: UIStoryboard = ViewControllerCache.cacheStoryBoardInstance.object(forKey: self.storyboardName as NSString) {
                if let vc = storyboard.instantiateViewController(withIdentifier: self.className) as? Self {
                    return vc
                }
            }
            else {
                let storyboard = UIStoryboard(name: self.storyboardName, bundle: Bundle.main)
                if cache {
                    ViewControllerCache.cacheStoryBoardInstance.setObject(storyboard, forKey: self.storyboardName as NSString)
                }
                if let vc = storyboard.instantiateViewController(withIdentifier: self.className) as? Self {
                    return vc
                }
            }
        }

        return self.init()
    }

    // MARK:- getViewController
    static public func getViewController(cache: Bool = false) -> Self {
        if cache {
            if let vc = ViewControllerCache.cacheViewControllers.object(forKey: self.className as NSString) {
                return vc as! Self
            }
            else {
                let vc = assembleModule()
                ViewControllerCache.cacheViewControllers.setObject(vc, forKey: self.className as NSString)
                vc.cache = true
                vc.view.cache = true
                return vc
            }
        }
        return assembleModule()
    }

    // MARK:- pushViewController
    static public func pushViewController(animated: Bool = true, vcClosure: ((Self) -> Void)? = nil) {
        guard let navi = MainNavigation() else { return }
        if navi.viewControllers.last is Self {
            if !Self.isAllowSameVCPush() {
                return
            }
        }
        let vc = getViewController()
        vcClosure?(vc)
        navi.pushViewController(vc, animated: animated)
    }

    static public func transparentPresentViewController(animated: Bool = true, completion: (() -> Void)? = nil, vcClosure: ((Self) -> Void)? = nil) {
        guard let navi = MainNavigation() else { return }
        let vc = getViewController()
        vc.modalPresentationStyle = .overFullScreen
        vcClosure?(vc)
        navi.visibleViewController?.present(vc, animated: animated, completion: completion)
    }
}

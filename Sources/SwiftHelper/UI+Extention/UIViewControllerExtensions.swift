//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.

#if os(iOS) || os(tvOS)

import UIKit

extension UIViewController {
    /// UIViewController가 진입시 viewDidAppear에서 한번만 필요한 기능 호출하기
    public var isFirstShow: Bool { isBeingDismissed || isMovingFromParent }

    public var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        }
        else if presentingViewController != nil {
            return true
        }
        else if let navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        else if let tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        }
        else {
            return false
        }
    }

    public var parentVCs: [UIViewController] {
        var vcs: [UIViewController] = [UIViewController]()
        var vc: UIViewController? = self.parent
        while vc != nil {
            vcs.append(vc!)
            vc = vc!.parent
        }
        return vcs
    }

    public var topParentVC: UIViewController? {
        var vcs = parentVCs

        if let navi: UINavigationController = vcs.last as? UINavigationController {
            vcs.remove(object: navi)
            if let lastVC = vcs.last {
                return lastVC
            }
        }
        return nil
    }

    public func getParentVC<T: UIViewController>(type: T.Type) -> T? {
        for vc in parentVCs {
            if let vcT = vc as? T {
                return vcT
            }
        }
        return nil
    }

    // MARK: - Notifications

    ///  Removes NotificationCenter'd observer
    public func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    //  Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    public func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }

    //  Dismisses keyboard
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - VC Container

    ///  Returns maximum y of the ViewController
    public var top: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.top
        }
        if let nav = self.navigationController {
            if nav.isNavigationBarHidden {
                return view.top
            }
            else {
                return nav.navigationBar.bottom
            }
        }
        else {
            return view.top
        }
    }

    ///  Returns minimum y of the ViewController
    public var bottom: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.bottom
        }
        if let tab = tabBarController {
            if tab.tabBar.isHidden {
                return view.bottom
            }
            else {
                return tab.tabBar.top
            }
        }
        else {
            return view.bottom
        }
    }

    ///  Returns Tab Bar's height
    public var tabBarHeight: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }

    ///  Returns Navigation Bar's height
    public var navigationBarHeight: CGFloat {
        if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.h
        }
        return 0
    }

    ///  Returns Navigation Bar's color
    public var navigationBarColor: UIColor? {
        get {
            if let me: UINavigationController = self as? UINavigationController, let visibleViewController: UIViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }

    ///  Returns current Navigation Bar
    public var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }

    /// EZSwiftExtensions
    public var applicationFrame: CGRect {
        return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
    }

    // MARK: - VC Flow

    ///  Pushes a view controller onto the receiver’s stack and updates the display.
    public func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    ///  Pops the top view controller from the navigation stack and updates the display.
    @objc open func popVC(_ animated: Bool = false) {
        navigationController?.popViewController(animated: animated)
    }

    public func popVC(popVCs: [UIViewController]) {
        guard let nv = navigationController else { return }
        let vcs = nv.viewControllers.filter({ vc -> Bool in
            return !popVCs.contains(vc)
        })
        nv.viewControllers = vcs
    }

    ///   Hide or show navigation bar
    public var isNavBarHidden: Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }

    ///   Added extension for popToRootViewController
    public func popToRootVC(_ animated: Bool = false) {
        navigationController?.popToRootViewController(animated: true)
    }

    ///  Presents a view controller modally.
    public func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }

    ///  Dismisses the view controller that was presented modally by the view controller.
    public func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }

    ///  Adds the specified view controller as a child of the current view controller.
    public func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    ///  Adds image named: as a UIImageView in the Background
    public func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

    ///  Adds UIImage as a UIImageView in the Background
    public func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

    #if os(iOS)
    public func hideKeyboardWhenTappedAroundAndCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    #endif

    /// iPhone에서는 present 함수와 동작 동일, iPad 에서는 popover 처리를 해줌.
    public func presentOnto(_ viewControllerToPresent: UIViewController, animated flag: Bool, sender: Any? = nil, completion: (() -> Void)? = nil) {
        if UIDevice.current.getiPhoneScreen() == .iPad {
            viewControllerToPresent.modalPresentationStyle = .popover
            let ppc = viewControllerToPresent.popoverPresentationController
            if let sender = sender as? UIButton {
                ppc?.barButtonItem = UIBarButtonItem(customView: sender)
            }
            else {
                // sender 정보가 없거나(불특정 이벤트 등으로 popover 해야 하는 상황) 좌표를 특정하기 어려운 경우 center에 배치
                ppc?.sourceView = self.view
                ppc?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            ppc?.permittedArrowDirections = .any
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
        else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}


//extension UIViewController {
//    private struct AssociatedKeys {
//        nonisolated(unsafe) static var deinitNotifier: UInt8 = 0
//    }
//
//    public static var isDeinitChecker: Bool = false
//
//    public static func enableDeinitChecker() {
//        guard !isDeinitChecker else { return }
//        isDeinitChecker = true
//        swizzleMethodForViewDidLoad()
//
//    }
//
//    public static func disableDeinitChecker() {
//        guard isDeinitChecker else { return }
//        isDeinitChecker = false
//        swizzleMethodForViewDidLoad() // 다시 교환하여 원래 상태로 복구
//    }
//
//    public static func swizzleMethodForViewDidLoad() {
//        let originalSelector = #selector(viewDidLoad)
//        let swizzledSelector = #selector(swizzled_viewDidLoad)
//        guard
//            let originalMethod = class_getInstanceMethod(Self.self, originalSelector),
//            let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector)
//        else { return }
//        method_exchangeImplementations(originalMethod, swizzledMethod)
//    }
//
//    @objc private func swizzled_viewDidLoad() {
//        let deinitNotifier = DeinitNotifier { print("swizzled deinit: \(Self.self)") }
//        objc_setAssociatedObject(self, &AssociatedKeys.deinitNotifier, deinitNotifier, .OBJC_ASSOCIATION_RETAIN)
//    }
//}

#endif

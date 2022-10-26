//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.

#if os(iOS) || os(tvOS)

import UIKit

//extension UINavigationController {
//    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> ()) {
//        pushViewController(viewController, animated: animated)
//
//        if let coordinator = transitionCoordinator, animated {
//            coordinator.animate(alongsideTransition: nil) { _ in
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
//
//    func popViewController(animated: Bool, completion: @escaping () -> ()) {
//        popViewController(animated: animated)
//
//        if let coordinator = transitionCoordinator, animated {
//            coordinator.animate(alongsideTransition: nil) { _ in
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
//}
    

////Extension:- UIViewController iPhoneX - Bottom SafeLayoutGuide 색칠
//private static let insetBackgroundViewTag = 98721 //Cool number
//
//func paintSafeAreaBottomInset(withColor color: UIColor) {
//    guard #available(iOS 11.0, *) else {
//        return
//    }
//    if let insetView = view.viewWithTag(UIViewController.insetBackgroundViewTag) {
//        insetView.backgroundColor = color
//        return
//    }
//
//    let insetView = UIView(frame: .zero)
//    insetView.tag = UIViewController.insetBackgroundViewTag
//    insetView.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(insetView)
//    view.sendSubview(toBack: insetView)
//
//    insetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//    insetView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    insetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    insetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//
//    insetView.backgroundColor = color
//}
    

    
    
extension UIViewController {
    public var parentVCs: [UIViewController] {
        var vcs = [UIViewController]()
        var vc: UIViewController? = self.parent
        while vc != nil {
            vcs.append(vc!)
            vc = vc!.parent
        }
        return vcs
    }
    
    public var topParentVC: UIViewController? {
        var vcs = parentVCs
        
        if let navi = vcs.last as? UINavigationController {
            vcs.remove(object: navi)
            if let lastVC = vcs.last {
                return lastVC
            }
        }
        return nil
    }
    
    public func getParentVC<T:UIViewController>(type: T.Type) -> T? {
        for vc in parentVCs {
            if let vcT = vc as? T {
                return vcT
            }
        }
        return nil
    }
    
    // MARK: - Notifications
    
    ///  Adds an NotificationCenter with name and Selector
    open func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///  Removes an NSNotificationCenter for name
    open func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///  Removes NotificationCenter'd observer
    open func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    #if os(iOS)
    
    ///  Adds a NotificationCenter Observer for keyboardWillShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillShowNotification(_ notification: Notification)```
    open func addKeyboardWillShowNotification() {
        self.addNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue, selector: #selector(UIViewController.keyboardWillShowNotification(_:)))
    }
    
    ///   Adds a NotificationCenter Observer for keyboardDidShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidShowNotification(_ notification: Notification)```
    public func addKeyboardDidShowNotification() {
        self.addNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue, selector: #selector(UIViewController.keyboardDidShowNotification(_:)))
    }
    
    ///   Adds a NotificationCenter Observer for keyboardWillHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillHideNotification(_ notification: Notification)```
    open func addKeyboardWillHideNotification() {
        self.addNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue, selector: #selector(UIViewController.keyboardWillHideNotification(_:)))
    }
    
    ///   Adds a NotificationCenter Observer for keyboardDidHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidHideNotification(_ notification: Notification)```
    open func addKeyboardDidHideNotification() {
        self.addNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue, selector: #selector(UIViewController.keyboardDidHideNotification(_:)))
    }
    
    ///  Removes keyboardWillShowNotification()'s NotificationCenter Observer
    open func removeKeyboardWillShowNotification() {
        self.removeNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue)
    }
    
    ///  Removes keyboardDidShowNotification()'s NotificationCenter Observer
    open func removeKeyboardDidShowNotification() {
        self.removeNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue)
    }
    
    ///  Removes keyboardWillHideNotification()'s NotificationCenter Observer
    open func removeKeyboardWillHideNotification() {
        self.removeNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue)
    }
    
    ///  Removes keyboardDidHideNotification()'s NotificationCenter Observer
    open func removeKeyboardDidHideNotification() {
        self.removeNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue)
    }
    
    @objc open func keyboardDidShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillHideWithFrame(frame)
        }
    }
    
    @objc open func keyboardDidHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidHideWithFrame(frame)
        }
    }
    
    open func keyboardWillShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardWillHideWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidHideWithFrame(_ frame: CGRect) {
        
    }
    
    //  Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    open func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }
    
    #endif
    
    //  Dismisses keyboard
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - VC Container
    
    ///  Returns maximum y of the ViewController
    open var top: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
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
    open var bottom: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
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
    open var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    ///  Returns Navigation Bar's height
    open var navigationBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.h
        }
        return 0
    }
    
    ///  Returns Navigation Bar's color
    open var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }
    
    ///  Returns current Navigation Bar
    open var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    /// EZSwiftExtensions
    open var applicationFrame: CGRect {
        return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
    }
    
    // MARK: - VC Flow
    
    ///  Pushes a view controller onto the receiver’s stack and updates the display.
    open func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///  Pops the top view controller from the navigation stack and updates the display.
    open func popVC(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    open func popVC(popVCs: [UIViewController]) {
        
        guard let nv = navigationController else { return }
        let vcs = nv.viewControllers.filter({ (vc) -> Bool in
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
    open func popToRootVC(_ animated: Bool = true) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    ///  Presents a view controller modally.
    open func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    ///  Dismisses the view controller that was presented modally by the view controller.
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
    ///  Adds the specified view controller as a child of the current view controller.
    open func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    ///  Adds image named: as a UIImageView in the Background
    open func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    ///  Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    #if os(iOS)

    @available(*, deprecated: 1.9)
    public func hideKeyboardWhenTappedAroundAndCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    #endif
}

#endif

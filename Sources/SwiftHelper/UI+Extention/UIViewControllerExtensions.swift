//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.

#if os(iOS) || os(tvOS)

import UIKit

@MainActor
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

    // MARK: - VC Flow

    ///  Pushes a view controller onto the receiver’s stack and updates the display.
    public func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    ///  Pops the top view controller from the navigation stack and updates the display.
    @objc open func popVC(_ animated: Bool = false) {
        guard let navigationController else { return }

        if let parent, !(parent is UINavigationController) {
            parent.popVC(animated)
            return
        }

        guard navigationController.viewControllers.contains(where: { $0 === self }) else {
            return
        }
        // 스택에 자기 혼자면 제거 시 빈 네비게이션이 되므로 무시한다.
        guard navigationController.viewControllers.count > 1 else { return }

        if animated {
            guard navigationController.transitionCoordinator == nil else { return }
            navigationController.popViewController(animated: true)
        }
        else {
            let viewControllers = navigationController.viewControllers.filter { $0 !== self }
            navigationController.setViewControllers(viewControllers, animated: false)
        }
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

    /// iPhone에서는 present 함수와 동작 동일, iPad 에서는 popover 처리를 해줌.
    public func presentOnto(_ viewControllerToPresent: UIViewController, animated flag: Bool, sender: Any? = nil, completion: (() -> Void)? = nil) {
        if UIDevice.current.userInterfaceIdiom == .pad {
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

#endif

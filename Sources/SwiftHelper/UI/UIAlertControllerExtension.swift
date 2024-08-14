//
//  UIAlertControllerExtension.swift
//  WiggleSDK
//
//  Created by mykim on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import UIKit

public typealias UIAlertControllerClosure = (_ alertVC: UIAlertController, _ buttonIndex: Int) -> Void

extension UIAlertController {
    public func getActionIndex(_ action: UIAlertAction) -> Int {
        for i in 0..<self.actions.count {
            if action == self.actions[i] {
                return i
            }
        }

        return -1
    }

    public func show() {
        func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
            func keyWindow() -> UIWindow? {
                if #available(iOS 13.0, *) {
                    // iOS 13 이상에서는 UIWindowScene을 사용하여 key window를 가져옵니다.
                    return UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }  // UIWindowScene으로 타입 캐스팅
                        .flatMap { $0.windows }  // 모든 윈도우들을 하나의 배열로 만듭니다.
                        .first { $0.isKeyWindow }  // keyWindow인 윈도우를 반환
                } else {
                    // iOS 12 이하에서는 keyWindow를 직접 반환합니다.
                    return UIApplication.shared.keyWindow
                }
            }

            var aBase = base

            if aBase == nil {
                if Thread.isMainThread {
                    aBase = keyWindow()?.rootViewController
                }
                else {
                    return nil
                }
            }

            if let nav = aBase as? UINavigationController {
                if let vc = nav.visibleViewController {
                    return topViewController(vc)
                }
            }
            else if let tab = aBase as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(selected)
                }
            }
            else if let presented = aBase?.presentedViewController {
                return topViewController(presented)
            }
            return aBase
        }
        DispatchQueue.main.async {
            topViewController()?.presentOnto(self, animated: true, completion: nil)
        }
    }

    public static func alert(title: String?,
                      message: String? = nil,
                      cancelButtonTitle: String? = "확인",
                      otherButtonTitles: String?...,
                      isAutoHide: Bool = false,
                             closure: UIAlertControllerClosure? = nil,
                             autoHideClosure: VoidClosure? = nil) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let cancelTitle = cancelButtonTitle {
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action: UIAlertAction) in
                if let callBack = closure {
                    callBack(alert, alert.getActionIndex(action))
                }
            })

            alert.addAction(cancelAction)
        }

        for title in otherButtonTitles {
            guard let title else { continue }
            let otherAction: UIAlertAction = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
                if let callBack = closure {
                    callBack(alert, alert.getActionIndex(action))
                }
            })

            alert.addAction(otherAction)
        }

        alert.show()

        if isAutoHide {
            // auto close
            let deadlineTime: DispatchTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                alert.dismiss(animated: true, completion: autoHideClosure)
            }
        }
    }

    public static func actionSheet(title: String? = nil,
                            message: String? = nil,
                            buttonTitles: [String],
                            closure: UIAlertControllerClosure? = nil) {
        guard buttonTitles.count > 0 else { return }

        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for (idx, title) in buttonTitles.enumerated() {
            var style: UIAlertAction.Style = .default
            if idx == 0 {
                style = .cancel
            }

            let action: UIAlertAction = UIAlertAction(title: title, style: style) { action in
                if let callBack = closure {
                    callBack(alert, alert.getActionIndex(action))
                }
            }
            alert.addAction(action)
        }
        alert.show()
    }

}

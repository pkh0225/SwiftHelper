//
//  UIAlertControllerExtension.swift
//  WiggleSDK
//
//  Created by mykim on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

public typealias UIAlertControllerClosure = (_ alertView: UIAlertController, _ buttonIndex: Int) -> Void

extension UIAlertController {
    public func showWindow() {
        DispatchQueue.main.async {
            let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = UIViewController()
            window.windowLevel = UIWindow.Level.alert
            window.makeKeyAndVisible()

            window.rootViewController?.presentOnto(self, animated: true, completion: {
            })
        }
    }

    public func getActionIndex(_ action: UIAlertAction) -> Int {
        for i in 0..<self.actions.count {
            if action == self.actions[i] {
                return i
            }
        }

        return -1
    }

    public func show(_ useNewWindow: Bool = false) {
        DispatchQueue.main.async {
            if useNewWindow {
                self.showWindow()
            }
            else {
                if #available(iOS 13.0, *) {
                    DispatchQueue.main.async {
                        UIApplication.shared.keyWindow?.rootViewController?.presentOnto(self, animated: true, completion: nil)
                    }
                }
                else {
                    // 13미만에서 드롭다운 박스 아래로 얼럿 뜨는 현상 수정
                    // https://redmine.ssgadm.com/redmine/issues/395088
                    self.showWindow()
                }
            }
        }
    }

    public static func alert(title: String?,
                      message: String? = nil,
                      cancelButtonTitle: String? = "확인",
                      otherButtonTitles: String?...,
                      isAutoHide: Bool = false,
                      closure: UIAlertControllerClosure? = nil) {
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
            guard let title = title else { continue }
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
                alert.dismiss(animated: true, completion: {})
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

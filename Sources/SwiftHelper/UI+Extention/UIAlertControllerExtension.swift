//
//  UIAlertControllerExtension.swift
//  SwiftHelper
//
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

public typealias UIAlertControllerClosure = (_ alertVC: UIAlertController, _ buttonIndex: Int) -> Void

@MainActor
extension UIAlertController {
    @discardableResult
    public static func alert(title: String?,
                             message: String? = nil,
                             cancelButtonTitle: String? = "확인",
                             otherButtonTitles: String...,
                             isAutoHide: Bool = false) async -> Int {
        return await withCheckedContinuation { continuation in
            self.alert(title: title,
                       message: message,
                       cancelButtonTitle: cancelButtonTitle,
                       otherButtonTitles: otherButtonTitles,
                       isAutoHide: isAutoHide,
                       closure: { _, index in
                continuation.resume(returning: index)
            })
        }
    }

    public static func alert(title: String?,
                             message: String? = nil,
                             cancelButtonTitle: String? = "확인",
                             otherButtonTitles: String...,
                             isAutoHide: Bool = false,
                             closure: UIAlertControllerClosure? = nil) {
        alert(title: title,
              message: message,
              cancelButtonTitle: cancelButtonTitle,
              otherButtonTitles: otherButtonTitles,
              isAutoHide: isAutoHide,
              closure: closure)
    }

    private static func alert(title: String?,
                              message: String? = nil,
                              cancelButtonTitle: String? = "확인",
                              otherButtonTitles: [String],
                              isAutoHide: Bool = false,
                              closure: UIAlertControllerClosure? = nil) {
        Task { @MainActor in
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
                try await Task.sleep(nanoseconds: 2_000_000_000)

                alert.dismiss(animated: true, completion: nil)
            }
        }
     }

    private func getActionIndex(_ action: UIAlertAction) -> Int {
        for i in 0..<self.actions.count {
            if action == self.actions[i] {
                return i
            }
        }

        return -1
    }

    public func show() {
        topViewController()?.presentOnto(self, animated: true, completion: nil)
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

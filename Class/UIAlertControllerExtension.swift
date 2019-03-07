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
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, _ closure: UIAlertControllerClosure?, _ cancelButtonTitle: String?, _ otherButtonTitles: String?...) {
        
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        if let title = cancelButtonTitle {
            let cancel: UIAlertAction = UIAlertAction(title: title, style: .cancel, handler: { (action: UIAlertAction) in
                if let callBack =  closure {
                    callBack(self, self.getActionIndex(action))
                }
            })
            
            self.addAction(cancel)
        }
        
        for oTitle in otherButtonTitles {
            if let title = oTitle {
                let action: UIAlertAction = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
                    if let callBack =  closure {
                        callBack(self, self.getActionIndex(action))
                    }
                })
                
                self.addAction(action)
            }
        }
        
        
    }
    
    public class func showAlertTitle(_ title: String?, _ message: String?, _ hide: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if hide {
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                alertController.dismiss(animated: true, completion: {})
            }
        }
        else {
            let cancel: UIAlertAction = UIAlertAction(title: "확인", style: .cancel, handler: { (action: UIAlertAction) in })
            alertController.addAction(cancel)
        }
        alertController.show()
    }
    
    public func showWindow() {
        DispatchQueue.main.async {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = UIViewController()
            window.windowLevel = UIWindow.Level.alert
            window.makeKeyAndVisible()
            window.rootViewController?.present(self, animated: true, completion: {
                
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
    
}


extension UIAlertController {
    ///   Easy way to present UIAlertController
    public func show(_ useNewWindow: Bool = true) {
        if useNewWindow {
            self.showWindow()
        }
        else {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
        }
    }
    
    public func alert(_ title: String?, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("common_cancel", comment: ""), style: .cancel) { action -> Void in
            
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    public static func showMessage(_ message: String) {
        showAlert(title: "", message: message, actions: [UIAlertAction(title: "확인", style: .cancel, handler: nil)])
    }
    
    public static func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for action in actions {
                alert.addAction(action)
            }
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let presenting = navigationController.topViewController {
                presenting.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//
//  ToastView.swift
//  SwiftHelper
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 12/27/24.
//

import UIKit

@MainActor
public func toast(inView parentView: UIView? = nil,
                  withText text: String,
                  positionType: ToastView.PositionType = .center,
                  withBackGroundColor color: UIColor? = nil,
                  gapHeight: CGFloat = 0) {
    ToastView.toast(inView: parentView,
                    withText: text,
                    positionType: positionType,
                    withBackGroundColor: color,
                    gapHeight: gapHeight)
}

@MainActor
public final class ToastView: UIView {
    public enum PositionType {
        case top
        case center
        case bottom
    }

    static var kDuration: TimeInterval = 3
    @Atomic static var toasts = [ToastView]()
    static var timer: Timer?
    var textLabel: UILabel!
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    convenience init(text: String) {
        self.init(frame: CGRect(x: 0, y: 0, w: 100, h: 100))
        // Add corner radius
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        layer.cornerRadius = 8
        autoresizingMask = []
        autoresizesSubviews = false
        isUserInteractionEnabled = false
        // Init and add label
        textLabel = UILabel()
        textLabel.frame = self.bounds
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = UIColor.white
        textLabel.lineBreakMode = .byCharWrapping
        textLabel.adjustsFontSizeToFitWidth = false
        textLabel.backgroundColor = UIColor.clear
        let width: CGFloat = UIScreen.main.bounds.size.width - 32
        textLabel.frame.size.width = width
        let height = text.height(maxWidth: width, font: textLabel.font)
        textLabel.frame.size.height = height
        if textLabel.frame.size.width > width {
            textLabel.frame.size.width = width
        }

        textLabel.sizeToFit()
        addSubview(textLabel)

        self.frame.size.width = UIScreen.main.bounds.size.width - 32
        self.frame.size.height = textLabel.h + 24
        textLabel.center = CGPoint(x: self.w / 2.0, y: self.h / 2.0)
    }

    public static func toast(inView parentView: UIView? = nil,
                             withText text: String,
                             positionType: ToastView.PositionType = .center,
                             withBackGroundColor color: UIColor? = nil,
                             gapHeight: CGFloat = 0) {
        guard text.isValid else { return }
        if let lastView = toasts.last, lastView.textLabel.text == text {
            return
        }

        DispatchQueue.main.async {
            let aParentView: UIView?
            if parentView == nil {
                aParentView = keyWindow()
            }
            else {
                aParentView = parentView
            }

            // Add new instance to queue
            let view = ToastView(text: text)
            view.alpha = 0.0
            if let color = color {
                view.backgroundColor = color
            }
            view.center = CGPoint(x: (aParentView?.w ?? UIScreen.main.bounds.width) / 2.0, y: (aParentView?.h ?? UIScreen.main.bounds.height) / 2.0)

            // Change toastview frame
            if positionType == .top {
                view.top = gapHeight
            }
            else if positionType == .bottom {
                view.bottom = (aParentView?.h ?? UIScreen.main.bounds.height) - gapHeight
            }

            if toasts.count == 0 {
                toasts.append(view)
                ToastView.nextToast(in: parentView)
            }
            else {
                toasts.append(view)
            }

            if UIAccessibility.isVoiceOverRunning {
                DispatchQueue.main.async {
                    UIAccessibility.post(notification: .screenChanged, argument: view)
                }
            }
        }
    }

    public static func hideAllToasts() {
        self.timer?.invalidate()
        toasts.forEach({ v in
            v.removeFromSuperview()
        })
        toasts.removeAll()
    }


    private func fadeToastOutDuration(_ duration: TimeInterval) {
        // Fade in parent view
        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0.0
        }, completion: {(_ finished: Bool) in
            let superView = self.superview
            self.removeFromSuperview()
            // Remove current view from array
            while let elementIndex = ToastView.toasts.firstIndex(of: self) { ToastView.toasts.remove(at: elementIndex) }

            if superView != nil {
                ToastView.nextToast(in: superView)
            }
            else {
                ToastView.nextToast()
            }

        })
    }

    func fadeToastOut() {
        // Fade in parent view
        fadeToastOutDuration(0.3)
    }

    public static func nextToast(in parentView: UIView? = nil) {
        gcd_main_after(0.001) {
            // 기존에도 keyWindow는 optional일 수 있었는데 !로 선언됐으므로 crash 위험이 있는 코드였음
            let window = keyWindow()
            let aParentView: UIView?
            if parentView == nil {
                aParentView = window
            }
            else {
                aParentView = parentView
            }
            if let view: ToastView = toasts.first {
                aParentView?.addSubview(view)
                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
                    view.alpha = 1.0
                }, completion: {(_ finished: Bool) in
                })
                if UIAccessibility.isVoiceOverRunning {
                    UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: view.textLabel)
                    self.timer = Timer.schedule(delay: 3, { timer in
                        timer?.invalidate()
                        view.fadeToastOut()
                    })
                }
                else {
                    self.timer = Timer.schedule(delay: kDuration, { timer in
                        timer?.invalidate()
                        view.fadeToastOut()
                    })
                }
            }
        }
    }

}

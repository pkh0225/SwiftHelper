//
//  ToastComponent.swift
//  ssg
//
//  Created by 박길호 on 2/17/25.
//  Copyright © 2025 emart. All rights reserved.
//


import UIKit

private let PositionGap: CGFloat = 80
private let TextLineOneSize: CGFloat = 17

public final class ToastView: UIView {
    public enum Rect: CGFloat, CaseIterable {
        case rectangel = 0
        case round = 8

        var title: String {
            switch self {
            case .rectangel:
                return "rectangel"
            case .round:
                return "round"
            }
        }
    }
    public enum Position: String, CaseIterable {
        case top
        case center
        case bottom
    }

    private lazy var bodyView: UIView = {
        UIView(frame: .zero).apply {
//            $0.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            self.addSubview($0)
        }
    }()
    private lazy var textLabel: UILabel = {
        UILabel(frame: .zero).apply {
//            $0.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            $0.text = self.text
            $0.numberOfLines = 0
            $0.textAlignment = self.textAlignment
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor.white
            $0.lineBreakMode = .byCharWrapping
            bodyView.addSubview($0)
        }
    }()
    private lazy var iconComponent: UIImageView = {
        self.textLabel.textAlignment = .left
        return UIImageView(frame: .zero).apply {
            $0.frame.size = CGSize(width: 24, height: 24)
//            $0.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            $0.contentMode = .scaleAspectFit
            $0.image = self.icon?.tintColor(self.iconColor)
            bodyView.addSubview($0)
        }
    }()

    @Atomic private static var toasts = [ToastView]()
    @Atomic private static var timer: Timer?

    public var text: String = ""
    public var textAlignment: NSTextAlignment = .center
    public var icon: UIImage?
    public var iconColor: UIColor = .white
    public var iconGap: CGFloat = 4
    public var iconAlignment: Position = .center
    public var position: Position = .center
    public var rect: Rect = Rect.round

//    deinit {
//        print("ToastComponent deinit")
//    }

    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
        self.backgroundColor = UIColor(white: 1, alpha: 0.8)
        self.isUserInteractionEnabled = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUI()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.updateUI()
    }

    private func updateUI() {
        guard let superview  else { return }
        self.layer.cornerRadius = self.rect.rawValue

        let toastWidth: CGFloat = min(superview.frame.size.width - 32, 430)
        self.frame.size.width = toastWidth
        if self.icon == nil {
            let labelWidth = toastWidth - 40
            self.textLabel.frame.size.width = labelWidth // 높이값 계산을 위해 고정
            self.textLabel.sizeToFit()
            self.textLabel.frame.size.width = labelWidth // sizeToFit 후 다시 width 늘려줘야 함

            self.bodyView.frame.origin = CGPoint(x: 20, y: 16)
            self.bodyView.frame.size = self.textLabel.frame.size
        }
        else {
            let labelMaxWidth = toastWidth - 40 - self.iconComponent.frame.size.width - self.iconGap
            self.textLabel.textAlignment = .left
            self.textLabel.frame.origin.x = self.iconComponent.frame.size.width + self.iconGap
            self.textLabel.sizeToFit() // 최대 width를 체크 하기 위서 제한을 두지 않고 체크를 위해 width를 0으로 먼저 두고 실행함
            self.textLabel.frame.size.width = min(labelMaxWidth, self.textLabel.frame.size.width) // 최대 사이즈 설정
            self.textLabel.sizeToFit() // width를 설정하고 다시 높이를 다시 계산하기 위해 다시 함

            self.bodyView.frame.origin = CGPoint(x: 20, y: 16)
            self.bodyView.frame.size.width = self.iconComponent.frame.size.width + self.iconGap + self.textLabel.frame.size.width
            self.bodyView.frame.size.height = max(self.iconComponent.frame.size.height, self.textLabel.frame.size.height)

            if self.textLabel.frame.size.height > TextLineOneSize {
                // 2줄 이상
                switch self.iconAlignment {
                case .top:
                    self.iconComponent.frame.y = self.textLabel.frame.y
                case .center:
                    self.iconComponent.centerYInSuperView()
                case .bottom:
                    self.iconComponent.frame.y = self.textLabel.maxY - self.iconComponent.frame.size.height
                }
            }
            else {
                // 한줄일때
                self.iconComponent.centerYInSuperView()
                self.textLabel.centerYInSuperView()
            }
        }

        self.frame.size.height = self.bodyView.frame.size.height + 32
        //        self.bodyView.centerInSuperView()
        self.bodyView.centerYInSuperView()

        self.setPosition()
    }

    private func setPosition() {
        guard let window = keyWindow() else { return }
        guard let superview  else { return }
        switch self.position {
        case .top:
            self.centerXInSuperView()
            self.frame.origin.y = window.safeAreaInsets.top + PositionGap
        case .center:
            self.centerInSuperView()
        case .bottom:
            self.centerXInSuperView()
            self.frame.origin.y = superview.height - window.safeAreaInsets.bottom - self.frame.size.height - PositionGap
        }
    }

    private func fadeIn() {
        self.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            if UIAccessibility.isVoiceOverRunning {
                UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: self.textLabel)
            }
            // 한줄인지 검사(1줄:1.5초 2줄이상:3초)
            let delay = self.textLabel.frame.size.height > TextLineOneSize ? 3 : 1.5
            Self.timer = Timer.schedule(delay: delay) { [weak self] timer in
                guard let self else { return }
                timer?.invalidate()
                Self.timer = nil
                self.fadeOut()
            }
        })
    }

    private func fadeOut() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
            while let elementIndex = Self.toasts.firstIndex(of: self) { Self.toasts.remove(at: elementIndex) }
        })
    }
}

// MARK: - show
extension ToastView {
    public func show() {
        guard self.text.isValid else { return }

        gcd_main_safe {
            if let toast = Self.toasts.first {
                toast.fadeOut()
                Self.toasts.removeFirst()
            }
            Self.toasts.append(self)
            Self.nextToast()
        }
    }

    public static func hideAllToasts() {
        Self.timer?.invalidate()
        Self.timer = nil
        Self.toasts.forEach { $0.removeFromSuperview() }
        Self.toasts.removeAll()
    }

    private static func nextToast() {
        guard let window = keyWindow() else { return }
        gcd_main_after(0.001) {
            guard let toastComponent = toasts.first  else { return }
            window.addSubview(toastComponent)
            toastComponent.fadeIn()
        }
    }
}


// MARK: - set function
extension ToastView {
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        self.textAlignment = value
        return self
    }

    public func icon(_ value: UIImage?) -> Self {
        self.icon = value
        return self
    }

    public func iconColor(_ value: UIColor) -> Self {
        self.iconColor = value
        return self
    }

    public func iconGap(_ value: CGFloat) -> Self {
        self.iconGap = value
        return self
    }

    public func iconAlignment(_ value: Position) -> Self {
        self.iconAlignment = value
        return self
    }

    public func position(_ value: Position) -> Self {
        self.position = value
        return self
    }

    public func rect(_ value: Rect) -> Self {
        self.rect = value
        return self
    }
}

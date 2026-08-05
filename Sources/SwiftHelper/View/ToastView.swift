import Foundation
import UIKit

/// Toast 메시지를 표시하는 뷰 클래스
@MainActor
public final class ToastView: UIView {
    // MARK: - Types

    /// Toast 위치 타입
    public enum PositionType {
        case top
        case center
        case bottom
    }

    // MARK: - Private Properties

    private static var activeToasts: [ToastView] = []
    private static var displayTask: Task<Void, Never>?

    private let textLabel: UILabel
    private let message: String
    private let displayDuration: TimeInterval
    private let position: PositionType
    private let offset: CGFloat
    private weak var parentView: UIView?
    private let replaceExisting: Bool

    // MARK: - Initialization

    public init(
        _ text: String,
        duration: TimeInterval = 1,
        position: PositionType = .bottom,
        backgroundColor: UIColor = UIColor(white: 0, alpha: 0.7),
        offset: CGFloat = 70,
        in parentView: UIView? = nil,
        replaceExisting: Bool = false
    ) {
        self.message = text
        self.displayDuration = duration
        self.position = position
        self.offset = offset
        self.parentView = parentView
        self.replaceExisting = replaceExisting
        self.textLabel = UILabel()

        super.init(frame: .zero)

        setupView(backgroundColor: backgroundColor)
        setupLabel(with: text)
        calculateSize(for: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupView(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 8
        isUserInteractionEnabled = false
        alpha = 0
    }

    private func setupLabel(with text: String) {
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 13)
        textLabel.textColor = .white
        textLabel.lineBreakMode = .byCharWrapping
        textLabel.backgroundColor = .clear

        addSubview(textLabel)
    }

    private func calculateSize(for text: String) {
        let screenHorizontalInset: CGFloat = 16
        let contentHorizontalInset: CGFloat = 16
        let contentVerticalInset: CGFloat = 12

        let maxToastWidth = UIScreen.main.bounds.width - screenHorizontalInset * 2
        let maxLabelWidth = maxToastWidth - contentHorizontalInset * 2
        let labelHeight = text.height(maxWidth: maxLabelWidth, font: textLabel.font)
        let measuredLabelWidth = text.width(maxHeight: labelHeight, font: textLabel.font)
        let labelWidth = min(ceil(measuredLabelWidth), maxLabelWidth)

        let toastWidth = min(labelWidth + contentHorizontalInset * 2, maxToastWidth)
        let toastHeight = labelHeight + contentVerticalInset * 2

        frame.size = CGSize(width: toastWidth, height: toastHeight)
        textLabel.frame = CGRect(
            x: contentHorizontalInset,
            y: contentVerticalInset,
            width: toastWidth - contentHorizontalInset * 2,
            height: labelHeight
        )
    }

    // MARK: - Public Methods

    /// 화면에 Toast를 노출한다.
    @discardableResult
    public func show() -> Self {
        guard !message.isEmpty else { return self }

        Task { @MainActor in
            if let lastToast = Self.activeToasts.last,
               lastToast.message == message {
                return
            }

            if replaceExisting {
                await Self.hideAll()
            }

            Self.activeToasts.append(self)

            if Self.activeToasts.count == 1 {
                await Self.displayNext()
            }

            if UIAccessibility.isVoiceOverRunning {
                UIAccessibility.post(notification: .screenChanged, argument: textLabel)
            }
        }

        return self
    }

    /// 모든 Toast 숨기기
    public static func hideAll() async {
        displayTask?.cancel()
        displayTask = nil

        for toast in activeToasts {
            toast.removeFromSuperview()
        }
        activeToasts.removeAll()
    }

    // MARK: - Private Methods

    private static func displayNext() async {
        guard let toast = activeToasts.first else { return }

        try? await Task.sleep(nanoseconds: 1_000_000)

        let targetView = toast.parentView ?? keyWindow()
        guard let targetView else { return }

        let viewWidth = targetView.bounds.width
        let viewHeight = targetView.bounds.height
        toast.center = CGPoint(x: viewWidth / 2, y: viewHeight / 2)

        switch toast.position {
        case .top:
            toast.frame.origin.y = toast.offset
        case .center:
            break
        case .bottom:
            toast.frame.origin.y = viewHeight - toast.frame.height - toast.offset
        }

        targetView.addSubview(toast)

        await UIView.animate(.easeIn(duration: 0.3)) {
            toast.alpha = 1.0
        }

        displayTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(toast.displayDuration * 1_000_000_000))

            guard !Task.isCancelled else { return }
            await toast.hide()
        }

        await displayTask?.value
    }

    private func hide() async {
        await UIView.animate(.easeOut(duration: 0.3)) {
            self.alpha = 0
        }

        removeFromSuperview()

        Self.activeToasts.removeAll { $0 === self }

        if Self.activeToasts.first != nil {
            await Self.displayNext()
        }
    }

    private static func keyWindow() -> UIView? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

// MARK: - UIView Animation Extension

@MainActor
extension UIView {
    enum ToastAnimationOptions {
        case easeIn(duration: TimeInterval)
        case easeOut(duration: TimeInterval)
        case linear(duration: TimeInterval)

        var duration: TimeInterval {
            switch self {
            case .easeIn(let duration),
                 .easeOut(let duration),
                 .linear(let duration):
                return duration
            }
        }

        var options: UIView.AnimationOptions {
            switch self {
            case .easeIn:
                return [.curveEaseIn, .allowUserInteraction]
            case .easeOut:
                return [.curveEaseOut, .allowUserInteraction]
            case .linear:
                return [.curveLinear, .allowUserInteraction]
            }
        }
    }

    static func animate(
        _ animation: ToastAnimationOptions,
        animations: @escaping () -> Void
    ) async {
        await withCheckedContinuation { continuation in
            UIView.animate(
                withDuration: animation.duration,
                delay: 0,
                options: animation.options,
                animations: animations
            ) { _ in
                continuation.resume()
            }
        }
    }
}

//
//  Common.swift
//  SwiftHelper
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 11/25/24.
//

import UIKit

@MainActor
public func makeDebugTextView(value: String) {
    guard let window = KeyWindow() else { return }
    let bgView: UIView = UIView(frame: window.bounds)
    bgView.backgroundColor = .black.withAlphaComponent(0.3)
    window.addSubview(bgView)

    let view: UIView = UIView(frame: CGRect(x: 10,
                                            y: window.safeAreaInsets.top + 10,
                                            w: UIScreen.main.bounds.width - 20,
                                            h: UIScreen.main.bounds.height - 20 - window.safeAreaInsets.top - window.safeAreaInsets.bottom))
    view.borderColor = .gray
    view.borderWidth = 1
    view.clipsToBounds = true
    window.addSubview(view)

    let textView: UITextView = UITextView(frame: CGRect(x: 0, y: 0, w: view.w, h: view.h - 45))
    textView.backgroundColor = .white
    textView.isEditable = false
    textView.font = UIFont.systemFont(ofSize: 16)
    textView.text = value
    textView.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
    view.addSubview(textView)

    let btn: UIButton = UIButton(frame: CGRect(x: 0, y: textView.h, w: textView.w, h: 45))
    btn.backgroundColor = .green
    btn.setTitle("닫기", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    view.addSubview(btn)
    btn.addAction(for: .touchUpInside) { [weak view, weak bgView] _ in
        guard let view, let bgView else { return }
        UIView.animate(withDuration: 0.2) {
            bgView.alpha = 0
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            view.removeFromSuperview()
            bgView.removeFromSuperview()
        }
    }

    bgView.alpha = 0.5
    view.alpha = 0.1
    view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    UIView.animate(withDuration: 0.2) {
        bgView.alpha = 1
        view.alpha = 1
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
}


//
//  ViewController.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit

typealias TypePushController = UIViewController & PushProtocol

class TestViewController: UITableViewController, PushProtocol {
    static var storyboardName: String = "Main"

    var vcList = [(title: String, vc: TypePushController.Type)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self)

        setData()
    }

    func setData() {
        vcList.append(("AutoLayout", AutoLayoutController.self))
        vcList.append(("Closure Queue", ClosureQueueController.self))
        vcList.append(("Memory", MemoryViewController.self))
        vcList.append(("Scope", SccopeViewController.self))
    }
}

// MARK: - UITableView Delegate
extension TestViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = vcList[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcType = vcList[indexPath.row].vc
        vcType.pushViewController()
    }
}

func makeDebugTextView(value: String) {
    gcd_main_safe {
        guard let window = KeyWindow() else { return }
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
        btn.addAction(for: .touchUpInside) { [weak view] _ in
            guard let view else { return }
            UIView.animate(withDuration: 0.2) {
                view.alpha = 0
                view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                view.removeFromSuperview()
            }
        }

        view.alpha = 0.1
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

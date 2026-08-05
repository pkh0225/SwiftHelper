//
//  ViewController.swift
//  Test
//
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit
import SwiftHelper

class TestViewController: UITableViewController, RouterProtocol {
    static var storyboardName: String = "Main"

    var vcList = [(title: String, vc: RouterProtocol.Type)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self)

        setData()
    }

    func setData() {
        vcList.append(("Closure Queue", ClosureQueueController.self))
        vcList.append(("Scope", SccopeViewController.self))
        vcList.append(("ToastView", ToastViewController.self))
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

//
//  ToastViewController.swift
//  TestSwiftHelper
//
//  Copyright © 2026 pkh. All rights reserved.
//

import UIKit
import SwiftHelper

final class ToastViewController: UITableViewController, RouterProtocol {
    static var storyboardName: String = ""

    private enum TestCase: Int, CaseIterable {
        case basic
        case longText
        case duration2s
        case top
        case center
        case bottom
        case customColor
        case customOffset
        case queueMultiple
        case replaceExisting
        case emptyText
        case hideAll

        var title: String {
            switch self {
            case .basic: return "기본 — ToastView(\"테스트\").show()"
            case .longText: return "긴 텍스트"
            case .duration2s: return "duration: 2초"
            case .top: return "position: .top"
            case .center: return "position: .center"
            case .bottom: return "position: .bottom"
            case .customColor: return "backgroundColor: 커스텀"
            case .customOffset: return "offset: 120"
            case .queueMultiple: return "연속 3개 큐잉"
            case .replaceExisting: return "replaceExisting: true"
            case .emptyText: return "빈 문자열 (표시 안 됨)"
            case .hideAll: return "hideAll() — 전부 숨기기"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToastView"
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self)
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TestCase.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        let testCase = TestCase.allCases[indexPath.row]
        cell.textLabel?.text = testCase.title
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        run(TestCase.allCases[indexPath.row])
    }

    private func run(_ testCase: TestCase) {
        switch testCase {
        case .basic:
            ToastView("테스트").show()

        case .longText:
            ToastView("긴 메시지가 여러 줄로 잘 보이는지 확인합니다. SwiftHelper ToastView 테스트용 긴 텍스트입니다.").show()

        case .duration2s:
            ToastView("2초 동안 표시됩니다", duration: 2).show()

        case .top:
            ToastView("상단 Toast", position: .top).show()

        case .center:
            ToastView("중앙 Toast", position: .center).show()

        case .bottom:
            ToastView("하단 Toast", position: .bottom).show()

        case .customColor:
            ToastView("커스텀 배경색", backgroundColor: UIColor(r: 30, g: 144, b: 255, a: 0.9)).show()

        case .customOffset:
            ToastView("offset 120", offset: 120).show()

        case .queueMultiple:
            ToastView("큐 1/3").show()
            ToastView("큐 2/3").show()
            ToastView("큐 3/3").show()

        case .replaceExisting:
            ToastView("먼저 쌓이는 Toast", duration: 3).show()
            ToastView("replaceExisting — 이전 것 제거", replaceExisting: true).show()

        case .emptyText:
            ToastView("").show()

        case .hideAll:
            ToastView("곧 사라질 Toast A", duration: 5).show()
            ToastView("곧 사라질 Toast B", duration: 5).show()
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000)
                await ToastView.hideAll()
            }
        }
    }
}

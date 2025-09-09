//
//  LoggerTestViewController.swift
//  TestSwiftHelper
//
//  Created by 박길호 on 9/9/25.
//  Copyright © 2025 pkh. All rights reserved.
//

import UIKit
import SwiftHelper

class LoggerTestViewController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"

    private let logger = Logger.ui
    private let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("일반 print")
        logDebug("Test 전역 logDebug")

        logger.debug("ViewController viewDidLoad 시작")
        setupUI()
        logger.info("ViewController 초기화 완료")
    }

    private func setupUI() {
        logger.debug("UI 설정 시작")

        // UI 설정 코드...

        logger.notice("UI 설정이 완료되었습니다")
    }

    @IBAction func fetchButtonTapped(_ sender: UIButton) {
        logger.info("사용자가 데이터 가져오기 버튼을 눌렀습니다")
        networkManager.fetchData()
    }

    private func handleCriticalError() {
        let error = NSError(domain: "UIError",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "UI 렌더링 실패"])
        logger.fault("UI에서 치명적인 오류 발생", error: error)
    }
}

// MARK: - 사용 예시
class NetworkManager {
    private let logger = Logger.network

    func fetchData() {
        logger.debug("네트워크 요청 시작")

        // 네트워크 요청 시뮬레이션
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }

            let success = Bool.random()

            if success {
                self.logger.info("데이터 가져오기 성공")
                self.logger.notice("새로운 데이터가 도착했습니다")
            } else {
                let error = NSError(domain: "NetworkError",
                                  code: 500,
                                  userInfo: [NSLocalizedDescriptionKey: "서버 연결 실패"])
                self.logger.error("데이터 가져오기 실패", error: error)
            }
        }
    }

    func criticalNetworkFailure() {
        let criticalError = NSError(domain: "CriticalNetworkError",
                                  code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "네트워크 완전 실패"])
        logger.fault("치명적인 네트워크 오류 발생", error: criticalError)
    }
}

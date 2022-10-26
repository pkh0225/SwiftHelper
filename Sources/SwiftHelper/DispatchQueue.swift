//
//  DispatchQueue.swift
//  WiggleSDK
//
//  Created by  bdb on 2018. 4. 26..
//  Copyright © 2018년 mykim. All rights reserved.
//

import UIKit

/**
 예제
 */
// DispatchQueue.once(token: TopDetailCollectionViewCell.className) {
//    if let cell : TopDetailCollectionViewCell = Bundle.loadNib(TopDetailCollectionViewCell.className)  {
//        cell.configure(self.dataItem.item!)
//        cell.layoutIfNeeded()
//        let cellSize = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        print(cellSize.height)
//    }
// }

// 앱 실행중 한번임
public extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }

    /**
        같은 함수가 아닌 여러곳에서 중복실행을 방지 하고 싶을때는 아래 함수를 사용 token을 꼭 만들어서 사용해야 함
     
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }
}

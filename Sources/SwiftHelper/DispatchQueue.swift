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
//DispatchQueue.once(token: TopDetailCollectionViewCell.className) {
//    if let cell : TopDetailCollectionViewCell = Bundle.loadNib(TopDetailCollectionViewCell.className)  {
//        cell.configure(self.dataItem.item!)
//        cell.layoutIfNeeded()
//        let cellSize = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        print(cellSize.height)
//    }
//}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

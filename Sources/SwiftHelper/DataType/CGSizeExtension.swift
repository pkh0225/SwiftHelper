//
//  CGSizeExtension.swift
//  WiggleSDK
//
//  Created by yoseokkim on 2021/11/24.
//  Copyright © 2021 mykim. All rights reserved.
//

import UIKit

extension CGSize {
    // 아래 4개의 정렬 클로저는 Array의 여러 CGSize가 있을 때 필요에 따라 오름차순/내림차순하시기 편하라고 만들어놓았습니다. by. iSunSoo.
    public static var widthAscending: (CGSize, CGSize) -> Bool {
        return {
            (lhs, rhs) in
            return lhs.width < rhs.width
        }
    }
    public static var widthDesscending: (CGSize, CGSize) -> Bool {
        return {
            (lhs, rhs) in
            return lhs.width > rhs.width
        }
    }
    public static var heightAscending: (CGSize, CGSize) -> Bool {
        return {
            (lhs, rhs) in
            return lhs.height < rhs.height
        }
    }
    public static var heightDesscending: (CGSize, CGSize) -> Bool {
        return {
            (lhs, rhs) in
            return lhs.height > rhs.height
        }
    }
    /// 비율에 맞춰 최소사이즈 보다 크게 키우기.
    public func toSizeBiggerThanMimimum(_ minimumSize: CGSize) -> CGSize {
        let oldWidth: CGFloat = self.width
        let oldHeight: CGFloat = self.height
        let newWidth: CGFloat = minimumSize.width
        let newHeight: CGFloat = minimumSize.height

        // 최소 사이즈보다 작으면 실행
        guard oldWidth < newWidth || oldHeight < newHeight else { return self }

        let widthScaleFactor = newWidth / oldWidth
        let heightScaleFactor = newHeight / oldHeight

        if widthScaleFactor > heightScaleFactor {
            return CGSize(width: newWidth, height: oldHeight * widthScaleFactor)
        }
        else {
            return CGSize(width: oldWidth * heightScaleFactor, height: newHeight)
        }
    }
}

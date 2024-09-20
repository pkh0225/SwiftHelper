//
//  WeakWrapper.swift
//  TestSwiftHelper
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import Foundation

/// 약한 참조를 배열이나 딕셔너리등에서 관리하기 위한 래퍼 클래스
///     class AAA {
///         var bbb: BBB?
///
///         deinit {
///             print("deinit AAA")
///         }
///     }
///     class BBB {
///         var array = [WeakWrapper<AAA>]()
///         var dic = [String: WeakWrapper<AAA>]()
///
///         deinit {
///             print("deinit BBB")
///         }
///      }
///
///      let a = AAA()
///      let b = BBB()   // BBB를 강하게 참조할 변수
///
///     a.bbb = b  // b를 a의 bbb에 설정
///     b.array.append(WeakWrapper(value: a))  // bbb.array에 약한 참조 추가
///     b.dic["111"] = WeakWrapper(value: a)
///
class WeakWrapper<T: AnyObject> {
    weak var value: T?

    init(value: T) {
        self.value = value
    }
}
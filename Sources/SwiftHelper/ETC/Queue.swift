//
//  LinkedList.swift
//  SwiftHelper
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 11/26/24.
//

import Foundation

// 스레드 안전한 리스트 기반 큐 구현
public final class Queue<T> {
    // 노드 클래스 정의
    public class Node<T> {
        public var value: T
        public var next: Node?

        public init(value: T) {
            self.value = value
        }
    }

    private var head: Node<T>?
    private var tail: Node<T>?
    private let lock = NSLock()

    // 큐가 비어있는지 확인
    public var isEmpty: Bool {
        lock.lock()
        let empty = head == nil
        lock.unlock()
        return empty
    }

    // 큐에 요소를 추가
    public func enqueue(_ value: T) {
        lock.lock()
        let newNode = Node(value: value)
        if tail == nil { // 큐가 비어있다면
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            tail = newNode
        }
        lock.unlock()
    }

    // 큐에서 요소를 제거하고 반환
    public func dequeue() -> T? {
        lock.lock()
        defer { lock.unlock() }
        guard let headNode = head else {
            return nil // 큐가 비어있음
        }
        head = headNode.next
        if head == nil { // 마지막 요소를 제거한 경우 tail도 nil로 설정
            tail = nil
        }
        return headNode.value
    }

    // 큐의 첫 번째 요소를 반환 (제거하지 않음)
    public func peek() -> T? {
        lock.lock()
        let value = head?.value
        lock.unlock()
        return value
    }
}


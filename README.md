# SwiftHelper

iOS에서 자주 쓰는 Extension / Helper 모음입니다.

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/badge/platform-iOS%2015+-lightgrey.svg)](Package.swift)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15+

## Installation

### Swift Package Manager

Xcode → **File → Add Package Dependencies…** 에서 아래 URL을 추가합니다.

```text
https://github.com/pkh0225/SwiftHelper.git
```

또는 `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pkh0225/SwiftHelper.git", from: "1.0.0")
]
```

## 주요 기능

### ToastView

```swift
ToastView("테스트").show()
ToastView("상단 토스트", duration: 2, position: .top).show()
ToastView("교체", replaceExisting: true).show()
```

### ActionQueue

순차 실행이 필요한 클로저 큐입니다.

```swift
ActionQueue.shared.addAction { _ in
    // work
}
ActionQueue.shared.nextRun()
```

### Scope Functions

```swift
let person = Person().apply {
    $0.name = "park"
    $0.age = 10
}

person.run {
    print($0.name)
}
```

### UIAlertController

```swift
UIAlertController.alert(title: "알림", message: "완료되었습니다.")

let index = await UIAlertController.alert(
    title: "확인",
    message: nil,
    cancelButtonTitle: "취소",
    otherButtonTitles: "확인"
)
```

### RouterProtocol

스토리보드/코드 기반 ViewController push helper입니다.

```swift
MyViewController.pushViewController()
```

### 기타

- `UIScrollView` header / footer / sticky header
- `UIView` frame helpers, corner radius, debug mask
- `String` / `Array` / `Date` 등 Foundation·UIKit Extension
- `@Atomic`, `@UserDefaultWrapper` Property Wrapper
- `os.Logger` 기반 카테고리 로거

## Example

`Example-iOS/TestSwiftHelper` 샘플 앱에서 기능을 확인할 수 있습니다.

| 화면 | 내용 |
|------|------|
| Closure Queue | `ActionQueue` 테스트 |
| Scope | Scope function 테스트 |
| ToastView | Toast 위치/duration/큐잉 등 |

## Structure

```text
Sources/SwiftHelper/
├── Data+Extention/   # String, Array, Date …
├── UI+Extention/     # UIView, UIScrollView, UIAlert …
├── View/             # ToastView, DebugMaskView
├── Scope/            # apply / run / takeIf
├── Wrapper/          # Atomic, UserDefaultWrapper
├── Dispatc/          # gcd helpers, ActionQueue
├── Define/           # Closure typealias
├── Json/             # JSONSerializable
└── ETC/              # Logger, RouterProtocol, Queue
```

## License

[MIT](LICENSE)

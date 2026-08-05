//
//  UIDeviceExtensions.swift
//  EZSwiftExtensions
//
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import CoreTelephony
import SystemConfiguration
import DeviceGuru

@MainActor
extension UIDevice {
    /// EZSwiftExtensions
    public static func idForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    /// EZSwiftExtensions - Operating system name
    public static func systemName() -> String {
        return UIDevice.current.systemName
    }

    /// EZSwiftExtensions - Operating system version
    public static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// EZSwiftExtensions - Operating system version
    public static func systemFloatVersion() -> Float {
        return systemVersion().toFloat()
    }

    /// EZSwiftExtensions
    public static func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// EZSwiftExtensions
    public static func deviceServiceName() -> String {
        let deviceGuru = DeviceGuruImplementation()
        let deviceName = try? deviceGuru.hardwareDescription()
#if targetEnvironment(simulator)
    // 시뮬레이터에서만 컴파일되는 코드
        return (deviceName ?? "") + " - simulator"
#else
    // 실제 기기에서만 컴파일되는 코드
        return deviceName ?? ""
#endif
    }

    /// EZSwiftExtensions
    public static func deviceModel() -> String {
        return DeviceGuruImplementation().hardwareString
    }

    public static func networkInfo() -> CTTelephonyNetworkInfo {
        let networkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        return networkInfo
    }

    public static func deviceOsVersion() -> String {
        return UIDevice.current.systemVersion
    }

    public static func networkType() -> String {
        if isConnectedViaWiFi() {
            return "WiFi"
        }

        let networkInfo = CTTelephonyNetworkInfo()

        guard let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology?.values.first else {
            return ""
        }

        switch radioAccessTechnology {
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
            return "2G"
        case CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD, CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA:
            return "3G"
        case CTRadioAccessTechnologyLTE:
            return "4G"
        case CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR:
            return "5G"
        default:
            return ""
        }
    }

    private static func isConnectedViaWiFi() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let isCellular = flags.contains(.isWWAN)
        return isReachable && !isCellular
    }

}

#endif

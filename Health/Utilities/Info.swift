//
//  Info.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import CoreTelephony

public struct Info {
    
    public static let unknown = "Unknown"
    
}

// MARK: Device Info

extension Info {
    
    public struct Device {
        
        public static var model: String {
            return UIDevice.current.model
        }
        
        public static var localizedModel: String {
            return UIDevice.current.localizedModel
        }
        
        public static var name: String {
            return UIDevice.current.name
        }
        
        public static var orientation: UIDeviceOrientation {
            return UIDevice.current.orientation
        }
        
        public static var userInterfaceIdiom: UIUserInterfaceIdiom {
            return UIDevice.current.userInterfaceIdiom
        }
        
        public static var batteryState: UIDeviceBatteryState {
            return UIDevice.current.batteryState
        }
        
        public static var batteryLevel: Float {
            return UIDevice.current.batteryLevel
        }
        
        public static var brightness: Float {
            return Float(UIScreen.main.brightness)
        }
        
        public static var isBatteryMonitoringEnabled: Bool {
            return UIDevice.current.isBatteryMonitoringEnabled
        }
        
        public static var isProximityMonitoringEnabled: Bool {
            return UIDevice.current.isProximityMonitoringEnabled
        }
        
        public static var isMultitaskingSupported: Bool {
            return UIDevice.current.isMultitaskingSupported
        }
        
        public static var proximityState: Bool {
            return UIDevice.current.proximityState
        }
        
        public static var isGeneratingDeviceOrientationNotifications: Bool {
            return UIDevice.current.isGeneratingDeviceOrientationNotifications
        }
        
        public static var machine: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let machine = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            return machine
        }
        
        public static func isPortrait(_ orientation: UIDeviceOrientation) -> Bool {
            return UIDeviceOrientationIsPortrait(orientation)
        }
        
        public static func isLandscape(_ orientation: UIDeviceOrientation) -> Bool {
            return UIDeviceOrientationIsLandscape(orientation)
        }
        
    }
}

// MARK: System Info

extension Info {
    
    public struct System {
        
        public static var name: String {
            return UIDevice.current.systemName
        }
        
        public static var version: String {
            return UIDevice.current.systemVersion
        }
        
        public static var uptime: TimeInterval {
            let processInfo = ProcessInfo()
            return processInfo.systemUptime
        }
        
    }
    
}

// MARK: Carrier Info

extension Info {
    
    public struct Carrier {
        
        static var carrier: CTCarrier? {
            return CTTelephonyNetworkInfo().subscriberCellularProvider
        }
        
        public static var name: String {
            return Carrier.carrier?.carrierName ?? unknown
        }
        
        public static var mobileCountryCode: String {
            return Carrier.carrier?.mobileCountryCode ?? unknown
        }
        
        public static var mobileNetworkCode: String {
            return Carrier.carrier?.mobileNetworkCode ?? unknown
        }
        
        public static var isoCountryCode: String {
            return Carrier.carrier?.isoCountryCode ?? unknown
        }
        
        public static var allowsVOIP: Bool {
            return Carrier.carrier?.allowsVOIP ?? false
        }
        
        public static var currentRadioAccessTechnology: String {
            return CTTelephonyNetworkInfo().currentRadioAccessTechnology ?? unknown
        }
        
    }
    
}

// MARK: Application Info

extension Info {
    
    public struct Application {
        
        public static var bundleIdentifier: String {
            return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? unknown
        }
        
        public static var name: String {
            return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? unknown
        }
        
        public static var displayName: String {
            return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? unknown
        }
        
        public static var version: String {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? unknown
        }
        
        public static var build: String {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? unknown
        }
        
        public static var identifierForVendor: UUID? {
            return UIDevice.current.identifierForVendor
        }
        
    }
    
}

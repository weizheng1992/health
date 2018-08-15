//
//  Preferences.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import Foundation

public class PreferencesKey {}

public final class Preferences {
    
    /// Represents a `Key` with an associated generic value type conforming to the
    /// `Codable` protocol.
    ///
    /// static let someKey = Key<ValueType>("someKey")
    public final class Key<ValueType: Codable>: PreferencesKey {
        fileprivate let key: String
        
        public init(_ key: String) {
            self.key = key
        }
    }
    
    // MARK: Properties
    
    private var userDefaults: UserDefaults
    
    // MARK: Initialization
    
    /// An instance of `Preferences` with the specified `UserDefaults` instance.
    ///
    /// - Parameter userDefaults: The UserDefaults.
    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: Public Methods
    
    /// Delete the value associated with the specified key, if any.
    ///
    /// - Parameter key: The key.
    public func clear<ValueType>(_ key: Key<ValueType>) {
        self.userDefaults.set(nil, forKey: key.key)
        self.userDefaults.synchronize()
        
        NotificationCenter.default.post(
            name: Notification.Name.Preferences.DidChanged,
            object: nil,
            userInfo: [Notification.Preferences.Key: key.key]
        )
    }
    
    /// Checks if there is a value associated with the specified key.
    ///
    /// - Parameter key: The key to look for.
    /// - Returns: A boolean value indicating if a value exists for the specified key.
    public func has<ValueType>(_ key: Key<ValueType>) -> Bool {
        return userDefaults.value(forKey: key.key) != nil
    }
    
    /// Returns the value associated with the specified key.
    ///
    /// - Parameter key: The key.
    /// - Returns: A `ValueType` or nil if the key was not found.
    public func get<ValueType>(for key: Key<ValueType>) -> ValueType? {
        if isSwiftCodableType(type: ValueType.self) {
            return self.userDefaults.value(forKey: key.key) as? ValueType
        }
        
        guard let data = self.userDefaults.data(forKey: key.key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
        
        return nil
    }
    
    /// Sets a value associated with the specified key.
    ///
    /// - Parameters:
    ///   - some: The value to set.
    ///   - key: The associated `Key<ValueType>`.
    public func set<ValueType>(_ value: ValueType?, for key: Key<ValueType>) {
        guard let newValue = value else {
            clear(key)
            return
        }
        
        if isSwiftCodableType(type: ValueType.self) {
            self.userDefaults.set(newValue, forKey: key.key)
            self.userDefaults.synchronize()
            
            NotificationCenter.default.post(
                name: Notification.Name.Preferences.DidChanged,
                object: nil,
                userInfo: [Notification.Preferences.Key: key.key]
            )
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(newValue)
            self.userDefaults.set(encoded, forKey: key.key)
            self.userDefaults.synchronize()
            
            NotificationCenter.default.post(
                name: Notification.Name.Preferences.DidChanged,
                object: nil,
                userInfo: [Notification.Preferences.Key: key.key]
            )
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    // MARK: Private Methods
    
    /// Checks if a given type is primitive.
    ///
    /// - Parameter type: The type.
    /// - Returns: A boolean value indicating if the type is primitive.
    private func isSwiftCodableType<ValueType>(type: ValueType.Type) -> Bool {
        switch type {
        case is String.Type, is Bool.Type, is Int.Type, is Float.Type, is Double.Type, is Date.Type:
            return true
        default:
            return false
        }
    }
    
}

// MARK: -

extension Notification.Name {
    
    public struct Preferences {
        public static let DidChanged = Notification.Name(rawValue: "cn.jkinvest.health.notification.name.preferences.didChanged")
    }
}

// MARK: -

extension Notification {
    
    public struct Preferences {
        public static let Key = "cn.jkinvest.health.notification.preferences.key"
    }
}

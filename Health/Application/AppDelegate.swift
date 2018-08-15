//
//  AppDelegate.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
final class AppDelegate: UIResponder {
    
    // MARK: Properties
    
    var window: UIWindow?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Preferences().set(Info.Application.bundleIdentifier, for: PreferencesKey.version)
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        let tracker = BaiduMobStat.default()
        tracker?.enableDebugOn = true
        tracker?.start(withAppId: "e231e63fdc")
        
        JMessage.setLogOFF()
//        JMessage.setDebugMode()
//        JMessage.add(self, with: nil)
        
        JMessage.setupJMessage(
            launchOptions,
            appKey: JMessageAppKey,
            channel: "",
            apsForProduction: false,
            category: nil,
            messageRoaming: false
        )
        
        JMessage.register(
            forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue,
            categories: nil
        )
        
//        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = .main
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .main
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        UICollectionView.appearance().backgroundColor = .white
        
        window = UIWindow()
        
//        if let _ = App.shared.user {
//            window?.rootViewController = TabBarController()
//        } else {
//            window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
//        }
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
            if let id = self.backgroundTaskIdentifier {
                UIApplication.shared.endBackgroundTask(id)
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        JMessage.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if application.applicationState == .active {
            
        }
    }
    
}

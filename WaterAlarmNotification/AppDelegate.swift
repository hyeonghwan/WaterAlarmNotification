//
//  AppDelegate.swift
//  WaterAlarmNotification
//
//  Created by 박형환 on 2022/03/14.
//

import UIKit
import UserNotifications

 @main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var notification: UNUserNotificationCenter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { granted , error in
            if let err = error {
                print(err)
            }
            
        })
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
  
}

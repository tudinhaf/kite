//
//  AppDelegate.swift
//  kite
//
//  Created by Tú Đình on 4/2/20.
//  Copyright © 2020 Tú Đình. All rights reserved.
//

import UIKit
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {
    
    var window: UIWindow? // Support for iOS < 13
    
    
    @objc func sendLaunch(app:Any) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "2NWZKFmoUhRs8YssYpaZDd"
        AppsFlyerTracker.shared().appleAppID = "2614901321"
        AppsFlyerTracker.shared().delegate = self
        /* Set isDebug to true to see AppsFlyer debug logs */
        AppsFlyerTracker.shared().isDebug = true
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(sendLaunch),
        // For Swift version < 4.2 replace name argument with the commented out code
        name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
        object: nil)
        return true
    }
    
    
    // Deeplinking
    
    // Open URI-scheme for iOS 9 and above
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Open URI-scheme for iOS 9 and above: \(url.absoluteString)")

        AppsFlyerTracker.shared().handleOpen(url, options: options)
        
        return true
    }
    
    // Open URI-scheme for iOS 8 and below
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Open URI-scheme for iOS 8 and below: \(url.absoluteString)")
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        

      return true
    }
    
    // Open Univerasal Links
    // For Swift version < 4.2 replace function signature with the commented out code
    // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
    
    // MARK: AppsFlyerTrackerDelegate implementation
    
    //Handle Conversion Data (Deferred Deep Link)
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        print("\(data)")
        if let status = data["af_status"] as? String{
            if(status == "Non-organic"){
                if let sourceID = data["media_source"] , let campaign = data["campaign"]{
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = data["is_first_launch"] , let launch_code = is_first_launch as? Int {
                if(launch_code == 1){
                    print("First Launch")
                } else {
                    print("Not First Launch")
                }
            }
        }
    }
    func onConversionDataFail(_ error: Error) {
       print("\(error)")
    }
    
    //Handle Direct Deep Link
   func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print("\(error)")
    }
    
    // support for scene delegate
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

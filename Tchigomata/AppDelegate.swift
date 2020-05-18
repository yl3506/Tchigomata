//
//  AppDelegate.swift
//  Tchigomata
//
//  Created by Yichen on 4/17/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // set stay focused status
        TestTimerViewController.didExit = true
        OneViewController.didExit = true
        SecondViewController.didExit = true
        ThirdViewController.didExit = true
        TimeViewController.didExit = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // set stay focused status
        OneViewController.didExit = false
        OneViewController.screenOff = false
        TestTimerViewController.didExit = false
        TestTimerViewController.screenOff = false
        SecondViewController.didExit = false
        SecondViewController.screenOff = false
        ThirdViewController.didExit = false
        ThirdViewController.screenOff = false
        TimeViewController.didExit = false
        TimeViewController.screenOff = false
    }


}


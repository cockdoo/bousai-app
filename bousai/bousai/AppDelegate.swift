//
//  AppDelegate.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/13.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        var pageControl = UIPageControl.appearance()
//        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
//        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
//        pageControl.backgroundColor = UIColor.whiteColor()
        
        //GoogleMap
        GMSServices.provideAPIKey("AIzaSyDBKpJtkMSGU8cNdKQUziXpOOg8wN5TXKI")
        
        //notification
//        UIApplication.sharedApplication().cancelAllLocalNotifications();
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        //background fetchの登録
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        //UserDefaultのデフォルト設定
        ud = NSUserDefaults.standardUserDefaults()
        let dic = ["firstLaunch": true]
        ud.registerDefaults(dic)
        
        let dic2 = ["chiriinMap": false]
        ud.registerDefaults(dic2)
        
        let dic3 = ["nonData": true]
        ud.registerDefaults(dic3)
        
        var isFirstLaunch: Bool
        
        //初回起動かどうかの判定
        if ud.boolForKey("firstLaunch") {
            print("初回起動")
            isFirstLaunch = true
            ud.setBool(false, forKey: "firstLaunch")
        }else {
            isFirstLaunch = false
        }
        
        let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
        var viewController:UIViewController
        
        //表示するビューを指定
        if isFirstLaunch {
            viewController = storyboard.instantiateViewControllerWithIdentifier("Walkthrough") 
        } else {
            viewController = storyboard.instantiateViewControllerWithIdentifier("TopView") 
        }
        
        window?.rootViewController = viewController
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("background fetch!")
        if (lManager != nil) {
            lManager.settingLocationManager()
            lManager.locationManager.startUpdatingLocation()
        }
        
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("notification"), userInfo: nil, repeats: false)
    }
    
    func notification() {
        if (lManager.lat != nil && lManager.lon != nil) {
            var message = "緯度:\(lManager.lat) 経度\(lManager.lon)"
            dbManager.insertLocationData(lManager.lat, lon: lManager.lon)
            
//            var notification = UILocalNotification()
//            notification.fireDate = NSDate()
//            notification.timeZone = NSTimeZone.defaultTimeZone()
//            notification.alertBody = message
//            notification.alertAction = "OK"
//            notification.soundName = UILocalNotificationDefaultSoundName
//            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }else {
//            var notification = UILocalNotification()
//            notification.fireDate = NSDate()
//            notification.timeZone = NSTimeZone.defaultTimeZone()
//            notification.alertBody = "取得できなかった"
//            notification.alertAction = "OK"
//            notification.soundName = UILocalNotificationDefaultSoundName
//            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
        
        lManager.locationManager.stopUpdatingLocation()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


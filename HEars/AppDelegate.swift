//
//  AppDelegate.swift
//  HEars
//
//  Created by yantommy on 16/7/17.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import AVFoundation

//#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")
//#define NotificationChange CFSTR("com.apple.springboard.lockstate")
//#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    
    var isFirstLaunch = true
    
    /* 不允许监听锁屏状态了
    var isLocked: Bool {
    
        
        var state = uint_fast64_t()
        var token = Int32()
        
        notify_register_check("com.apple.iokit.hid.displayStatus", &token)
        //notify_register_check("com.apple.iokit.hid.lockState", &token)
        
        notify_get_state(token, &state)
        
        notify_cancel(token)
        
        print("suoping:\(state)")
        
        //判断状态（值为0或者1）
        if state == 0 {
            //锁屏
            print("现在的状态为锁屏状态")
            return true
        }else{
            print("现在的状态为没有锁屏状态")
            return false
        }
        
        return true

    }
    */
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //默认主题
        window?.tintColor = AppManager.currentTheme.themeColor
        
        
        if Noise.enableFusionWithMusic {
            //后台播放
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }else{
            
            //后台播放
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
            }catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let error as NSError {
            
            print(error.localizedDescription)
        }
        

        //远程控制
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        
        

        
        return true

    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        //用户点击不允许
        if notificationSettings.types == UIUserNotificationType() {
        
            print("没有获取通知权限")
            
            let settingUrl = URL(string: UIApplicationOpenSettingsURLString)!
            if UIApplication.shared.canOpenURL(settingUrl)
            {
                UIApplication.shared.openURL(settingUrl)
            }
        
        //用户点击允许
        }else{
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateIntroPerrsionState"), object: nil)
        }
        

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        //在切换后台时 保证不会因为设置了不能与其他App混音，而导致白噪声的关闭
        
        User.setUserDefaultValue(kUserEnableFusionWithMusic, value: true as AnyObject)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let error as NSError {
            
            print(error.localizedDescription)
        }
        
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    

    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
}


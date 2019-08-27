//
//  Pomodoro.swift
//  HEars
//
//  Created by yantommy on 16/7/26.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import AudioToolbox

enum PomodoroState {
    
    case focus
    case `break`
    case longBreak
}

class Pomodoro: NSObject {

    //控制重新开始计时
    static var isfocusing = false
    
    //控制暂停与继续
    static var isPaused = false
    
    //控制取消
    
    static var isGiveUp = false
    
    static var countToLongBreakFrequency = 0
    static var currentState = PomodoroState.focus
    
    //专注时间(??后面设置默认值)
    static var focusDuration:Int {
    
        return User.getUserDefaultValue(kUserFocusDuration) as? Int ?? 25
    }
    
    //休息模式
    static var enableBreak: Bool {
    
        return User.getUserDefaultValue(kUserEnableBreak) as? Bool ?? true
    }
    
    //休息时间
    static var breakDuration: Int {
    
        return User.getUserDefaultValue(kUserBreakDuration) as? Int ?? 5
    }
    
    //开启长休息
    static var enableLongBreak: Bool {
        
        return User.getUserDefaultValue(kUserEnableLongBreak) as? Bool ?? true
    }
    
    //长休息频率
    static var longBreakFrequency: Int {
    
        return User.getUserDefaultValue(kUserLongBreakFrequency) as? Int ?? 4

    }
    //长休息时间
    static var longBreakDuration: Int {
    
        return User.getUserDefaultValue(kUserLongBreakDuration) as? Int ?? 10
    }

    
    
       //沉浸模式
    static var enableImmersivemode: Bool {
        
        return User.userDefalut.object(forKey: kUserEnableImmersiveMode) as? Bool ?? false
    }
    
    //震动模式
    static var enableShakeMode: Bool {
    
        return User.userDefalut.object(forKey: kUserEnableShakeMode) as? Bool ?? false
    }

    
    
    
    
    static var BreakNotificationText = [NSLocalizedString("Break", comment: "")]
        
    
    
    static var localNotification = UILocalNotification()
    
    override init() {
        
        super.init()
        

    }
    
    //        localNotification = UILocalNotification()
    //
    //        localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: NSDate())
    //
    //        localNotification.alertTitle = "tongzhi"
    //        localNotification.alertBody = "aaaaaa"
    //        localNotification.alertAction = "好"
    //
    //        localNotification.soundName = UILocalNotificationDefaultSoundName
    //
    //        localNotification.applicationIconBadgeNumber = 1
    //
    //        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
   
    static func scheduleNotification(_ text: String){
        
        localNotification = UILocalNotification()
        
        localNotification.alertBody = text
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
    }

    static func getBreakNotificationTextRandomly() -> String {
    
        
        return self.BreakNotificationText.first!
        
    }
    
    static func scheduleNotificationWithSound(_ soundName:String){
    
       
        var soundID: SystemSoundID = 0
      
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "aif")!)
       
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
       
        AudioServicesPlayAlertSound(soundID)

        
        
        
        
    }
    
    static func scheduleNotificationWithShake(){
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
    }
    
    
    
 
}



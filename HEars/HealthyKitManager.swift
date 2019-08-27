//
//  HealthyKitManager.swift
//  HEars
//
//  Created by yantommy on 2017/5/24.
//  Copyright © 2017年 yantommy. All rights reserved.
//

import UIKit
import HealthKit

@available(iOS 10.0, *)
class HealthyKitManager: NSObject {

    
    static var healthStore = HKHealthStore()
    

    static var healthStatus: HKAuthorizationStatus {
    
        let typestoRead = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        let status = HealthyKitManager.healthStore.authorizationStatus(for: typestoRead)
    
        return status

    }
    
    
    static func activateHealthKit(completed: @escaping (Bool) -> Void) {
        
        
//        let typestoRead = Set([
//                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
//                ])
        let typestoShare = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
                ])
        
        
        HealthyKitManager.healthStore.requestAuthorization(toShare: typestoShare, read: nil) { (success, error) -> Void in
            
                if success == false {
                    print("solve this error:" + String(describing: error?.localizedDescription))
                    print("Display not allowed")
                    
                    
                }
                if success == true {
                    print("dont worry everything is good\(success)")
                    print("成功拿到正念读写权限")
      
                }
            
            completed(success)
            
            
        }
        
    }
    
    static func saveMindfullAnalysisWith(startTime: Date, endTime: Date) {
        
        // alarmTime and endTime are NSDate objects
        if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            
            // we create our new object we want to push in Health app
            let mindfullSample = HKCategorySample(type:mindfulType, value: 0, start: startTime, end: endTime)
            
            // at the end, we save it
            healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
                
                if error != nil {
                    // something happened
                    return
                }
                
                if success {
                    print("正念数据写入成功")
                    
                } else {
                    // something happened again
                    print("正念数据写入错误")
                    print(String(describing: error?.localizedDescription))
                }
                
            })
            
        }else{
        
            print("没有正念数据读取权限")
        }
        
    }


}

//if #available(iOS 8, *) {
//    // iOS 8 及其以上系统运行
//}


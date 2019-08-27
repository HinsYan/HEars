//
//  User.swift
//  HEars
//
//  Created by yantommy on 16/7/27.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static var userDefalut = UserDefaults.standard
        
    //拿数据
    static func getUserDefaultValue(_ key:String) -> AnyObject? {
    
        if key != "" {
        
            return userDefalut.object(forKey: key) as AnyObject?
            
        }else{
        
            return nil
        }
    }
    
    //储存数据
    static func setUserDefaultValue(_ key:String, value: AnyObject) {
        
        if key != "" {
            
           userDefalut.set(value, forKey: key)
        }
    }    
    
}




//
//  Layout.swift
//  HEars
//
//  Created by yantommy on 16/7/18.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class Layout: NSObject {

    static let currentScreenWidth = UIScreen.main.bounds.width
    
    static let currentScreenHeight = UIScreen.main.bounds.height
    

    static func TimerLabelFitFont(_ screenWidth:CGFloat) -> CGFloat {
        
        //iphone 4
        if screenWidth < 320 {
        
            return 30
        }
        //5
        if screenWidth < 375 {
        
            return 40
        }
        //6
        if screenWidth < 414 {
        
            return 50
        }
        //6Puls
        if screenWidth < 768 {
        
            return 55
        }

        //iPad
        if screenWidth < 1024 {
        
            return 100
        }
        
        //iPad Pro
        
        return  150
      
    }
    
}

//
//  Theme.swift
//  HEars
//
//  Created by yantommy on 16/7/18.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

enum AppTheme {

    case theme1
    case theme2
    case theme3
    case theme4
    case theme5
    
    var themeColor: UIColor {
    
        switch self {
            
        case .theme1:
            
            //黑色
            return UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
            
        case .theme2:
            
            //红色
            return UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            
        case .theme3:
            
            //绿色
            return UIColor(red: 0, green: 1, blue: 0, alpha: 1)
            
        default:
            
            return UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        }
    }
    
}

enum AppLanguage: Int {
    
    //因为后面Cell的第一行为导航栏所以这里从1开始
    case english = 1
    case 简体中文 = 2
    case 繁体中文 = 3
    
}

struct AppManager {
    
    
    
    static var currentLanguage = AppManager.defaultLanguage {
    
        didSet{
        
//            (
//                "en-CN",
//                "zh-Hans-CN",
//                "zh-Hant-CN",
//                "gu-CN"
//            )
           
            
            switch currentLanguage {
                
            case .english:
                
                print("英语")
                
                User.userDefalut.set(["Base"], forKey: "AppleLanguages")
                
                if User.userDefalut.synchronize() {
                    
                    print("切换成功：\(User.userDefalut.object(forKey: "AppleLanguages") as! NSArray)")
                }
                
                Bundle.setLanguage("Base")

                
            case .简体中文:
                
                print("简体中文")
                
                User.userDefalut.set(["zh-Hans-CN"], forKey: "AppleLanguages")
                
                if User.userDefalut.synchronize() {
                    
                    print("切换成功：\(User.userDefalut.object(forKey: "AppleLanguages") as! NSArray)")
                }
                
                Bundle.setLanguage("zh-Hans")

                
            case .繁体中文:
                
                print("繁体中文")
                
                User.userDefalut.set(["zh-Hant-CN"], forKey: "AppleLanguages")
                
                if User.userDefalut.synchronize() {
                    
                    print("切换成功：\(User.userDefalut.object(forKey: "AppleLanguages") as! NSArray)")
                }
                
                Bundle.setLanguage("zh-Hant")


            }
        
            //發送通知更新UI
            NotificationCenter.default.post(name: Notification.Name(rawValue: "didLanguageChanged"), object: nil)
            
        }
        
        
        
    }
    
    //首次啟動獲取默認語言
    static var defaultLanguage: AppLanguage {
    
        let language = (User.userDefalut.object(forKey: "AppleLanguages") as! NSArray).firstObject
        
        let languageString = language as! String
        
        
        print("默认语言\(languageString)")
        
        switch languageString {
         
            
        //注意加上-CN
        case "zh-Hant-CN":
        
            return AppLanguage.繁体中文
            
        case "zh-Hans-CN":
            return AppLanguage.简体中文
        //默认使用英语
        default:
            return AppLanguage.english
        }
    
    }
    
    //默认黑色
    static var currentTheme = AppTheme.theme1 {
    
        didSet{
        
            //切换主题
            let window = UIApplication.shared.keyWindow
            window?.tintColor = currentTheme.themeColor
        }
    }
    

    //支持语言()
    //因为后面Cell的第一行为导航栏所以第一个为空
    static var allLanguage = ["","English","简体中文","繁体中文"]
    
    //颜色设置
    static func setThemeColor(_ newTheme: AppTheme) {
    
        //切换主题
        let window = UIApplication.shared.keyWindow
        window?.tintColor = newTheme.themeColor
        currentTheme = newTheme
    }
    
    
    
}


//
//  NSBundle+Language.swift
//  LanguageSwiftTest
//
//  Created by yantommy on 16/9/12.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import Foundation
import ObjectiveC


var _bundle: UInt8 = 0;

class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle:Bundle? = objc_getAssociatedObject(self, &_bundle) as? Bundle;
        
        if let temp = bundle{
            return temp.localizedString(forKey: key, value: value, table: tableName);
        }else{
            return super.localizedString(forKey: key, value: value, table: tableName);
        }
    }
    
   
}

extension Bundle {
    
    
    class func setLanguage(_ language:String?){
//        var oneToken: Int = 0
        //let associatedObjectHandle = "nsh_DescriptiveName";
//        dispatch_once(&oneToken) {
//            object_setClass(Bundle.main, BundleEx.self as AnyClass);
//        }
//        
        
        DispatchQueue.once { (success) in
            object_setClass(Bundle.main, BundleEx.self as AnyClass)
        }
        
        
        if let temp = language{
            
            objc_setAssociatedObject(Bundle.main, &_bundle, Bundle(path: Bundle.main.path(forResource: temp, ofType: "lproj")!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }else{
            objc_setAssociatedObject(Bundle.main, &_bundle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        
        
    }
}

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:(Void)->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}



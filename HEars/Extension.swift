//
//  Extension.swift
//  HEars
//
//  Created by yantommy on 16/7/17.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class Extension: NSObject {
    
    
}

public extension UIViewController {

    @IBAction public func unwindToVC(_ segue: UIStoryboardSegue) {
    
    }
}

public extension UIView {

    var centerToSublayers: CGPoint {
    
        return CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    }
}




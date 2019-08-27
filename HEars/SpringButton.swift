//
//  SpringButton.swift
//  HEars
//
//  Created by yantommy on 16/8/13.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class SpringButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            }, completion: nil)
    

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            
            self.transform = CGAffineTransform.identity
            
            }, completion: nil)
    
    }

    func tagAnimation(_ isIn:Bool) {
        
        let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        if isIn {
        
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                
                self.alpha = 1.0
                self.transform = CGAffineTransform.identity
                
                }, completion: nil)
        }else{
        
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                
                
                self.alpha = 0
                self.transform = transform
              
                }, completion: nil)
        }
    }
 }

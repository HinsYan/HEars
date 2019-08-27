//
//  DynamicBack.swift
//  HEars
//
//  Created by yantommy on 16/9/12.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class DynamicBack: UIView {

    
    var gradientLayer = CAGradientLayer()
    
    var colors = [CGColor]()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    override func awakeFromNib() {
        

        self.colors = self.getRandomColor(2)
        
        self.gradientLayer.colors = self.colors

        self.gradientLayer.locations = [0,1]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0 )
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        

        
    }
    
    override func layoutSubviews() {
        
        gradientLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)

        
    }
    
    func changeColors(){
        
       
        self.colors = self.getRandomColor(2)
        

        let animation = CABasicAnimation(keyPath: "colors")
        
        animation.toValue = self.colors
        animation.duration = 1.0
        
        self.gradientLayer.colors = self.colors
        
        self.gradientLayer.add(animation, forKey: "changeColors")

    }
    
    func getRandomColor(_ count: Int) -> [CGColor] {
    
        var colors = [CGColor]()
        
        for _ in 0..<count {
        
            let R = CGFloat(arc4random() % 240)
            let G = CGFloat(arc4random() % 240)
            let B = CGFloat(arc4random() % 240)

            let color = UIColor(red: R / 255, green: G / 255, blue: B / 255, alpha: 1).cgColor
            
            colors.append(color)
        }
        
        return colors
        
    }
    
}

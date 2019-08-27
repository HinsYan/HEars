
//
//  AnimatedMaskLabel.swift
//  HEars
//
//  Created by yantommy on 16/8/13.
//  Copyright © 2016年 yantommy. All rights reserved.
//


import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
  
    var displayLink: CADisplayLink!
    
    
    var textColor = AppManager.currentTheme.themeColor.cgColor
    
    var gradientColors = [
        AppManager.currentTheme.themeColor.cgColor,
        AppManager.currentTheme.themeColor.withAlphaComponent(0.2).cgColor,
        AppManager.currentTheme.themeColor.cgColor
    ]
    
    
    let gradientLayer: CAGradientLayer = {
        
    
        let gradientLayer = CAGradientLayer()
   
        // Configure the gradient here
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
  
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let locations:[NSNumber] = [0.35,0.5,0.65]
        
        gradientLayer.locations = locations
    
    
        return gradientLayer
    }()
  
    var textAttributes : [String: AnyObject] = {
   
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        return [NSFontAttributeName: UIFont.systemFont(ofSize: 25, weight: UIFontWeightRegular),NSParagraphStyleAttributeName:style]
    }()

  @IBInspectable var text: String! {
    didSet {
      setNeedsDisplay()

      UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
      text.draw(in: bounds, withAttributes: textAttributes)
        
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      let maskLayer = CALayer()
      maskLayer.backgroundColor = UIColor.clear.cgColor
      maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
      maskLayer.contents = image?.cgImage
      
      gradientLayer.mask = maskLayer
    }
  }

    
    override func layoutSubviews() {
        
   
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
    
   }
  
 
    override func didMoveToWindow() {

    
        super.didMoveToWindow()
        layoutIfNeeded()
   
        //正常颜色
        gradientLayer.colors = [textColor,textColor,textColor]
        
        layer.addSublayer(gradientLayer)
    
        displayLink = CADisplayLink(target: self, selector: #selector(self.fire))

        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    
        //动画时间
        displayLink.frameInterval = 180
    
   
        //不暂停
        displayLink.isPaused = false
    
    
    }
    
    func fire(){
    
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        
        gradientAnimation.fromValue = [0.0, 0.0, 0.35]
        gradientAnimation.toValue = [0.65, 1.0, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.delegate = self
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        gradientLayer.locations = [0.65,1.0,1.0]
  
        
    }

    
    //销毁
    deinit{
        
        self.displayLink.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
    }

    
    
  
}

extension AnimatedMaskLabel: CAAnimationDelegate {

    
    func animationDidStart(_ anim: CAAnimation) {
        //设置渐变色
        if !displayLink.isPaused {
            
            self.gradientLayer.colors = self.gradientColors
        }
    }


    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //暂停渐变动画，避免动画马上消失处理方法
        if displayLink.isPaused {
            
            self.gradientLayer.colors = [textColor,textColor,textColor]
        }
        
    }
}


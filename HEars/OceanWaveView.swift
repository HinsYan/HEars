//
//  OceanWave.swift
//  HEars
//
//  Created by yantommy on 16/7/31.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class OceanWaveView: UIView {

    
    var wave1 = CAShapeLayer()
    var wave2 = CAShapeLayer()
    var wave3 = CAShapeLayer()
    
    var h: CGFloat = 0
    var A: CGFloat = 15.0
    
    var offset: CGFloat = 0
    
    var offsetX1: CGFloat = 0
    var offsetX2: CGFloat = 120
    var offsetX3: CGFloat = 290
    
    var speed: CGFloat = 2
    
    var displayLink: CADisplayLink!
    var animationDisplayLink: CADisplayLink!
    var count60:CGFloat = -1
    
    
    var animationChangeValue: CGFloat!
    var isDown = false
    var currentTimerViewTotalSeconds:Int!
    
    
    
    fileprivate var onFinished: ((Bool)->())? = nil
    
    
    fileprivate func callOnFinished(_ finished: Bool) {
        //调用
        self.onFinished?(finished)
        //重新nil
        self.onFinished = nil
    }
    
    func setOceanWaveColor(_ color: UIColor){
    
        
        let animation = CABasicAnimation(keyPath: "fillColor")
        
        animation.duration = 1.0
        animation.toValue = color.withAlphaComponent(0.8).cgColor

        self.wave1.speed = 0
        self.wave2.speed = 0
        self.wave3.speed = 0

        
        self.wave1.add(animation, forKey: "changeColor")
        animation.toValue = color.withAlphaComponent(0.6).cgColor
        self.wave2.add(animation, forKey: "changeColor")
        animation.toValue = color.withAlphaComponent(0.4).cgColor
        self.wave3.add(animation, forKey: "changeColor")
        
        
//        self.wave1.addAnimation(animation, forKey: "changeColoe")
//        self.wave1.addAnimation(animation, forKey: "changeColoe")
//        self.wave1.addAnimation(animation, forKey: "changeColoe")
        

        
//        self.wave1.fillColor = color.colorWithAlphaComponent(0.8).CGColor
//        self.wave2.fillColor = color.colorWithAlphaComponent(0.6).CGColor
//        self.wave3.fillColor = color.colorWithAlphaComponent(0.4).CGColor
        
    }

    func oceanWaveAnimation(){
    
        self.offsetX1 += self.speed
        self.offsetX2 += self.speed
        self.offsetX3 += self.speed
        
        let path1 = CGMutablePath()
//        CGPathMoveToPoint(path1, nil, 0, self.h)
        path1.move(to: CGPoint(x: 0, y: self.h))
        
        var y1 = CGFloat()
        
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: self.h))
        var y2 = CGFloat()
        
        
        let path3 = CGMutablePath()
        path3.move(to: CGPoint(x: 0, y: self.h))

        var y3 = CGFloat()

        
        for x in 0...Int(self.bounds.width) {
        
            let item1 = CGFloat(x) * CGFloat(M_PI) / 180
            let item2 = 180 / self.bounds.width * item1
            
            let q1 = self.offsetX1 * CGFloat(M_PI) / 170
            let q2 = self.offsetX2 * CGFloat(M_PI) / 180
            let q3 = self.offsetX3 * CGFloat(M_PI) / 190
            
            y1 = self.A * sin(item2 - q1) + self.h
            y2 = self.A * sin(item2 - q2) + self.h
            y3 = self.A * sin(item2 - q3) + self.h

//            CGPathAddLineToPoint(path1, nil, CGFloat(x), CGFloat(x))
//            CGPathAddLineToPoint(path2, nil, CGFloat(x), y2 + 10)
//            CGPathAddLineToPoint(path3, nil, CGFloat(x), y3 + 20)
//            

            path1.addLine(to: CGPoint(x: CGFloat(x), y: y1))
            path2.addLine(to: CGPoint(x: CGFloat(x), y: y2 + 10))
            path3.addLine(to: CGPoint(x: CGFloat(x), y: y3 + 20))
            
//            y = self.A * sin((300 / self.bounds.width) * (x * M_PI / 180) - self.offsetX * M_PI / 270)

            
        }
        
//        CGPathAddLineToPoint(path1, nil, self.bounds.width, self.frame.size.height)
//        CGPathAddLineToPoint(path1, nil, 0, self.frame.size.height)
        
        path1.addLine(to: CGPoint(x: self.bounds.width, y: self.frame.size.height))
        path1.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
      

        
        path1.closeSubpath()
        self.wave1.path = path1
        

        path2.addLine(to: CGPoint(x: self.bounds.width, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: 0, y: self.frame.size.height))

        
        path2.closeSubpath()
        self.wave2.path = path2

        
        path3.addLine(to: CGPoint(x: self.bounds.width, y: self.frame.size.height))
        path3.addLine(to: CGPoint(x: 0, y: self.frame.size.height))

        
        path3.closeSubpath()
        self.wave3.path = path3

        
        
        
    }
    
    
//    ((self.timerView.totalSeconds * 60) - self.count60)
    func changeHightFire(){
    
//        
//        print("现在的Count60: \(self.count60)")
        
        if self.isDown {
            
            self.count60 += self.animationChangeValue
            self.h = self.count60 / CGFloat(self.currentTimerViewTotalSeconds) * self.bounds.height

            if self.h >= self.bounds.height {
                
                self.animationDisplayLink.isPaused = true
                self.animationDisplayLink.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
                
//                print("最终高度")
//                print(self.h)
//                print(self.count60)
                
                //完成后调用closure
                self.callOnFinished(true)

                
            }


        
        }else{
        
            self.count60 -= self.animationChangeValue

            self.h = self.count60 / CGFloat(self.currentTimerViewTotalSeconds) * self.bounds.height

            if self.h <= 0 {
//                
//                print("最终高度")
//                print(self.h)
//                print(self.count60)
                
                self.animationDisplayLink.isPaused = true
                self.animationDisplayLink.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)

                //完成后调用closure
                self.callOnFinished(true)

             }
        
        }
    }
    
    
    func oceanViewChangeHightAnimation(_ totalMSec: Int, currentMsec: Int, isDown: Bool , animationMsec: Int ,onFinished: ((Bool)->())? = nil) {
    
        
        self.currentTimerViewTotalSeconds = totalMSec
        self.isDown = isDown
        
        
        if isDown {
            
            self.animationChangeValue = CGFloat(totalMSec - currentMsec) / CGFloat(animationMsec)

            
        }else{
            
            self.animationChangeValue = CGFloat(currentMsec) / CGFloat(animationMsec)
            
        }

        self.animationDisplayLink = CADisplayLink(target: self, selector: #selector(self.changeHightFire))

        self.animationDisplayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        
    
        //此时动画还没有完成
        callOnFinished(false)
        //传递closure
        self.onFinished = onFinished

        
    }
    
    
    override func didMoveToSuperview() {
        
        
        self.h = self.bounds.height
        
        self.wave1.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor
        self.wave2.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.wave3.fillColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        self.layer.addSublayer(wave1)
        self.layer.addSublayer(wave2)
        self.layer.addSublayer(wave3)
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.oceanWaveAnimation))
        self.displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        
        
        
    }
    
}

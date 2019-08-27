//
//  RadarView.swift
//  HEars
//
//  Created by yantommy on 16/7/18.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
//import QuartzCore

class RadarView: UIView {


    var animationDuration = CFTimeInterval(5)

    var displayLink: CADisplayLink!
    
    override func draw(_ rect: CGRect) {

        //刷新视图在SB中的约束，设置圆角
        self.layer.cornerRadius = self.bounds.width/2

    }

    
    func getWaveAnimation(_ animationDuration: CFTimeInterval) -> CAAnimationGroup {
        
        //透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = 0.0
        
        //放大动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 1.3
        
        
        //动画组
        let waveAnimationGroup = CAAnimationGroup()
        
        //水纹动画时间函数
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        waveAnimationGroup.duration = animationDuration
        //无限循环
        waveAnimationGroup.repeatCount = 1
        
        waveAnimationGroup.timingFunction = defaultCurve
        
        //动画成组
        waveAnimationGroup.animations = [opacityAnimation, scaleAnimation]

        return waveAnimationGroup
        
    }
    
    
    //Timer 水纹动画执行方法
    func startWaveAnimation(){
        
        let waveAnimation = self.getWaveAnimation(self.animationDuration)
        
        //设置代理（处理开始与结束的细节动画和其他操作）
        waveAnimation.delegate = self
        
        let waveLayer = CALayer()
        
        waveLayer.frame = self.bounds
        waveLayer.borderWidth = 1.3
        waveLayer.borderColor = AppManager.currentTheme.themeColor.withAlphaComponent(0.4).cgColor
        waveLayer.backgroundColor = UIColor.clear.cgColor
        waveLayer.cornerRadius = self.bounds.size.width/2

        self.layer.addSublayer(waveLayer)
        
        //存储调用对象（方便后面回调移除，释放内存）
        waveAnimation.setValue(waveLayer, forKeyPath: "waveLayer")
        
        //添加水纹动画
        waveLayer.add(waveAnimation, forKey: "waveAnimation")
        
        
    }
    
    
    
}

extension RadarView: CAAnimationDelegate {

    //坑2-在此处修改视图背景
    override func awakeFromNib() {
        
        //        //不能尝试在此处刷新SB中的约束并设置圆角 因为此时刚加载Nib文件
        //        self.layoutIfNeeded()
        //        self.layer.cornerRadius = self.bounds.width/2
        
        //必须先将View的背景设为无色才能显示下面的浅色（不能理解，没搞懂😒）
        self.backgroundColor = UIColor.clear
        
        self.layer.borderColor = AppManager.currentTheme.themeColor.withAlphaComponent(0.4).cgColor
        self.layer.borderWidth = 2
        
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.startWaveAnimation))
        self.displayLink.frameInterval = 60
        self.displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        self.displayLink.isPaused = true

        
        
    }
    
    //结束回调，释放对象
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        
        if let waveLayer = anim.value(forKey: "waveLayer") as? CALayer {
            
            //清除理储存
            anim.setValue(nil, forKeyPath: "waveLayer")
            //从父图层上移除并销毁
            waveLayer.removeFromSuperlayer()
        }
    }

}

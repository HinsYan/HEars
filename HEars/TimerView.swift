//
//  TimerView.swift
//  HEars
//
//  Created by yantommy on 16/7/22.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit


enum AnimationDirection: Int {
    //向上
    case position = 1
    //向下
    case negation = -1
}

class TimerView: UIView {

    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var timeSPLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    var tapGesture = UITapGestureRecognizer()
    var longPressGesture = UILongPressGestureRecognizer()
    
    var progressCircle = CAShapeLayer()
    
    var timeLabels = [UILabel]()
    
    //属性观察者（方便进行动画）
    var progressSecond = -1 {
    
        didSet{
        
            //环形进度条角度为（－90到270，顺时针）
            self.progressCircle.strokeEnd = CGFloat(self.progressSecond) / CGFloat(self.totalSeconds)

        }
    }
    //总时间（对外唯一接口）
    var totalSeconds = 0 {
    
        didSet{
            
            //更新进度
            self.progressSecond = 0
            //更新Label
            self.showCountdownToLabel(self.totalSeconds)
        }
    }
    
    override func awakeFromNib() {

        
        //设置Label显示颜色
        self.minuteLabel.textColor = AppManager.currentTheme.themeColor
        self.secondLabel.textColor = AppManager.currentTheme.themeColor
        self.timeSPLabel.textColor = AppManager.currentTheme.themeColor
        
        self.stateLabel.textColor = AppManager.currentTheme.themeColor
        self.stateLabel.font = UIFont.systemFont(ofSize: Layout.TimerLabelFitFont(Layout.currentScreenWidth), weight: UIFontWeightLight)

        //根据屏幕大小判断不同设备动态设置字体大小
        self.minuteLabel.font = UIFont.systemFont(ofSize: Layout.TimerLabelFitFont(Layout.currentScreenWidth), weight: UIFontWeightLight)
        self.secondLabel.font = UIFont.systemFont(ofSize: Layout.TimerLabelFitFont(Layout.currentScreenWidth), weight: UIFontWeightLight)
        self.timeSPLabel.font = UIFont.systemFont(ofSize: Layout.TimerLabelFitFont(Layout.currentScreenWidth), weight: UIFontWeightLight)
        
        //成组
        self.timeLabels = [minuteLabel,timeSPLabel,secondLabel]
        
        //添加手势
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longPressGesture)
        
        
        //先隐藏
        self.minuteLabel.isHidden = true
        self.secondLabel.isHidden = true
        self.timeSPLabel.isHidden = true
        
        //隐藏长按手势
        self.longPressGesture.isEnabled = false
        
    }
    
    
    //画进度圈（此方法在此view被添加到VC时刷新约束后再调用 因为需要根据View的大小画圆）
    func drawProgressCircle(){
    
        //获得路径
        let progressPath = UIBezierPath(arcCenter: self.centerToSublayers, radius:self.bounds.width/2, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2 * 3), clockwise: true)
        
        
       
        //设置环形进度圈
        
        self.setProgressCircle(self.progressCircle, path: progressPath, fillColor: UIColor.clear, strokeColor: AppManager.currentTheme.themeColor)
        
        //添加到最底层
        self.layer.insertSublayer(self.progressCircle, at: 0)
    }
    
    //设置环形进度圈
    func setProgressCircle(_ layer: CAShapeLayer, path: UIBezierPath, fillColor:UIColor, strokeColor: UIColor){
        
        
        
        layer.lineWidth = 2

        layer.lineJoin = kCALineJoinRound
        layer.lineCap = kCALineCapRound

        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        
        //阴影效果（shadowOpacity不透明度 默认为0表示完全透明，需手动设置，否则没有阴影效果）
        layer.shadowOpacity = 0.5
        layer.shadowColor = layer.fillColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 20
        
        layer.path = path.cgPath
        

        
    }
    
    //TimerSelector方法
    func startCountdown(){
    
        
//        print(self.progressSecond)
//        //进度＋1（从0开始）
//        self.progressSecond += 1
//        //显示倒计时
        
        //进度＋1（从0开始）
        self.progressSecond += 1
        
        self.showCountdownToLabel(self.totalSeconds - self.progressSecond)
        
        print("当前的进度\(self.progressSecond)")


    }
    
    //显示倒计时
    func showCountdownToLabel(_ currentSeconds: Int){
        
        //获取分钟数和秒钟数
        let minute = currentSeconds / 60 
        let second = currentSeconds % 60
        
        
        //计时显示（设置保留2位）
        self.minuteLabel.text = String(format: "%0.2d", minute)
        self.secondLabel.text = String(format: "%0.2d", second)
    }
    
    func changeCenterLabel(_ toLabels: [UILabel], fromLabels: [UILabel], direction: AnimationDirection){
    
        
        //长按手势可用与不可用判断
        if fromLabels == [self.stateLabel] {
        
            self.longPressGesture.isEnabled = true
            
        }else{
        
            self.longPressGesture.isEnabled = false
        }
        
        //防止用户暴力点击
        self.tapGesture.isEnabled = false
        
        
        for label in toLabels {
        
            let labelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0
            
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: labelOffset))
            
            label.layer.opacity = 0
            
            label.isHidden = false
            
        }
    
        
        UIView.animate(withDuration: 0.3, animations: {
            
            
            for label in toLabels {
                
                label.layer.opacity = 1.0
            }
            
            for label in fromLabels {
                
                
                label.layer.opacity = 0.0
            }

            }, completion: { (success) in
                
//                for label in fromLabels {
//                  
//                    label.layer.opacity = 1.0
//                    
//                    
//                }
                
                
        }) 
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            
            for label in toLabels {
                
                label.transform = CGAffineTransform.identity
//                label.layer.opacity = 1.0
            }
            
            for label in fromLabels {
                
                let labelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0
                
                label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -labelOffset))
//                label.layer.opacity = 0.0
            }
            
            }) { (success) in
            
                for label in fromLabels {
                
                label.transform = CGAffineTransform.identity
//                label.layer.opacity = 1.0
                label.isHidden = true
                
                //防止用户暴力点击
                self.tapGesture.isEnabled = true
                
                
                }
            
              }
        }
    
}


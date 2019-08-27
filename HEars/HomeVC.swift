//
//  HomeVC.swift
//  HEars
//
//  Created by yantommy on 16/7/17.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import AVFoundation
import HealthKit
import AMPopTip
import EAIntroView

class HomeVC: UIViewController {

  
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var radarView: RadarView!
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var menuButton: SpringButton!
    @IBOutlet weak var arrowButton: SpringButton!
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var timeRadarView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var introView: IntroView!
    
    @IBOutlet weak var notificationLabel: LTMorphingLabel!

    
    @IBOutlet weak var indicatorControll: SnakePageControl!
    
    @IBOutlet weak var dynamicBack: DynamicBack!
    
    var oceanView = OceanWaveView()
    
    var themeTitleLabel = UILabel()
    
    var pomodoro = Pomodoro()
    
    var displayLink: CADisplayLink!
    
    var backgroundingDate = NSDate()
    var currentCountdownProgress = 0
    var isActiveInApp = true
    
    var localNotification: UILocalNotification!
    
    var themeViews = [UIView]()
    
    var isTransitionToNoiseVC = true
    
    let settingTransition = SettingTransition()
    let noiseVCTransition = NoiseVCTransition()
    
    
    var mindfulnessStartTime: Date!
    var mindfulnessEndTime: Date!
    
    @IBAction func startButton(_ sender: AnyObject) {
        
        
//        localNotification = UILocalNotification()
//        
//        localNotification.fireDate = NSDate(timeInterval: 3, sinceDate: NSDate())
//        
//        localNotification.alertTitle = "tongzhi"
//        localNotification.alertBody = "aaaaaa"
//        localNotification.alertAction = "好"
//        
//        localNotification.soundName = UILocalNotificationDefaultSoundName
//        
//        localNotification.applicationIconBadgeNumber = 1
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
      
    }
    @IBAction func activeAction(_ sender: UIButton) {
        
    }
    @IBAction func showGiud(_ sender: UIButton) {
        
        
        
    }
    
    func showWelcomeVC(){

        
        //首次启动
        if User.getUserDefaultValue(kIsUserPerssionCompleted) == nil {
            
            frontView.alpha = 0.0
            timeRadarView.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
            
            introView = Bundle.main.loadNibNamed("IntroView", owner: self, options: nil)?.first as! IntroView
            introView.frame = self.view.bounds
            introView.deletage = self
            introView.layoutIfNeeded()
            
            view.addSubview(introView)

        //非首次启动判断
        }else{
            
            
            //首先判断是否权限是否全部开启并设置
            if #available(iOS 10.0, *) {
                
                if UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType() || HealthyKitManager.healthStatus != .sharingAuthorized {
                    User.setUserDefaultValue(kIsUserPerssionCompleted, value: false as AnyObject)

                }else{
                    User.setUserDefaultValue(kIsUserPerssionCompleted, value: true as AnyObject)
                }
                
                
            }else{
                
                if UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType() {
                    User.setUserDefaultValue(kIsUserPerssionCompleted, value: false as AnyObject)
                }else{
                    User.setUserDefaultValue(kIsUserPerssionCompleted, value: true as AnyObject)
                }
                
            }

            //没有全部开启进行设置
            let isUserPerssionCompleted = User.getUserDefaultValue(kIsUserPerssionCompleted) as! Bool
            if !isUserPerssionCompleted {
                
                frontView.alpha = 0.0
                timeRadarView.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                
                introView = Bundle.main.loadNibNamed("IntroView", owner: self, options: nil)?.first as! IntroView
                introView.frame = self.view.bounds
                introView.deletage = self
                introView.layoutIfNeeded()
                
                view.addSubview(introView)
            }
            
        }
        
        
    }
    
    @IBAction func menuButtonDidTouch(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationLabel.textColor = AppManager.currentTheme.themeColor
        notificationLabel.text = ""
        notificationLabel.morphingEffect = .evaporate
        notificationLabel.textAlignment = .center
        

        
        //首先刷新子视图在SB中的约束
        self.view.layoutIfNeeded()
        
        //再对timerView画圆
        timerView.drawProgressCircle()

        
        displayLink = CADisplayLink(target: self, selector: #selector(self.fire))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        displayLink.frameInterval = 1
        displayLink.isPaused = true
        
        //手势识别触发方法
        self.timerView.tapGesture.addTarget(self, action: #selector(self.tapAction))
        self.timerView.longPressGesture.addTarget(self, action: #selector(self.longPressAction))
        self.timerView.longPressGesture.minimumPressDuration = 2
    

        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        
        //scroll
        themeViews = self.getThemeViews(NoiseTheme.allNoiseTheme)
        //第一個為不透明
        themeViews[0].viewWithTag(2)?.layer.opacity = 1.0
        
        //设置代理用于监听
        self.scrollView.delegate = self
        
        //背景波纹
        oceanView.frame = self.view.bounds
        self.view.insertSubview(oceanView, belowSubview: frontView)
//
//        //控制动画Label
//        let currentAnimatedLabel = themeViews[indicatorControll.currentPage].viewWithTag(2) as! AnimatedMaskLabel
//        currentAnimatedLabel.displayLink.paused = Pomodoro.isfocusing ? true : false

        self.setPageControll()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didLanguageChanged), name: NSNotification.Name(rawValue: "didLanguageChanged"), object: nil)
        
        showWelcomeVC()
        
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        
//        self.timeRadarView.transform = CGAffineTransformMakeScale(0.5, 0.5)
//        self.timeRadarView.layer.opacity = 0.0
        
        //显示当前时间
        self.redayForDateLabel(self.dateLabel)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //设置不可横屏
        //实际受影响的是后面的VC，因为HomeVC是窗口的根视图控制器
        //通过控制根VC是否支持自动旋转来控制其他VC的旋转支持
        
//        HomeVC.isLandscape = false
//        self.shouldAutorotate()
        
        if segue.identifier == "ShowSettingVC" {
        
            //设置目标视图控制器转场代理
            let toVC = segue.destination as! UINavigationController
            toVC.transitioningDelegate = self
            
            self.isTransitionToNoiseVC = false
            
        }
        
        if segue.identifier == "ShowNoiseVC" {
        
            let toVC = segue.destination as! NoiseVC
            
            toVC.transitioningDelegate = self
            self.isTransitionToNoiseVC = true
            

        }
    }

    
    
    func redayForDateLabel(_ label: UILabel){
        
        
        //时间显示
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        
        
        let localeIdentifier = (User.userDefalut.object(forKey: "AppleLanguages") as! NSArray).firstObject as! String
        
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        
        dateFormatter.dateFormat = "MMM dd EE｜yyyy"
        self.dateLabel.text = dateFormatter.string(from: currentDate).uppercased()
    
    }
    
    @IBAction func actionAboutYuwei(_ sender: UIButton) {
        
        var page1 = EAIntroPage()
        page1.title = "这是一个广告公司的故事"
        page1.desc = "从前，我们在林间听鸟儿歌唱，站在溪边看鱼儿在水中游荡。怀念那个时候的我！"
        page1.bgImage = UIImage(named: "bg1")
        
        var page2 = EAIntroPage()
        page2.title = "这是一个广告公司的故事"
        page2.desc = "从前，我们在林间听鸟儿歌唱，站在溪边看鱼儿在水中游荡。怀念那个时候的我！"
        page2.bgImage = UIImage(named: "bg2")
        
        var page3 = EAIntroPage()
        page3.title = "这是一个广告公司的故事"
        page3.desc = "从前，我们在林间听鸟儿歌唱，站在溪边看鱼儿在水中游荡。怀念那个时候的我！"
        page3.bgImage = UIImage(named: "bg3")
        
        var introView = EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3])!
        introView.skipButtonY = 667-22
      
        
        
        //        view.addSubview(introView)
        //        view.sendSubview(toBack: introView)
        
        introView.show(in: self.view, animateDuration: 0.5)
        
//        let introVC = UIStoryboard.init(name: "Intro", bundle: Bundle.main).instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
//        present(introVC, animated: true) {
//
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    deinit {
    
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didLanguageChanged"), object: nil)
    }
    
}

extension HomeVC: IntroViewDelegate {

    func introViewDidCompleted(introView: IntroView, isPerssionCompleted: Bool) {
        
////        //首次完成设置，开启指导
//        if User.getUserDefaultValue(kIsUserPerssionCompleted) == nil {
//            self.tapAction()
//        
//        
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2500)) {
//
//                let timerPopTip = PopTip()
//                timerPopTip.actionAnimation = .pulse(nil)
//                timerPopTip.bubbleColor = UIColor.init(red: 0.1, green: 0.8, blue: 0.6, alpha: 1.0)
//                timerPopTip.shouldDismissOnSwipeOutside = false
//                timerPopTip.show(text: NSLocalizedString("tap to pause Or longPress to giveup", comment: ""), direction: .down, maxWidth: 150, in: self.timerView, from: self.timerView.stateLabel.frame)
//
//                timerPopTip.dismissHandler = { [weak self] popTip in
//
//                    let noisePopTip = PopTip()
//                    noisePopTip.actionAnimation = .pulse(nil)
//                    noisePopTip.bubbleColor = UIColor.init(red: 0.1, green: 0.8, blue: 0.6, alpha: 1.0)
//                    noisePopTip.shouldDismissOnSwipeOutside = false
//                    noisePopTip.bubbleOffset = -20
//                    noisePopTip.show(text: NSLocalizedString("adjust noise volume", comment: ""), direction: .up, maxWidth: 150, in: self!.view, from: self!.arrowButton.frame, duration: 5)
//
//                }
//
//            }
//        
//        }
        
        UIView.animate(withDuration: 0.6, animations: {
            
            introView.alpha = 0.0
            
            introView.lbeWelcome.frame.origin.y -= 100
            introView.lbeIntro.frame.origin.y -= 100
            
            introView.lbePerssion.frame.origin.y += 100
            introView.btnNotifaction.frame.origin.y += 100
            introView.btnMindfulness.frame.origin.y += 100
            introView.btnStart.frame.origin.y += 100
            
            self.frontView.alpha = 1.0
            self.timeRadarView.transform = CGAffineTransform.identity
            
        }) { (success) in
            
            if isPerssionCompleted {
                User.setUserDefaultValue(kIsUserPerssionCompleted, value: true as AnyObject)
            }
            
            introView.removeFromSuperview()
        }
    }
}

extension HomeVC {

    //更新UI
    func didLanguageChanged(){
        
        for index in 0..<self.themeViews.count {
        
            let themeNameLabel = self.themeViews[index].viewWithTag(2) as! UILabel
            themeNameLabel.text = NoiseTheme.allNoiseNames[index]
        }
        
        if Pomodoro.isPaused {
        
            timerView.stateLabel.text = NSLocalizedString("Keep", comment: "")
        }
        
        if !Pomodoro.isfocusing {
            
            if Pomodoro.currentState == .break {
                
                timerView.stateLabel.text = NSLocalizedString("Break", comment: "")
            }
            
            if Pomodoro.currentState == .longBreak {
    
                timerView.stateLabel.text = NSLocalizedString("Break", comment: "")
                
            }
            
            if Pomodoro.currentState == .focus {
                
                
                timerView.stateLabel.text = NSLocalizedString("Start", comment: "")
                
            }

            
        }else {
            
            if Pomodoro.currentState == .break {
                notificationLabel.text = NSLocalizedString("Break Timing", comment: "")
            }
            
            if Pomodoro.currentState == .longBreak {
                notificationLabel.text = NSLocalizedString("Long Break Timing", comment: "")
            }

            if Pomodoro.currentState == .focus {
                notificationLabel.text = NSLocalizedString("Focus Timing", comment: "")
            }
        
        }
        
        
        self.redayForDateLabel(self.dateLabel)
        
        
    }
    
    func willEnterBackground(){
    

    }
    
    func didEnterBackground(){
    
        isActiveInApp = false
        
        if !Pomodoro.isPaused {
        
        self.backgroundingDate = NSDate()
        //这里不直接使用progressSecond是统一管理锁屏的情况下 和正常 退出后台
        self.currentCountdownProgress = self.timerView.progressSecond
            
        }
        //人为退出后台
        //沉浸模下，放弃处理
        if Pomodoro.enableImmersivemode && Pomodoro.currentState == .focus && Pomodoro.isfocusing {
        
        
                    //触发放弃操作
        
                    Pomodoro.isGiveUp = true
        
                    timerView.progressSecond = timerView.totalSeconds - 1
        
                    print("沉浸模式下进入后台：\(Pomodoro.isGiveUp)")
                    Pomodoro.scheduleNotification(NSLocalizedString("Focus failed! 😒", comment: ""))
                     Noise.pauseNoisesWithTheme(NoiseTheme.currentNoiseTheme, isPaused: false)
        
        }
        
        
    }
    
    func didEnterForeground(){
    
        isActiveInApp = true
        
        
        if !Pomodoro.isPaused {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let intervalDuration = Int(fabs(self.backgroundingDate.timeIntervalSinceNow))
        
        self.timerView.progressSecond = min(intervalDuration + self.currentCountdownProgress, self.timerView.totalSeconds-1)
        self.oceanView.count60 = CGFloat(self.timerView.progressSecond * 60)
        
        if !Noise.timerMute.isPlaying {
            self.oceanView.h = self.oceanView.bounds.height
            self.timerView.progressSecond = self.timerView.totalSeconds
        }
            
        }
        
        
        //更新权限状态
        if introView != nil {
            introView.updateIntroPerrsionState()
        }
    
        
    }
    
    
}


extension HomeVC {

    //displayLink Selector 方法
    func fire(){
    
        self.oceanView.count60 += 1
        
        
        //通过不断改变高度不断重绘
        self.oceanView.h = (CGFloat(self.oceanView.count60) / CGFloat(self.timerView.totalSeconds * 60) ) * self.oceanView.bounds.height
        
        if self.oceanView.count60.truncatingRemainder(dividingBy: 60) == 0 {
    
    
            //噪声可用时判断
            if Noise.enableNoise {
            
                self.radarView.startWaveAnimation()
            }
           
            print("XXXXX")
            
           self.timerView.startCountdown()
        
        
        //结束判断
        if self.timerView.progressSecond == self.timerView.totalSeconds {
            
            self.endOfTimer()
            
        }
        
    }
        
        
        
        
    }
    
}


extension HomeVC {

    func endOfTimer(){

        
        
        if #available(iOS 10.0, *) {
            
            if HKHealthStore.isHealthDataAvailable() {
            
            mindfulnessEndTime = Date()
            
            print(CGFloat(mindfulnessEndTime.timeIntervalSince(mindfulnessStartTime)))
            
            if CGFloat(mindfulnessEndTime.timeIntervalSince(mindfulnessStartTime)) > 60.0 {
                
                print("开始写入数据")
                HealthyKitManager.saveMindfullAnalysisWith(startTime: mindfulnessStartTime, endTime: mindfulnessEndTime)
            }
                
            }else{
            
                print("没有正念数据读取权限")
            }
            
        } else {
            // Fallback on earlier versions
            
            
        }

        
        
        notificationLabel.text = ""
        
        //结束计时，进入重新计时模式
        Pomodoro.isfocusing = false
        
        //控制动画Label
        let shimmeringView = themeViews[indicatorControll.currentPage].viewWithTag(3) as! FBShimmeringView
        //停止渐变动画
        shimmeringView.isShimmering = true
        
        //打开滑动
        self.scrollView.isScrollEnabled = true
        
        //高度动画完成后再停止
        //暂停动画
        self.displayLink.isPaused = true

        
        
        //暂停音频
        Noise.pauseNoisesWithTheme(NoiseTheme.allNoiseTheme[indicatorControll.currentPage], isPaused: true)

        
//        self.oceanView.h = self.oceanView.bounds.height
//        self.timerView.progressSecond = self.timerView.totalSeconds

        
        //预备进入休息模式
        if Pomodoro.enableBreak && Pomodoro.currentState == .focus && !Pomodoro.isGiveUp {
            
            print("开始休息")
//
            
            
            //背景变化
            self.dynamicBack.changeColors()
            
            
            //提示文案
            self.timerView.stateLabel.text = NSLocalizedString("Break", comment: "")
            
            Pomodoro.countToLongBreakFrequency += 1
            
            //长休息判断
            if Pomodoro.countToLongBreakFrequency % Pomodoro.longBreakFrequency == 0 {
                
                //切换长休息状态
                Pomodoro.currentState = .longBreak
                //重新计数
                Pomodoro.countToLongBreakFrequency = 0
                
                
                //短休息
            }else{
                Pomodoro.currentState = .break
            }
            
            //提示音
            Pomodoro.scheduleNotificationWithSound("NS_Completed")
            Pomodoro.scheduleNotification(NSLocalizedString("Focus Completed! have a relax ♨️", comment: ""))

            
            
            //无休息模式,休息完成时,放弃时
        }else{
            
            
            //放弃时
            if Pomodoro.isGiveUp {
                //只震动
                Pomodoro.scheduleNotificationWithShake()
                print("放弃")
                
                //无休息 或者 休息完成时
            }else{
                
                
                print("完成休息")
                //只提醒
                
                //提示音
                Pomodoro.scheduleNotificationWithSound("NS_Completed")
                Pomodoro.scheduleNotification(NSLocalizedString("Relax Completed! continue focus ✊", comment: ""))

        
            }
            
            //取反
            Pomodoro.isGiveUp = false
            
            self.timerView.stateLabel.text = NSLocalizedString("Start", comment: "")
            //继续专注
            Pomodoro.currentState = .focus
            
            
            
            //高度动画
            self.oceanView.oceanViewChangeHightAnimation(self.timerView.totalSeconds * 60, currentMsec: Int(self.oceanView.count60) , isDown: true, animationMsec: 60, onFinished: { (success) in
                
            })

            
            
            
        }
    
        
        //提示语变化
        self.timerView.changeCenterLabel([self.timerView.stateLabel], fromLabels: self.timerView.timeLabels, direction: AnimationDirection.negation)

    }

}

extension HomeVC {

    func tapAction(){
        
                
        
        
        //先前是否为专注状态
        if Pomodoro.isfocusing {
            
        
            //沉浸模式下尝试暂停 发出震动提醒 表示没法暂停
            if Pomodoro.enableImmersivemode && !Pomodoro.isPaused {
                    Pomodoro.scheduleNotificationWithShake()
                
            }else{
                
                //取反（切换暂停和继续状态）
          
                Pomodoro.isPaused = !Pomodoro.isPaused
            
            
                //暂停状态
                if Pomodoro.isPaused {
                    
                    
                    if #available(iOS 10.0, *) {
                        
                        if HKHealthStore.isHealthDataAvailable() {
                            
                            mindfulnessEndTime = Date()
                            
                            print(CGFloat(mindfulnessEndTime.timeIntervalSince(mindfulnessStartTime)))
                            
                            if CGFloat(mindfulnessEndTime.timeIntervalSince(mindfulnessStartTime)) > 60.0 {
                                
                                HealthyKitManager.saveMindfullAnalysisWith(startTime: mindfulnessStartTime, endTime: mindfulnessEndTime)
                            }
                            
                        }
                        
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                self.timerView.stateLabel.text = NSLocalizedString("Keep", comment: "")
                
                self.timerView.changeCenterLabel([self.timerView.stateLabel], fromLabels: self.timerView.timeLabels, direction: AnimationDirection.negation)
                
                
                //控制动画Label 禁止滑动
                let shimering = themeViews[indicatorControll.currentPage].viewWithTag(3) as! FBShimmeringView
                //停止渐变动画
                shimering.isShimmering = true
                    
                   
                self.scrollView.isScrollEnabled = true


                //暂停计时与背景动画
                self.displayLink.isPaused = true
                
                //暂停音频
                Noise.pauseNoisesWithTheme(NoiseTheme.currentNoiseTheme, isPaused: true)
                
                //继续
                }else{
                   
                    
                    if #available(iOS 10.0, *) {
                        
                        if HKHealthStore.isHealthDataAvailable() {
                            mindfulnessStartTime = Date()
                        }
                        
                    }


                    if Pomodoro.currentState == .break {
                        
                        self.notificationLabel.text = NSLocalizedString("Break Timing", comment: "")
                    }
                    
                    if Pomodoro.currentState == .longBreak {
                        
                        self.notificationLabel.text = NSLocalizedString("Long Break Timing", comment: "")
                        
                    }
                    
                    if Pomodoro.currentState == .focus {
                        self.notificationLabel.text = NSLocalizedString("Focus Timing", comment: "")
                    }
                    
                    
                self.timerView.changeCenterLabel(self.timerView.timeLabels, fromLabels: [self.timerView.stateLabel], direction: AnimationDirection.position)
                
                //计时开始
                self.displayLink.isPaused = false
                
                //暂停label渐变动画 禁止滑动
                //控制动画Label 禁止滑动
                let shimering = themeViews[indicatorControll.currentPage].viewWithTag(3) as! FBShimmeringView
                //停止渐变动画
                shimering.isShimmering = false
                    
                self.scrollView.isScrollEnabled = false
            
                //播放音频
                Noise.playNoisesWithTheme(NoiseTheme.currentNoiseTheme, duration: (self.timerView.totalSeconds - self.timerView.progressSecond) , timerMutedelegate: self)


                }
            
            }
            
        //重新开始
        }else{
            
            if #available(iOS 10.0, *) {
                
                if HKHealthStore.isHealthDataAvailable() {
                    mindfulnessStartTime = Date()
                }
                
            }
            
            
            if Pomodoro.currentState == .break {
            
                self.timerView.totalSeconds = Pomodoro.breakDuration * 60
                self.notificationLabel.text = NSLocalizedString("Break Timing", comment: "")
                
            }
            
            if Pomodoro.currentState == .focus {
            
                self.timerView.totalSeconds = Pomodoro.focusDuration * 60
                
                self.notificationLabel.text = NSLocalizedString("Focus Timing", comment: "")

            }
            if Pomodoro.currentState == .longBreak {
            
                self.timerView.totalSeconds = Pomodoro.longBreakDuration * 60
                
                  self.notificationLabel.text = NSLocalizedString("Long Break Timing", comment: "")

            }
            
            
            
            
            self.timerView.changeCenterLabel(self.timerView.timeLabels, fromLabels: [self.timerView.stateLabel], direction: AnimationDirection.position)
            
           
            //暂停label渐变动画 禁止滑动
            //控制动画Label 禁止滑动
            let shimering = themeViews[indicatorControll.currentPage].viewWithTag(3) as! FBShimmeringView
            //停止渐变动画
            shimering.isShimmering = true

          
            self.scrollView.isScrollEnabled = false
            
            
            //计时
            self.oceanView.count60 = CGFloat(self.timerView.totalSeconds * 60)
            
            //高度动画
            self.oceanView.oceanViewChangeHightAnimation(self.timerView.totalSeconds * 60, currentMsec: self.timerView.totalSeconds * 60 , isDown: false, animationMsec: 60, onFinished: { (success) in
                
                if success {
                
                    print("上升动画完成")
                    //计时开始
                    self.displayLink.isPaused = false
                    
                }
            })
            
            //播放音频
            Noise.playNoisesWithTheme(NoiseTheme.currentNoiseTheme, duration: self.timerView.totalSeconds, timerMutedelegate: self)
            
            //进入专注状态
            Pomodoro.isfocusing = true
            
        }
        
        
        
        
        
        
    }
    
    func longPressAction(){
        

        switch timerView.longPressGesture.state {
            
        case .began:

            timerView.progressSecond = timerView.totalSeconds - 1

            Pomodoro.isGiveUp = true
            
        default:
            
            return
        }
        
    }
    
}


extension HomeVC {

    //波纹开始浪动
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if Pomodoro.enableShakeMode {
        
            Pomodoro.isGiveUp = true

        }
      
    }
    
    //波纹结束浪动，并放弃
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
      
        if Pomodoro.isGiveUp && Pomodoro.isfocusing && Pomodoro.enableShakeMode && !Pomodoro.isPaused {
        
            print("放弃")
            timerView.progressSecond = timerView.totalSeconds - 1
        }

    }
    //波纹结束浪动
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {

        if Pomodoro.enableShakeMode {
     
            Pomodoro.isGiveUp = false

        }
    }
}


extension HomeVC:UIScrollViewDelegate {

    func getThemeViews(_ themes: [NoiseTheme]) -> [UIView] {
        
        var themeViews = [UIView]()
        
        for index in 0..<themes.count {
            
            let themeVC = ThemeView(nibName: "ThemeView", bundle: Bundle.main) as ThemeView
            
            //修改主题名字(奇怪的Bug,因该是生命周期的问题)
            //themeVC.themeTitle.text = theme.themeName
            
            //添加themeView到scrollView并布局
            if let themeView = themeVC.view {
                
                //可动画Label
                themeVC.lbeTheme.text = NoiseTheme.allNoiseNames[index]
                themeVC.lbeTheme.layer.opacity = 0
                themeVC.shimmeringView.isShimmering = true
                
                //布局
                themeView.frame = scrollView.bounds
                themeView.frame.origin.x = CGFloat(index) * scrollView.bounds.width
                
                //添加到scrollView
                self.scrollView.addSubview(themeView)
                
                //
                themeViews.append(themeView)
                
            }

            
            //scroll内容大小设置
            self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width * CGFloat(themes.count), height: 0)
            self.scrollView.alwaysBounceVertical = false
          
        }
        
        return themeViews
        
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.timerView.tapGesture.isEnabled = false
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //indicator翻页设置
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        
        self.indicatorControll.progress = progress

        print("当前Progress\(progress)")
        
        
        let pageWidth = scrollView.bounds.width
        let index = Int(scrollView.contentOffset.x / pageWidth)
        let pageOffset = abs(scrollView.contentOffset.x.truncatingRemainder(dividingBy: pageWidth))
        
        let visualOffset = pageWidth/1.5
    

        
        //向左滑动时
        if scrollView.contentOffset.x < 0 {
            
            //可动Label
            let currentTitle = self.themeViews[index].viewWithTag(2) as! UILabel
            currentTitle.layer.opacity = Float(visualOffset - pageOffset) / Float(visualOffset)
            
            return
        }
        
        //默认向右
        if index < self.themeViews.count - 1 {
       
            //获取下一个ThemeTitle
            
            let themeTitle = self.themeViews[index+1].viewWithTag(2) as! UILabel
            //滑动动画关键点处理
            if pageOffset > visualOffset {
          
                //注意这里（pageWidth - visualOffset）保证了不透明度变化始终从0-1或者1-0
                themeTitle.layer.opacity = Float(pageOffset - visualOffset) / Float(pageWidth - visualOffset)
            
                
            }else{
            
                //防止滑动切换过快opacity不能到0，所以手动设置
                themeTitle.layer.opacity = 0
                
            }
        }
    
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //切换当前主题
         NoiseTheme.indexOfCurrentNoiseTheme = self.indicatorControll.currentPage
         self.timerView.tapGesture.isEnabled = true
        
        
    }
    
}


extension HomeVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if isTransitionToNoiseVC {
            
            return noiseVCTransition
        
        }else{
        
            return settingTransition
        }
        

        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
        if isTransitionToNoiseVC {
            
            return noiseVCTransition
            
        }else{
            
            return settingTransition
        }
    }
    
}

extension HomeVC {

    func setPageControll(){
    
        //注意与当前所有主题的数量一致（因为要靠currentpage 来确定 currentNoiseTheme）
        
        self.indicatorControll.pageCount = NoiseTheme.allNoiseTheme.count
        self.indicatorControll.indicatorRadius = 2
        
        let indicatorPadding = (self.dateLabel.bounds.width - 8 - CGFloat(self.indicatorControll.pageCount) * self.indicatorControll.indicatorRadius * 2) / CGFloat(self.indicatorControll.pageCount - 1)
                
        self.indicatorControll.indicatorPadding = indicatorPadding
        self.indicatorControll.inactiveTint = AppManager.currentTheme.themeColor.withAlphaComponent(0.1)
        self.indicatorControll.activeTint = AppManager.currentTheme.themeColor

    }
    
}


//锁屏状态下的停止处理
extension HomeVC: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if player == Noise.timerMute {
            
            player.pause()
            
                if !isActiveInApp {
                
                    print("不在App内部音频计时器计时完成，请做对应处理：")
                    self.endOfTimer()

                }else{
                
                    print("在App内部音频计时器计时完成，请做对应校对处理：")
                    //校准 继续计时
                    player.numberOfLoops = Int(CGFloat(self.timerView.totalSeconds - self.timerView.progressSecond - 1)/CGFloat(player.duration))
                    player.play()

                
                }
                
        }
        
        
    }
}



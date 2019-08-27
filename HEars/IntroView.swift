//
//  IntroView.swift
//  HEars
//
//  Created by yantommy on 2017/5/24.
//  Copyright © 2017年 yantommy. All rights reserved.
//

import UIKit
import HealthKit

protocol IntroViewDelegate {
    func introViewDidCompleted(introView: IntroView, isPerssionCompleted: Bool) -> Void
}

class IntroView: UIView {

    @IBOutlet weak var lbeWelcome: UILabel!
    @IBOutlet weak var lbeIntro: UILabel!
    @IBOutlet weak var lbePerssion: UILabel!
    @IBOutlet weak var btnNotifaction: UIButton!
    @IBOutlet weak var btnMindfulness: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var deletage: IntroViewDelegate?
    
    @IBAction func actionNotifaction(_ sender: UIButton) {
                
        //没有打开权限
        if UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType() {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert,.sound], categories: nil))
          
        //打开过了权限
        }else{
        
            
        }

        
    }
    
    
    
    @IBAction func actionMindfulness(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            
            //已经被用户否定权限，打开健康App进行设置
            if HealthyKitManager.healthStatus == .notDetermined {
            
                HealthyKitManager.activateHealthKit { (success) in

                    //注意要在主线程跟新 因为权限的获取操作不是在主线程
                    DispatchQueue.main.async {
                        
                        self.updateIntroPerrsionState()
                    }
               
                }

                
            }
            
            if HealthyKitManager.healthStatus == .sharingDenied {
            
                UIApplication.shared.open(URL(string: "x-apple-health://")!)
            }
            
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        
        if deletage != nil {
            deletage!.introViewDidCompleted(introView: self, isPerssionCompleted: false)
        }

    }
    
    @IBAction func actionStart(_ sender: UIButton) {
                
        if deletage != nil {
            deletage!.introViewDidCompleted(introView: self, isPerssionCompleted: true)
        }
        
    }

    func updateButtonStatus() {
        // as currentNotificationSettings() is set to return an optional, even though it always returns a valid value, we use a sane default (.None) as a fallback

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        commonInit()
    }
    
    
    func commonInit(){
    
        self.backgroundColor = UIColor.clear
        
        if #available(iOS 10.0, *) {
          
            btnMindfulness.layer.cornerRadius = btnMindfulness.bounds.height/2
            btnMindfulness.layer.borderWidth = 1.0
            btnMindfulness.layer.borderColor = AppManager.currentTheme.themeColor.cgColor
            btnMindfulness.layer.backgroundColor = UIColor.clear.cgColor
            btnMindfulness.setTitleColor(AppManager.currentTheme.themeColor, for: .normal)
            btnMindfulness.setTitle(NSLocalizedString("Health Perssion", comment: ""), for: .normal)

            
        } else {
            btnMindfulness.isHidden = true
        }
        
        
        lbeWelcome.text = NSLocalizedString("Welcome HEars", comment: "")
        lbeIntro.text = NSLocalizedString("Experience a baptism from nature", comment: "")
        lbePerssion.text = NSLocalizedString("We need your agree with below", comment: "")
        btnSkip.setTitle(NSLocalizedString("Skip", comment: ""), for: .normal)
        
        
        btnNotifaction.layer.cornerRadius = btnMindfulness.bounds.height/2
        btnNotifaction.layer.borderWidth = 1.0
        btnNotifaction.layer.borderColor = AppManager.currentTheme.themeColor.cgColor
        btnNotifaction.layer.backgroundColor = UIColor.clear.cgColor
        btnNotifaction.setTitleColor(AppManager.currentTheme.themeColor, for: .normal)
        btnNotifaction.setTitle(NSLocalizedString("Notification Perssion", comment: ""), for: .normal)
        
        
        btnStart.layer.cornerRadius = btnMindfulness.bounds.height/2
        btnStart.layer.backgroundColor = UIColor.init(red: 0.1, green: 0.8, blue: 0.6, alpha: 1.0).cgColor
        btnStart.setTitleColor(UIColor.white, for: .normal)
        btnStart.setTitle(NSLocalizedString("Start HEars", comment: ""), for: .normal)
        
        btnStart.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateIntroPerrsionState), name: NSNotification.Name(rawValue: "updateIntroPerrsionState"), object: nil)
        
        updateIntroPerrsionState()
        
    }
    
    func updateIntroPerrsionState(){
    
        
        //没有打开权限
        if UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType() {

            self.btnNotifaction.layer.borderWidth = 1.0
            self.btnNotifaction.layer.backgroundColor = UIColor.clear.cgColor
            self.btnNotifaction.setTitleColor(AppManager.currentTheme.themeColor, for: .normal)
        
        //打开了权限
        }else{
        
            UIView.animate(withDuration: 0.6, animations: { 
              
                
                self.btnNotifaction.layer.backgroundColor = UIColor.white.cgColor
                self.btnNotifaction.layer.borderWidth = 0.0
          
                
            })

        }
        
        if #available(iOS 10.0, *) {
           
            if HealthyKitManager.healthStatus == .sharingAuthorized {
                
                print("获取了正念权限")
                UIView.animate(withDuration: 0.6, animations: {
                    
                    self.btnMindfulness.layer.backgroundColor = UIColor.white.cgColor
                    self.btnMindfulness.layer.borderWidth = 0.0
                    
                })

                
            }else{
                
                self.btnMindfulness.layer.borderWidth = 1.0
                self.btnMindfulness.layer.backgroundColor = UIColor.clear.cgColor
                self.btnMindfulness.setTitleColor(AppManager.currentTheme.themeColor, for: .normal)
                
            
                
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        
        if #available(iOS 10.0, *) {
            
            if UIApplication.shared.currentUserNotificationSettings?.types != UIUserNotificationType() && HealthyKitManager.healthStatus == .sharingAuthorized {
                
                UIView.animate(withDuration: 0.6, animations: { 
                    self.btnStart.isEnabled = true
                    self.btnStart.alpha = 1.0
                })
              
            }else{
           
                btnStart.isEnabled = false
                btnStart.alpha = 0.2
            }
            
        
        }else{
        
            if UIApplication.shared.currentUserNotificationSettings?.types != UIUserNotificationType() {
                UIView.animate(withDuration: 0.6, animations: {
                    self.btnStart.isEnabled = true
                    self.btnStart.alpha = 1.0
                })

            }else{
                btnStart.isEnabled = false
                btnStart.alpha = 0.2
            }
            
        }
        
    }
    
}

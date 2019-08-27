//
//  AboutMeVC.swift
//  HEars
//
//  Created by yantommy on 2018/1/18.
//  Copyright © 2018年 yantommy. All rights reserved.
//

import UIKit
import MessageUI

class AboutMeVC: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var bottomView: UIVisualEffectView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var contactMe: SpringButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: SpringButton!
    
    var scrollContentView: AboutMeView!
    
    var isbottomViewShowed = false
    var bottomViewShowedY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutIfNeeded()
        
        avatarView.layer.cornerRadius = 4.0
        avatarView.clipsToBounds = true
        
        let closeIcon = UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate)
        backButton.tintColor = UIColor.white
        backButton.setImage(closeIcon, for: .normal)
        backButton.layer.cornerRadius = backButton.bounds.width/2
        backButton.clipsToBounds = true
        
        contactMe.layer.cornerRadius = contactMe.bounds.height/2
        contactMe.clipsToBounds = true
        
        scrollContentView = Bundle.main.loadNibNamed("AboutMeView", owner: self, options: nil)?.first as! AboutMeView
        scrollContentView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: 1360)
        scrollContentView.layoutIfNeeded()
        scrollContentView.aboutMeButton.addTarget(self, action: #selector(self.actionShowAboutMe), for: .touchUpInside)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: 1360)
        scrollView.addSubview(scrollContentView)
        scrollView.delegate = self
        
        bottomViewShowedY = bottomView.frame.origin.y
        bottomView.frame.origin.y = self.view.bounds.height
        bottomView.layer.cornerRadius = 6
        bottomView.clipsToBounds = true

        print(bottomView.frame)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionShowAboutMe() {
        
        let visibleRect = CGRect(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.scrollRectToVisible(visibleRect, animated: true)
    }

    func presentMailVCWithSubject(_ subject: String){
        
        
        if MFMailComposeViewController.canSendMail() {
            
            
            // 注意这个实例要写在 if block 里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
            
            let mailComposeViewController = mailComposeVCSetting(subject)
            
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            
            self.showSendMailErrorAlert()
        }
    }
    
    
    
    @IBAction func actionContactMe(_ sender: SpringButton) {
                
        let alertVC = UIAlertController(title: "您可以通过以下方式联系我", message: "推荐使用QQ直接联系！", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let btnWeChat = UIAlertAction(title: "微信添加好友", style: .default) { (action) in
            
            let paste = UIPasteboard.general
            paste.string = "the-answer-tommy"
            
            let alertVC = UIAlertController(title: "the-answer-tommy", message: "成功拷贝微信ID到剪切板,您可以打开微信添加我为好友！备注：工作推荐", preferredStyle: UIAlertControllerStyle.alert)
            
//            let btnOpenWeChat = UIAlertAction(title: "打微信开wei xin", style: .default) { (action) in
//
//                if UIApplication.shared.canOpenURL(URL(string: "wexin://")!){
//                    UIApplication.shared.openURL(URL(string: "wexin://")!)
//                }else{
//
//                    let alertVC = UIAlertController(title: "出错了！！", message: "您的手机未安装微信", preferredStyle: UIAlertControllerStyle.alert)
//                    let btnDone = UIAlertAction(title: "好的", style: .cancel, handler: nil)
//                    alertVC.addAction(btnDone)
//                    self.present(alertVC, animated: true, completion: nil)
//
//                }
//
//
//            }
            
            let btnDone = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            
            alertVC.addAction(btnDone)
            //alertVC.addAction(btnOpenWeChat)
            self.present(alertVC, animated: true, completion: nil)
            
            
        }
 
        
        let btnMail = UIAlertAction(title: "邮件联系", style: .default) { (action) in
            self.presentMailVCWithSubject("HEars - 校招产品工作推荐")
        }
        
        let btnQQ = UIAlertAction(title: "QQ直接联系", style: .default) { (action) in
            
            if UIApplication.shared.canOpenURL(URL(string: "mqq://")!){
                //指定号码跳转到QQ聊天界面
                let qqStr = String("mqq://im/chat?chat_type=wpa&uin=" + "2523344588" + "&version=1&src_type=web")
                let url = URL(string: qqStr!)
                UIApplication.shared.openURL(url!)
                
            }else{
                
                let alertVC = UIAlertController(title: "出错了！！", message: "您的手机未安装手机QQ", preferredStyle: UIAlertControllerStyle.alert)
                let btnDone = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alertVC.addAction(btnDone)
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
        }
        
        let btnCacel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(btnMail)
        alertVC.addAction(btnWeChat)
        alertVC.addAction(btnQQ)
        alertVC.addAction(btnCacel)
        
        alertVC.popoverPresentationController?.sourceView = self.view
        alertVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        self.present(alertVC, animated: true, completion: nil)

        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AboutMeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height  - 150) {
            if !isbottomViewShowed {
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: [.curveEaseInOut,.allowUserInteraction], animations: {
                    self.bottomView.frame.origin.y = self.bottomViewShowedY
                }, completion: { (success) in
                 
                })
                
                self.isbottomViewShowed = true
            }
        }
        
        if scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.bounds.height - 150) {
            if isbottomViewShowed {
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: [.curveEaseInOut,.allowUserInteraction], animations: {
                    self.bottomView.frame.origin.y = self.view.bounds.height
                }, completion: { (success) in
                    
                })
                
                self.isbottomViewShowed = false
            }
        }
    }
}

extension AboutMeVC: MFMailComposeViewControllerDelegate {
    
    
    func mailComposeVCSetting(_ subject: String) -> MFMailComposeViewController {
        
        let mailVC = MFMailComposeViewController()
        
        mailVC.mailComposeDelegate = self
        
        //注意替换
        mailVC.setToRecipients(["yantommy@iCloud.com"])
        mailVC.setSubject(subject)
        return mailVC
    }
    
    func showSendMailErrorAlert(){
        
        let sendMailErrorAlert = UIAlertController(title: "yantommy@iCloud.com", message: "您的手机未绑定邮件功能,您可以直接发送邮件到上面的地址与我直接联系", preferredStyle: .alert)
        
        
        //取消
        sendMailErrorAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { _ in })
        /*
        sendMailErrorAlert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default, handler: { (reviewAction) in
            
            print("跳轉到App Store")
            
            //评分
            let url = URL(string: "itms-apps://itunes.apple.com/app/id1161777971")
            
            UIApplication.shared.openURL(url!)
            
            
        }))
        */
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("取消发送")
        case MFMailComposeResult.sent.rawValue:
            print("发送成功")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
}


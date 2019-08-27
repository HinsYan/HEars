//
//  AboutVC1.swift
//  HEars
//
//  Created by yantommy on 16/9/19.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import MessageUI

class AboutVC: UITableViewController {


    
    var cell2Height:CGFloat = 0.0
    
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    
    static let infoDic = Bundle.main.infoDictionary!
    
    // 获取 App 的版本号
    let appVersion = infoDic["CFBundleShortVersionString"]
    // 获取 App 的 build 版本
    let appBuildVersion = infoDic["CFBundleVersion"]
    // 获取 App 的名称
    let appName = infoDic["CFBundleDisplayName"]
    
    
    // 获取设备名称
    let deviceName = UIDevice.current.name
    // 获取系统版本号
    let systemVersion = UIDevice.current.systemVersion
    // 获取设备的型号
    let deviceModel = UIDevice.current.modelName
    // 获取设备唯一标识符
    let deviceUUID = UIDevice.current.identifierForVendor?.uuidString

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        //先刷新再计算
        self.view.layoutIfNeeded()
        
        
        //设置分割线
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        self.tableView.tableFooterView = UIView()

        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row == 1 {
        
        
//            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APPID];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

            let url = URL(string: "itms-apps://itunes.apple.com/app/id1338420391")
            UIApplication.shared.openURL(url!)
        }
        
        if indexPath.row == 2 {
        
            self.presentMailVCWithSubject(NSLocalizedString(("HEars - FeedBack"), comment: ""))
        
        }
        
        if indexPath.row == 3 {
        
            
            let CNurl = URL(string: "http://baike.baidu.com/subview/583099/12493589.htm")
            let ENurl = URL(string: "https://en.wikipedia.org/wiki/Pomodoro_Technique")
            
            if AppManager.currentLanguage == .简体中文 {
            
                UIApplication.shared.openURL(CNurl!)

            }else{
            
                UIApplication.shared.openURL(ENurl!)

            }
            
        }
        
        if indexPath.row == 4 {
        
            let CNurl = URL(string: "http://baike.baidu.com/link?url=Gy_HvRRZw67q0YZbGGk1kZfgaUHGu-OJxX_1xScHgyhiR1oV_hvN8zNLLJ8huYeCaHk357ToujfHDAcRTa3A2azySd5PEEu5Qy4ZAmxBjQqSDuitvlWT0XvVAHaBCUPTifqMJtbNewWngqXsiTtO6q")
            
            let ENurl = URL(string: "https://en.wikipedia.org/wiki/White_noise")
            
            if AppManager.currentLanguage == .简体中文 {
                
                UIApplication.shared.openURL(CNurl!)
                
            }else{
                
                UIApplication.shared.openURL(ENurl!)
                
            }

            print("关于白噪声")
        }

    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
            return 60
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //iPad白色解决
        cell.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AboutVC: MFMailComposeViewControllerDelegate {
    
    
    func mailComposeVCSetting(_ subject: String) -> MFMailComposeViewController {
        
        let mailVC = MFMailComposeViewController()
        
        mailVC.mailComposeDelegate = self
        
        //注意替换
        mailVC.setToRecipients(["yantommy@iCloud.com"])
        mailVC.setSubject(subject)
        mailVC.setMessageBody("\n\n\n \(NSLocalizedString("App Name", comment: ""))：\(appName!)\n \(NSLocalizedString("App Version", comment: ""))：\(appVersion!)\n \(NSLocalizedString("System Version", comment: ""))：\(systemVersion)\n \(NSLocalizedString("Device Mode", comment: ""))：\(deviceModel)", isHTML: false)
        
        return mailVC
    }
    
    func showSendMailErrorAlert(){
        
        let sendMailErrorAlert = UIAlertController(title: NSLocalizedString("can Not send Email!", comment: ""), message: NSLocalizedString("You device are not setting your Email,please add it in Email App,or feedback in App Store by write a review.", comment: ""), preferredStyle: .alert)
        
        //取消
        sendMailErrorAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { _ in })
        
        sendMailErrorAlert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default, handler: { (reviewAction) in
            
            print("跳轉到App Store")
            
            //评分
            let url = URL(string: "itms-apps://itunes.apple.com/app/id1338420391")
            
            UIApplication.shared.openURL(url!)
            
            
        }))
        
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

public extension UIDevice {
    
    var modelName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}


    
    


    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



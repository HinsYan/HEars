//
//  MenuVC.swift
//  HEars
//
//  Created by yantommy on 16/8/12.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: SpringButton!
    @IBOutlet weak var logoImage: SpringButton!
    @IBOutlet weak var tommy: SpringButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        
        
        
        let edgeX = self.view.bounds.width * (CGFloat(5)/CGFloat(32))
        
        print("EDGX:\(edgeX)")
        //分割线
        tableView.separatorInset = UIEdgeInsetsMake(0, edgeX, 0, edgeX)
        
        //隐藏多余分割线
        tableView.tableFooterView = UIView()
        

        //navigation背景透明
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController!.delegate = self
      
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { 

            //旋转缩小
            self.closeButton.transform = CGAffineTransform(rotationAngle: 180).concatenating(CGAffineTransform(scaleX: 0.4, y: 0.4))
          
            //透明度
            self.closeButton.alpha = 0.0
            self.logoImage.alpha = 0.0
            
           
        }, completion: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
 
        super.viewWillAppear(animated)
        
        
        //直接reload刷新语言的适配
        tableView.reloadData()
        
        
        
        
        //进行判断是为防止刚进入MenuVC时出现不必要的动画
        if self.logoImage.alpha == 0.0 {
       
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            
         
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                
                    self.logoImage.alpha = 0.0
                })
            
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                
                    self.closeButton.transform = CGAffineTransform.identity
                    self.closeButton.alpha = 1.0
                    self.logoImage.alpha = 1.0

                })
            
            }, completion: nil)
        
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonDidTouch(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logoImageDidTouch(_ sender: SpringButton) {
        
        let aboutMeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutMeVC")
        
        //self.navigationController?.pushViewController(aboutVC, animated: true)
        
        present(aboutMeVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as UITableViewCell
            
            let titleLabel = cell.viewWithTag(5) as! UILabel
            
            titleLabel.text = NSLocalizedString("SETTING", comment: "")
            
            //iPad白色解决
            cell.backgroundColor = UIColor.clear
            
            return cell
            
            
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as UITableViewCell
            
            let timerButton = cell.viewWithTag(3) as! SpringButton
            let noiseButton = cell.viewWithTag(4) as! SpringButton


            timerButton.setTitle(NSLocalizedString("Timer", comment: ""), for: UIControlState())
            noiseButton.setTitle(NSLocalizedString("Noise", comment: ""), for: UIControlState())
            
            //iPad白色解决
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as UITableViewCell
            
            //iPad白色解决
            cell.backgroundColor = UIColor.clear
            
            //修改标题
            let titleLabel = cell.viewWithTag(1) as! UILabel
            let detailLabel = cell.viewWithTag(2) as! UILabel
            
            titleLabel.text = NSLocalizedString("Language", comment: "")
            
            var detailLabelString = ""
            
            print("------------------------")
            print(AppManager.currentLanguage)
            
            switch AppManager.currentLanguage {
                
            case .english:
                
            
                detailLabelString = "English"
            
            case .简体中文:
                detailLabelString = "简体中文"
        
            case .繁体中文:
                detailLabelString = "繁体中文"
            }
            
            detailLabel.text = detailLabelString
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as UITableViewCell
            
            //iPad白色解决
            cell.backgroundColor = UIColor.clear
            
            //修改标题
            let titleLabel = cell.viewWithTag(1) as! UILabel
            let detailLabel = cell.viewWithTag(2) as! UILabel
            
            titleLabel.text = NSLocalizedString("About This App", comment: "")
            detailLabel.text = ""
            
            return cell

        }
        
    }
}

extension MenuVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.row {
            
        case 0:
            
            return 75
            
        case 1:
            
            return 60
            
        default:
            
            return 58
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
        
            let aboutVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangeLanguageVC") as! UITableViewController
            
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }
        
        if indexPath.row == 3 {
        
            let aboutVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutVC")
            
            self.navigationController?.pushViewController(aboutVC, animated: true)
            
        
        }
    }


}


extension MenuVC {


}


extension MenuVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation != UINavigationControllerOperation.none {
            
            let transition = AMWaveTransition(operation: operation, andTransitionType: .bounce)
            
            
            return transition
        }
        
        return nil
    }
    
    
}

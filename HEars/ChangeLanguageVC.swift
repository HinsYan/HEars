//
//  ChangeLanguageVC.swift
//  HEars
//
//  Created by yantommy on 16/8/14.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class ChangeLanguageVC: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置分割线
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        self.tableView.tableFooterView = UIView()
        
        
//        //注意一定不能這樣寫
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(self.didLanguageChanged()), name: "didLanguageChanged", object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didLanguageChanged), name: NSNotification.Name(rawValue: "didLanguageChanged"), object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //导航栏Cell
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationCell", for: indexPath)

            
            return cell
            
        //语言Cell
        }else{
        

            let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as UITableViewCell
            
            let tag = cell.viewWithTag(2) as! SpringButton
            
            let languageLabel = cell.viewWithTag(3) as! UILabel
            
            print(AppManager.currentLanguage.rawValue)
            
            tag.tagAnimation(AppManager.currentLanguage.rawValue == indexPath.row)
            
            
            languageLabel.text = AppManager.allLanguage[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        if indexPath.row != 0 {
            
            
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(self.didLanguageChanged()), name: "didLanguageChanged", object: nil)
     
            AppManager.currentLanguage = AppLanguage(rawValue: indexPath.row)!
           
            
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(self.didLanguageChanged()), name: "didLanguageChanged", object: nil)
//            
//            NSNotificationCenter.defaultCenter().addObserver(HomeVC.self, selector: Selector(HomeVC.didLanguageChanged()), name: "didLanguageChanged", object: nil)

            
            self.tableView.reloadData()


        }        
    }

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 70
        }
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //iPad白色解决
        cell.backgroundColor = UIColor.clear
        
        
    }
    
    
    //移除通知
    deinit{
    
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didLanguageChanged"), object: nil)
        
    }
    
}

extension ChangeLanguageVC {

    func didLanguageChanged(){
    
        let navigationCell = self.tableView.visibleCells[0] as UITableViewCell
        
        let titleLabel = navigationCell.viewWithTag(5) as! UILabel
        
        titleLabel.text = NSLocalizedString("Language", comment: "")
        
        print("didLanguage")
        
//        //不要在這裡移除通知，應該是在控制器被銷毀時移除（方便多次通知）
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "didLanguageChanged", object: nil)
        
    
    }
    
}

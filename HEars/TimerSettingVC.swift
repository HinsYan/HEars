//
//  TimerSettingVC.swift
//  HEars
//
//  Created by yantommy on 16/8/14.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class TimerSettingVC: UITableViewController {

      
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    
    @IBOutlet weak var cell5: UITableViewCell!
    
//    var numberOfCell = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //设置分割线
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        self.tableView.tableFooterView = UIView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //更新数据
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func immersiveDidChanged(_ sender: UISwitch) {
        

        User.setUserDefaultValue(kUserEnableImmersiveMode, value: sender.isOn as Bool as AnyObject)
        
    }
    @IBAction func shakeModeDidChanged(_ sender: UISwitch) {
        
        User.setUserDefaultValue(kUserEnableShakeMode, value: sender.isOn as Bool as AnyObject)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 跳转传值
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == StoryBoardIdentifier.ChooseFocusTime {
        
            let toVC = segue.destination as! DurationChooseVC
            
            toVC.dataItem = ["5","10","15","20","25","30","40","50","60","90"]
            toVC.titleText = "Focus Time"
            toVC.choosedValue = Pomodoro.focusDuration
        }
        
    }
    // MARK: - Table view data source

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //MARK: - 待优化

        return 5
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            return cell1
            
        case 1:
            
            let indicatorLabel = cell2.viewWithTag(2) as! UILabel
            indicatorLabel.text = "\(Pomodoro.focusDuration) \(NSLocalizedString("Minutes", comment: ""))"
            
            return cell2
            
        case 2:
            
            return cell3
            
        case 3:
            
            let switchView = cell4.viewWithTag(1) as! UISwitch
            // MARK: - todo
            switchView.isOn = Pomodoro.enableImmersivemode
            
            return cell4
            
        case 4:
            
            //获取swith按钮的状态
            let switchView = cell5.viewWithTag(1) as! UISwitch
            switchView.isOn = Pomodoro.enableShakeMode
            
            return cell5
            
        default:
            
            //永远不会执行
            return cell2
        }

    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //iPad白色解决
        cell.backgroundColor = UIColor.clear
    }
}

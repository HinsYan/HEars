//
//  MenuTableVC.swift
//  HEars
//
//  Created by yantommy on 16/8/11.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import AVFoundation

class NoiseSettingVC: UITableViewController {


    
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置分割线
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        self.tableView.tableFooterView = UIView()
        
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if Noise.enableNoise {
        
            return 3
            
        }else{
        
            return 2
        }
        
    }

    @IBAction func musicFusionDidChange(_ sender: UISwitch) {
        
        //保存设置状态到用户偏好里
        User.setUserDefaultValue(kUserEnableFusionWithMusic, value: sender.isOn as AnyObject)
        
        if Noise.enableFusionWithMusic {
            //后台播放
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }else{
            
            //后台播放
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
            }catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let error as NSError {
            
            print(error.localizedDescription)
        }
        

        
        
        
        //MARK: - Todo
    }
   
    @IBAction func enableNoiseDidChange(_ sender: UISwitch) {
        
        
        tableView.beginUpdates()
        
        
        //MARK: - 待优化（简单写死）
        let indexPath = IndexPath(row: 2, section: 0)
        
        //插入判断（注意判断 Switch之前是否为关闭状态，否则存在一种极端情况: 当Switch为打开状态时 用户左右切换最后还是选择了打开，此时再更新数据源插入cell会出现崩溃，因为要插入的cell本就存在）
        if sender.isOn && !Noise.enableNoise {
            
            
            //插入前更新（必须）
            User.setUserDefaultValue(kUserEnableNoise, value: sender.isOn as AnyObject)

            //立即暂停(注意顺序，更新后再判断)
            if Pomodoro.isfocusing && !Pomodoro.isPaused {
                
                print("播放")
                Noise.playNoisesWithTheme(NoiseTheme.currentNoiseTheme, duration: nil, timerMutedelegate: nil)
                
            }

            
            self.tableView.insertRows(at: [indexPath], with: .top)
        }
        //删除判断（注意事项同上）
        if !sender.isOn && Noise.enableNoise {
            
            self.tableView.deleteRows(at: [indexPath], with: .top)
            
            //立即暂停(待优化)
            if Pomodoro.isfocusing && !Pomodoro.isPaused {
                
                Noise.pauseNoisesWithTheme(NoiseTheme.currentNoiseTheme, isPaused: false)
            }

            
            
            //删除后更新（必须）
            User.setUserDefaultValue(kUserEnableNoise, value: sender.isOn as AnyObject)
            
            
            
        }
        
        tableView.endUpdates()
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //在这里判断各种cell的插入情况（把将来需要插入的cell也要写进来）
        
        switch indexPath.row {

        case 0:
            
            return cell1
            
        case 1:
            
            //获取swith按钮的状态
            let switchView = cell2.viewWithTag(2) as! UISwitch
            switchView.isOn = Noise.enableNoise
            
            return cell2
            
        default:
            
            //获取swith按钮的状态
            let switchView = cell3.viewWithTag(2) as! UISwitch
            switchView.isOn = Noise.enableFusionWithMusic
            
            return cell3

        }
    
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //iPad白色解决
        cell.backgroundColor = UIColor.clear
    }

    
    
 
}


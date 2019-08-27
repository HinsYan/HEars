//
//  BreakSettingVC.swift
//  HEars
//
//  Created by yantommy on 16/8/14.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class BreakSettingVC: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    @IBOutlet weak var cell6: UITableViewCell!
    

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func breakModeDidChange(_ sender: UISwitch) {
        
        
        tableView.beginUpdates()
        
        let indexPath2 = IndexPath(row: 2, section: 0)
        let indexPath3 = IndexPath(row: 3, section: 0)
        
        let indexPath4 = IndexPath(row: 4, section: 0)
        let indexPath5 = IndexPath(row: 5, section: 0)
        
        var indexPaths = [indexPath2,indexPath3,indexPath4,indexPath5]
        
        //开启／关闭休息模式
        if !Pomodoro.enableBreak && sender.isOn {
            
            
            User.setUserDefaultValue(kUserEnableBreak, value: sender.isOn as AnyObject)

            //开启／关闭长休息模式
            if Pomodoro.enableLongBreak {
           
                
                self.tableView.insertRows(at: indexPaths, with: .fade)

            }else{
            
                indexPaths.removeLast()
                indexPaths.removeLast()
            
                self.tableView.insertRows(at: indexPaths, with: .fade)
            }
            
            
        
        }
        
        
        if Pomodoro.enableBreak && !sender.isOn{
            
    
            if Pomodoro.enableLongBreak{
            
                self.tableView.deleteRows(at: indexPaths, with: .fade)
                
            }else{
            
                indexPaths.removeLast()
                indexPaths.removeLast()

                self.tableView.deleteRows(at: indexPaths, with: .fade)
           
            }
            
            User.setUserDefaultValue(kUserEnableBreak, value: sender.isOn as AnyObject)

        }
        
        tableView.endUpdates()
        
        
        
    }

    @IBAction func longBreakModeDidChange(_ sender: UISwitch) {
        
        
        tableView.beginUpdates()

        let indexPath4 = IndexPath(row: 4, section: 0)
        let indexPath5 = IndexPath(row: 5, section: 0)
        
        let indexPaths = [indexPath4,indexPath5]
        
        //开启／关闭休息模式
        if sender.isOn && !Pomodoro.enableLongBreak {
            
            User.setUserDefaultValue(kUserEnableLongBreak, value: sender.isOn as AnyObject)
            self.tableView.insertRows(at: indexPaths, with: .fade)
            
        }
        if !sender.isOn && Pomodoro.enableLongBreak {
            
            self.tableView.deleteRows(at: indexPaths, with: .fade)
            User.setUserDefaultValue(kUserEnableLongBreak, value: sender.isOn as AnyObject)

        }
        
        tableView.endUpdates()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == StoryBoardIdentifier.ChooseBreakTime {
            
            let toVC = segue.destination as! DurationChooseVC
            
            toVC.dataItem = ["5","10","15","20","25","30"]
            toVC.titleText = "Break Time"
            toVC.choosedValue = Pomodoro.breakDuration
        }
        
        
        if segue.identifier == StoryBoardIdentifier.ChooseLongBreakFrequency {
            
            let toVC = segue.destination as! DurationChooseVC
        
            toVC.dataItem = ["2","3","4","5","6","7","8"]
            toVC.titleText = "Long Break Frequency"
            toVC.choosedValue = Pomodoro.longBreakFrequency
            
        }
        
        if segue.identifier == StoryBoardIdentifier.ChooseLongBreakTime {
            
            let toVC = segue.destination as! DurationChooseVC
            
            toVC.dataItem = ["10","15","20","25","30","40","50","60"]
            toVC.titleText = "Long Break Time"
            toVC.choosedValue = Pomodoro.longBreakDuration
        }


    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if Pomodoro.enableBreak {
        
            if Pomodoro.enableLongBreak {
    
                return 6
            }
            //关闭长休息时
            return 4
            
        }else{
            //关闭休息时
            return 2
        }
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            return cell1
            
        case 1:
            
            // MARK: - todo
            let switchView = cell2.viewWithTag(1) as! UISwitch
            switchView.isOn = Pomodoro.enableBreak
            return cell2
            
        case 2:
            
            let indicatorLabel = cell3.viewWithTag(2) as! UILabel
            indicatorLabel.text = "\(Pomodoro.breakDuration) \(NSLocalizedString("Minutes", comment: ""))"
            
            return cell3
            
        case 3:
            
            // MARK: - todo
            let switchView = cell4.viewWithTag(1) as! UISwitch
            switchView.isOn = Pomodoro.enableLongBreak
            
            return cell4
            
        case 4:
            let indicatorLabel = cell5.viewWithTag(2) as! UILabel
            indicatorLabel.text = "\(Pomodoro.longBreakDuration) \(NSLocalizedString("Minutes", comment: ""))"

            return cell5
            
        case 5:
            
            let indicatorLabel = cell6.viewWithTag(2) as! UILabel
            indicatorLabel.text = "\(Pomodoro.longBreakFrequency) \(NSLocalizedString("Focuses", comment: ""))"
            
            return cell6
            
        default:
            
            //永远不会执行
            return cell2
        }

    
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //iPad白色解决
        cell.backgroundColor = UIColor.clear
    }

    

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

}

//
//  DurationChooseVC.swift
//  HEars
//
//  Created by yantommy on 16/8/14.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit


class DurationChooseVC: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var indicatorLabel: UILabel!
    
    var dataItem = [String]()
    
    var titleText = ""
    
    var choosedValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
       
        titleLabel.text = NSLocalizedString(titleText, comment: "")
        pickerView.selectRow(dataItem.index(of: String(choosedValue))!, inComponent: 0, animated: false)
        
        // Do any additional setup after loading the view.
    }


    @IBAction func doneButtonDidTouch(_ sender: SpringButton) {
        
        //返回传值
        if titleText == "Focus Time" {
            
            User.setUserDefaultValue(kUserFocusDuration, value: self.choosedValue as AnyObject)
                    
        }
        if titleText == "Break Time" {
            
            User.setUserDefaultValue(kUserBreakDuration, value: self.choosedValue as AnyObject)
                        
        }
        if titleText == "Long Break Time" {
            
            User.setUserDefaultValue(kUserLongBreakDuration, value: self.choosedValue as AnyObject)

        }
        if titleText == "Long Break Frequency" {
            
            User.setUserDefaultValue(kUserLongBreakFrequency, value: self.choosedValue as AnyObject)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleText == "Long Break Frequency" {
        
            self.indicatorLabel.text = NSLocalizedString("Focuses", comment: "")
        }else{
        
            self.indicatorLabel.text = NSLocalizedString("Mins", comment: "")
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DurationChooseVC: PickerViewDelegate {

    //高度
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        
        return 85
    }

    //获取值
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        
        self.choosedValue = Int(self.dataItem[index])!

    }
    
    func pickerView(_ pickerView: PickerView, didTapRow row: Int, index: Int) {
        
        self.choosedValue = Int(self.dataItem[index])!
    }
    
    //定制
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        
        label.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightLight)
        
        if highlighted {
        
            label.textColor = UIColor.white
            
        }else{
        
            label.textColor = AppManager.currentTheme.themeColor
        }
    }
    
}

extension DurationChooseVC: PickerViewDataSource {

    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        
        return self.dataItem.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        
        return self.dataItem[index]
    }
}

extension DurationChooseVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.dataItem[row]
    }
}

extension DurationChooseVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.choosedValue = Int(self.dataItem[row])!
        
        print("选择了第\(row)行")
    }
    
    
    
}




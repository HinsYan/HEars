//
//  TaskTimerPickView.swift
//  HEars
//
//  Created by yantommy on 2017/6/23.
//  Copyright © 2017年 yantommy. All rights reserved.
//

import UIKit

class TaskTimerPickView: UIView {

    @IBOutlet weak var pickerView: PickerView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        if pickerView.currentSelectedRow == nil {
            
            
            print("-------")
        }
        
        
        
        pickerView.selectionStyle = .overlay
        
        //手动设置颜色（默认是白色）
        pickerView.backgroundColor = UIColor.clear
        
        pickerView.selectionOverlay.alpha = 1.0
        pickerView.selectionOverlay.layer.backgroundColor = AppManager.currentTheme.themeColor.cgColor
        pickerView.selectionOverlay.layer.shadowColor = AppManager.currentTheme.themeColor.cgColor
        pickerView.selectionOverlay.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        pickerView.selectionOverlay.layer.shadowRadius = 30
        pickerView.selectionOverlay.layer.shadowOpacity = 0.5

        
    }
    
    
}

extension TaskTimerPickView: PickerViewDelegate {
    
    //高度
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        
        return 40
    }
    
    //获取值
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        
        
    }
    
    func pickerView(_ pickerView: PickerView, didTapRow row: Int, index: Int) {
        
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

extension TaskTimerPickView: PickerViewDataSource {
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        
        return 10
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        
        return String(index)
    }

}

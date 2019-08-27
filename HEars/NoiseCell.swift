//
//  NoiseCell.swift
//  HEars
//
//  Created by yantommy on 16/8/10.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import AVFoundation

class NoiseCell: UITableViewCell {

    @IBOutlet weak var noiseIcon: UIImageView!
    @IBOutlet weak var volumeSlider: UISlider!
  
    @IBOutlet weak var noiseTitle: UILabel!
    @IBOutlet weak var volumeValue: UILabel!
    
    var displayLink: CADisplayLink!
    //刷新之前的音量（不會有變化）
    var currentCellVolume: Float!
    //默認主題的音量
    var expectCellVolume:Float!
    //displayLink每次執行改變量
    var changedVolume: Float!

    
    
    
    var cellNumber: Int!
    
    
    
    
    var noisePlayer: AVAudioPlayer!
    
    var thumbImage:UIImage = {
    
        let image = UIImage(named: "SliderThumb")
        
            return image!
    }()
    
    @IBAction func volumeSliderDidChanged(_ sender: UISlider) {
        
        noisePlayer.play()
        noisePlayer.volume = sender.value / sender.maximumValue
         
        volumeValue.text = String(Int(sender.value))
        
        if let index = self.cellNumber {
        
            //注意音量是按百分比控制的
            NoiseTheme.currentNoiseTheme.themevolumes[index] = noisePlayer.volume
            //持久化
            User.setUserDefaultValue(NoiseTheme.currentNoiseTheme.themeName, value: NoiseTheme.currentNoiseTheme.themevolumes as AnyObject)
            
  
        }

        print(noisePlayer.volume)
        print(noisePlayer.isPlaying)
        
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //iPad显示为白色 解决方法
        self.backgroundColor = UIColor.clear
        
        volumeSlider.setThumbImage(thumbImage, for: UIControlState())
        volumeSlider.setThumbImage(thumbImage, for: .highlighted)
        
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.sliderValueChanged))
        self.displayLink.frameInterval = 1
        self.displayLink.isPaused = true
        self.displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
                
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func sliderValueChanged(){
    
        
        self.volumeSlider.value -= self.changedVolume
        
        self.noisePlayer.volume = self.volumeSlider.value / self.volumeSlider.maximumValue
        
        self.volumeValue.text = String(Int(self.volumeSlider.value))


        
//        print("\(cellNumber):\(self.volumeSlider.value)")
        
        //剩餘改變量
        let needChangedValue = self.volumeSlider.value - self.expectCellVolume
//        
//        //板正
//        if needChangedValue < 0 {
//        
//            needChangedValue = -needChangedValue
//        }
    
//        print(needChangedValue)
//        print("changede")
//        print(changedVolume)
        
        //當前量約等於默認音量時暫停,此處注意加"=" (因為可能存在一種情況，有些可見的Cell現在的音量就是默認音量，不需要調整，但還是要暫停掉，節約資源)
        if  abs(needChangedValue) <= abs(changedVolume) {
        
            //手動校準
            self.volumeSlider.value = self.expectCellVolume
            self.volumeValue.text = String(Int(self.expectCellVolume))
            
            print("動畫完成")
            self.displayLink.isPaused = true
        }
    
        
        
    }
    
    
    deinit {
    
        self.displayLink.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)

    }

}

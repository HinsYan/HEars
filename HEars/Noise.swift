//
//  Noise.swift
//  HEars
//
//  Created by yantommy on 16/9/12.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit
import AVFoundation

class Noise {

    
    static var enableFusionWithMusic: Bool {
        
        return User.getUserDefaultValue(kUserEnableFusionWithMusic) as? Bool ?? true
    }
    
    static var enableNoise: Bool {
        
        return User.getUserDefaultValue(kUserEnableNoise) as? Bool ?? true
    }
    
    static var iPlayNoises = true
    
    //对于音频播放时间的参考（主要针对锁屏等状态 结束时间的参考确定）
    //音频默认长度为1S 所以当前计时多少秒 该音频就循环播放多少秒
    static var timerMute: AVAudioPlayer = {
    
        var timerMute = AVAudioPlayer()
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "TimerMute", ofType: "aifc")!)
        
        do{
            try timerMute = AVAudioPlayer(contentsOf: url)
        }catch let error as NSError {
            print(error.localizedDescription)
        }

        timerMute.prepareToPlay()
        timerMute.volume = 0.0
        timerMute.pause()
        
      
        return timerMute


        
    }()
    
    
    static var noiseNames = [kNoiseSpringRainy,kNoiseParkBird,kNoiseThundering,kNoiseSouthWind,kNoiseEchoChimes,kNoiseClearChimes,kNoiseVillageNight,kNoiseDryLawnFire,kNoiseDuskCicadas,kNoiseLowTide,kNoiseBabblingBrook,kNoiseSlientPiano,kNoiseInsideTrain,kNoiseValleyDrip,kNoiseLeisureFlute]

    //创建所有声音集合
    static var allNoises: [Noise] = {
    
        var noises = [Noise]()
        
        for name in Noise.noiseNames {
            
            var noise = Noise(noiseName: name)
            
            noises.append(noise)
        }
        
        return noises

    }()
    
    
    static func playNoisesWithTheme(_ theme: NoiseTheme, duration: Int?, timerMutedelegate: UIViewController?){
 
        
        if Noise.enableNoise {
        
            for index in 0..<Noise.allNoises.count {
        
            
            Noise.allNoises[index].soundPlayer.volume = 0.0
            Noise.allNoises[index].soundPlayer.play()
            
            let fader = iiFaderForAvAudioPlayer(player: Noise.allNoises[index].soundPlayer)
            
                print("开始播放音频\(index)")
                
            fader.fade(fromVolume: 0.0, toVolume: Double(theme.themevolumes[index]), duration: 1, velocity: 0.5, onFinished: { (success) in
                
                print("音量：\(Noise.allNoises[index].soundPlayer.volume)")
            })
        
       
            }
        }
        
        //记录播放时间
        if timerMutedelegate != nil && duration != nil {
        
            Noise.timerMute.numberOfLoops = Int(CGFloat(duration!)/CGFloat(Noise.timerMute.duration))
            Noise.timerMute.play()
            
            
            //结束判断交给控制器
            Noise.timerMute.delegate = timerMutedelegate! as? AVAudioPlayerDelegate
            
        }
        
        
    }
    
    static func pauseNoisesWithTheme(_ theme: NoiseTheme, isPaused: Bool){
    
       
            for index in 0..<Noise.allNoises.count {
            
        
            let fader = iiFaderForAvAudioPlayer(player: Noise.allNoises[index].soundPlayer)

                
            fader.fadeOut(1, velocity: 0.5, onFinished: { (success) in
                
                
            })

            if isPaused {
                
                //暂停计时
                self.timerMute.pause()

            }
                
        

        }
        
    }
    
    
    var name: String!

    var soundPlayer: AVAudioPlayer!
    
    var icon: UIImage!
    
    
    init(noiseName: String) {
        
        self.name = noiseName
        
        self.icon = UIImage(named: noiseName)
        
        print(self.name)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: noiseName, ofType: "mp3")!)
        
        do{
            try soundPlayer = AVAudioPlayer(contentsOf: url)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        soundPlayer.numberOfLoops = -1
        soundPlayer.prepareToPlay()
        

    }
    
}



//
//  NoiseTheme.swift
//  HEars
//
//  Created by yantommy on 16/9/12.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class NoiseTheme {

    
//    static var defaultThemes: [String: [Float]] = ["Forest Rainy": [0.2,0.1,0.5,0,0,0,0,0,0,0,0,0,0,0],"Summer Night"]
    
    
    static var isDefault = false
        
    //噪声主题
    static var allNoiseTheme: [NoiseTheme] {

        return [NoiseTheme.noiseTheme1,NoiseTheme.noiseTheme2,NoiseTheme.noiseTheme3,NoiseTheme.noiseTheme4,NoiseTheme.noiseTheme5]
        
    }
    
    //获取所有主题名（包含本地化，方便后面更新UI）
    static var allNoiseNames: [String] {
    
        var names = [String]()
        
        for noiseTheme in NoiseTheme.allNoiseTheme {
        
            let name = NSLocalizedString(noiseTheme.themeName, comment: "")
            
            names.append(name)
            
        }
        
        return names
    }
    
    static var noiseTheme1: NoiseTheme {
    
        let noiseThemeName = "Babbing Brook"
        
        let noiseThemeVolumes = User.getUserDefaultValue(noiseThemeName) as? [Float] ?? [0,0.1,0,0,0,0,0,0,0,0,0.15,0,0,0.25,0.5]
        
        return NoiseTheme(themeName: noiseThemeName, volums: noiseThemeVolumes)
    }
    
    static var noiseTheme2: NoiseTheme {
        
        let noiseThemeName = "Summer Night"
        
        let noiseThemeVolumes = User.getUserDefaultValue(noiseThemeName) as? [Float] ?? [0,0,0,0,0,0.1,0.05,0,0.45,0,0,0,0,0,0]
        
        return NoiseTheme(themeName: noiseThemeName, volums: noiseThemeVolumes)
    }
    
    static var noiseTheme3: NoiseTheme {
        
        let noiseThemeName = "Ocean Tide"
        
        let noiseThemeVolumes = User.getUserDefaultValue(noiseThemeName) as? [Float] ?? [0,0,0,0.1,0,0,0,0,0,0.5,0,0,0,0,0]
        
        return NoiseTheme(themeName: noiseThemeName, volums: noiseThemeVolumes)
    }

    static var noiseTheme4: NoiseTheme {
        
        let noiseThemeName = "Forest Rainy"
        
        let noiseThemeVolumes = User.getUserDefaultValue(noiseThemeName) as? [Float] ?? [0.5,0.15,0.1,0,0,0,0,0,0,0,0,0,0,0,0]
        
        return NoiseTheme(themeName: noiseThemeName, volums: noiseThemeVolumes)
    }


    static var noiseTheme5: NoiseTheme {
        
        let noiseThemeName = "Sky Meditation"
        
        let noiseThemeVolumes = User.getUserDefaultValue(noiseThemeName) as? [Float] ?? [0,0,0,0,0.2,0,0,0,0,0,0,0.5,0.1,0,0]
        
        return NoiseTheme(themeName: noiseThemeName, volums: noiseThemeVolumes)
    }

    
    static var indexOfCurrentNoiseTheme = 0 {
    
        didSet{
        
            NoiseTheme.currentNoiseTheme = NoiseTheme.allNoiseTheme[NoiseTheme.indexOfCurrentNoiseTheme]
        }
    }
    
    //默认当前主题为第一个
    static var currentNoiseTheme = NoiseTheme.allNoiseTheme[NoiseTheme.indexOfCurrentNoiseTheme]
    

    
    var themeName: String!
    
    var themevolumes: [Float]!
    
    init(themeName: String, volums: [Float]){
    
        self.themeName = themeName
        self.themevolumes = volums
        
    }
    

    
    
}

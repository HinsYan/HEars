//
//  ThemeOne.swift
//  HEars
//
//  Created by yantommy on 16/8/6.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class ThemeView: UIViewController {

//    @IBOutlet weak var themeTitle: UILabel!
    @IBOutlet weak var lbeTheme: UILabel!
    @IBOutlet weak var shimmeringView: FBShimmeringView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isExclusiveTouch = true
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        
        lbeTheme.textColor = AppManager.currentTheme.themeColor
        
        
        shimmeringView.contentView = lbeTheme
    
        shimmeringView.shimmeringBeginFadeDuration = 2.0
        shimmeringView.shimmeringEndFadeDuration = 2.0
        shimmeringView.shimmeringSpeed = 100
        shimmeringView.shimmeringAnimationOpacity = 0.2
        
        shimmeringView.isShimmering = true

//        self.view.layoutIfNeeded()
//        
//        self.themeTitle.font = UIFont.systemFontOfSize(Layout.TimerLabelFitFont(Layout.currentScreenWidth), weight: UIFontWeightThin)
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

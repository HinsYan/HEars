//
//  IntroVC.swift
//  HEars
//
//  Created by yantommy on 2018/1/9.
//  Copyright © 2018年 yantommy. All rights reserved.
//

import UIKit
import EAIntroView

class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var page1 = EAIntroPage()
        page1.title = "这是一个广告公司的故事"
        page1.desc = "从前，我们在林间听鸟儿歌唱，站在溪边看鱼儿在水中游荡。怀念那个时候的我！"
        
        var page2 = EAIntroPage()
        page2.title = "这是一个广告公司的故事"
        page2.desc = "从前，我们在林间听鸟儿歌唱，站在溪边看鱼儿在水中游荡。怀念那个时候的我！"
        
        var page3 = EAIntroPage()
        page3.title = "这是一个广告公司的故事"
        page3.desc = "从前，我们在林间听鸟儿歌唱，站在溪边看鱼儿在水中游荡。怀念那个时候的我！"
        
        var introView = EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3])!

        
//        view.addSubview(introView)
//        view.sendSubview(toBack: introView)
        
        introView.show(in: self.view, animateDuration: 0.5)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCloseVC(_ sender: UIButton) {
        dismiss(animated: true) {
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

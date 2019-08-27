//
//  AboutMeView.swift
//  HEars
//
//  Created by yantommy on 2018/1/19.
//  Copyright © 2018年 yantommy. All rights reserved.
//

import UIKit

class AboutMeView: UIView {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var aboutMeButton: SpringButton!
    @IBOutlet weak var picMe: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
                
        aboutMeButton.layer.cornerRadius = aboutMeButton.bounds.height/2
        aboutMeButton.clipsToBounds = true
        
        picMe.layer.cornerRadius = 6
        picMe.clipsToBounds = true
        
        
    }
    @IBAction func actionAboutMe(_ sender: SpringButton) {
    
//        if let _ = self.superview {
//            let scrollView = self.superview as! UIScrollView
//            scrollView.scrolls
//        }
    }
}

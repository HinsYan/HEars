//
//  SettingTransition.swift
//  HEars
//
//  Created by yantommy on 16/9/7.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class SettingTransition: NSObject,UIViewControllerAnimatedTransitioning {

    var isPresenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        if isPresenting {
            
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! HomeVC
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! UINavigationController
            
        
//        let rect = toVC.view.bounds
//        let upRect = CGRectMake(0, 0, fromVC.view.bounds.width, fromVC.view.bounds.height/2)
//        let downRect = CGRectMake(0, fromVC.view.bounds.height/2, fromVC.view.bounds.width, fromVC.view.bounds.height/2)
////        
////        UIGraphicsBeginImageContext(upRect.size)
////        
////        let context = UIGraphicsGetCurrentContext()
////        toVC.view.layer.renderInContext(context!)
////        
////        let image = UIGraphicsGetImageFromCurrentImageContext()
////        UIGraphicsEndImageContext()
//        
//        
//        
//            UIGraphicsBeginImageContextWithOptions(upRect.size, false, 0.0)
//            
//            toVC.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//            
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            
//            UIGraphicsEndImageContext()
//          
//        
////
////        let upRect = CGRectMake(0, 0, toVC.view.bounds.width, toVC.view.bounds.height/2)
////        let downRect = CGRectMake(0, toVC.view.bounds.height/2, toVC.view.bounds.width, toVC.view.bounds.height/2)
//        
//        let imageView = UIImageView(image: image)
//        imageView.frame = upRect
//        //位置
//        imageView.frame.origin.y -= imageView.frame.size.height
//        //形变
//        imageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
//        
//        toVC.view.addSubview(imageView)
//        
//        toVC.view.layer.opacity = 0
        

            
        let menuVC = toVC.viewControllers.first as! MenuVC
            
        menuVC.tableView.frame.origin.y += 100
        menuVC.logoImage.frame.origin.y -= 100

        let containerViews = transitionContext.containerView
        
        containerViews.addSubview(toVC.view)
        
            
        toVC.view.layer.opacity = 0.0
        
        
        //透明度动画
        UIView.animate(withDuration: 0.3, animations: {
                
                fromVC.frontView.layer.opacity = 0.0
                fromVC.menuButton.layer.opacity = 0.0
            
                toVC.view.layer.opacity = 1.0
                
        })


        //形变动画
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {

            
            fromVC.timeRadarView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            
            menuVC.tableView.frame.origin.y -= 100
            menuVC.logoImage.frame.origin.y += 100
            
            }) { (success) in
             
            self.isPresenting = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
           
    
            
        }
        else{
        
            
            print("Pop")
            
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! UINavigationController
            
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! HomeVC
            
            let menuVC = fromVC.viewControllers.first as! MenuVC

            //当番茄停止时可以更新计时器时间
//            //（写在这里比较方便）
//            if !Pomodoro.isfocusing {
//             
//            
//            }else{
//            
//                print(Pomodoro.isfocusing)
//            }
            
            
            
            
            UIView.animate(withDuration: 0.3, animations: { 
                
                toVC.frontView.layer.opacity = 1.0
                toVC.menuButton.layer.opacity = 1.0
                
                fromVC.view.layer.opacity = 0.0
            })
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                
           
                toVC.timeRadarView.transform = CGAffineTransform.identity
                
                menuVC.tableView.frame.origin.y += 100
                menuVC.logoImage.frame.origin.y -= 100
                
                
            }) { (success) in
                
                self.isPresenting = true
                
                menuVC.tableView.frame.origin.y -= 100
                menuVC.logoImage.frame.origin.y += 100
                
                transitionContext.completeTransition(true)
            }

            
        }
    }
}

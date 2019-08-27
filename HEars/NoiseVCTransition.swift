//
//  NoiseVCTransition.swift
//  HEars
//
//  Created by yantommy on 16/9/10.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class NoiseVCTransition: NSObject,UIViewControllerAnimatedTransitioning {

    
    var isPresenting = true
    
    var arrowUpButtonDistance:CGFloat = 0
    
    var arrowDownButtonDistance:CGFloat = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        if isPresenting {
            
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! HomeVC
            
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! NoiseVC
            
            let containerViews = transitionContext.containerView
            
            containerViews.addSubview(toVC.view)
            
            //相差位移
            let frontViewDistance = (fromVC.dateLabel.frame.origin.y - 22)
            
            self.arrowUpButtonDistance = (fromVC.arrowButton.frame.origin.y - fromVC.dateLabel.frame.origin.y)
    
            self.arrowDownButtonDistance = (fromVC.view.bounds.height - fromVC.arrowButton.frame.origin.y + toVC.arrowButton.frame.origin.y)
            
            //预备位置
            toVC.view.frame.origin.y = toVC.view.frame.height
            toVC.arrowButton.layer.opacity = 0.0
            
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
                
                
                fromVC.frontView.transform = CGAffineTransform(translationX: 0, y: -frontViewDistance)
                fromVC.timeRadarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                fromVC.timeRadarView.layer.opacity = 0
            

                fromVC.arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)).concatenating(CGAffineTransform(translationX: 0, y: -self.arrowUpButtonDistance))
                
                toVC.view.frame.origin.y = 0
                
                }, completion: { (success) in
                    
                    self.isPresenting = false
                    
                    toVC.arrowButton.layer.opacity = 1.0
                    fromVC.arrowButton.layer.opacity = 0.0

                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
            })

            
        
        }else{
        
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! NoiseVC
            
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! HomeVC

            toVC.arrowButton.layer.opacity = 0.0

            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
                
                
                toVC.frontView.transform = CGAffineTransform.identity
                toVC.timeRadarView.transform = CGAffineTransform.identity
                toVC.timeRadarView.layer.opacity = 1.0
                
                toVC.arrowButton.transform = CGAffineTransform.identity
                

                fromVC.arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI)).concatenating(CGAffineTransform(translationX: 0, y: -self.arrowDownButtonDistance))
                
                fromVC.view.frame.origin.y += fromVC.view.bounds.height
                
                }, completion: { (success) in
                  
                    self.isPresenting = true

                    toVC.arrowButton.layer.opacity = 1.0
                    fromVC.arrowButton.layer.opacity = 0.0
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

                })

            
        
        }
    }
}

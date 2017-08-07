//
//  UIButton+Extension.swift
//  Reader
//
//  Created by 张海南 on 2017/8/1.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit


extension UIButton {
    
    func addAnimation(durationTime: Double) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.isRemovedOnCompletion = true
        
        let animationZoomOut = CABasicAnimation(keyPath: "transform.scale")
        animationZoomOut.fromValue = 0
        animationZoomOut.toValue = 1.2
        animationZoomOut.duration = 3/4 * durationTime
        
        let animationZoomIn = CABasicAnimation(keyPath: "transform.scale")
        animationZoomIn.fromValue = 1.2
        animationZoomIn.toValue = 1.0
        animationZoomIn.beginTime = 3/4 * durationTime
        animationZoomIn.duration = 1/4 * durationTime
        
        groupAnimation.animations = [animationZoomOut, animationZoomIn]
        self.layer.add(groupAnimation, forKey: "addAnimation")
    }
}

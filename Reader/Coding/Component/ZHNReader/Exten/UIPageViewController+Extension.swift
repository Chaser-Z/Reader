//
//  UIPageViewController+Extension.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

/// key
private var IsGestureRecognizerEnabled = "IsGestureRecognizerEnabled"
private var TapIsGestureRecognizerEnabled = "TapIsGestureRecognizerEnabled"

import UIKit

extension UIPageViewController {
    
    /// 手势开关
    var gestureRecognizerEnabled:Bool {
        
        get{
            
            let obj = objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? NSNumber
            
            return  obj == nil ? true : obj!.boolValue
        }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue}
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Tap手势开关
    var tapGestureRecognizerEnabled:Bool {
        
        get{
            
            let obj = objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? NSNumber
            
            return  obj == nil ? true : obj!.boolValue
        }
        
        set{
            
            for ges in gestureRecognizers {
                
                if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                    
                    ges.isEnabled = newValue
                }
            }
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

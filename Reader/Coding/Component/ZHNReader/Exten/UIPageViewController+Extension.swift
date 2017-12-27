//
//  UIPageViewController+Extension.swift
//  Reader
//
//  Created by 张海南 on 2017/12/27.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

/// key
private var IsGestureRecognizerEnabled = "IsGestureRecognizerEnabled"
private var TapIsGestureRecognizerEnabled = "TapIsGestureRecognizerEnabled"

extension UIPageViewController {
    
    /// 手势开关
    var gestureRecognizerEnabled:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? Bool) ?? true
        }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue }
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Tap手势开关
    var tapGestureRecognizerEnabled:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? Bool) ?? true
        }
        
        set{
            
            for ges in gestureRecognizers {
                
                if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                    
                    ges.isEnabled = newValue
                }
            }
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

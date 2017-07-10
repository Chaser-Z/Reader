//
//  UIView+Toast.swift
//  FileDownLoadDemo
//
//  Created by yeeaoo on 15/9/16.
//  Copyright (c) 2015年 ZHN. All rights reserved.
//

import Foundation
import UIKit

enum TOAST_POSTION{
    
    case top
    case middle
    case bottom
    
}
enum TOAST_TYPE{
    
    case white_FONT
    case black_FONT
}

let DURING: TimeInterval = 1.5
let TFONT_SIZE: CGFloat = 14.0
let ANIMATION_TIME: TimeInterval = 0.1

extension UIView {
    
    func loadTransform3D(_ z: CGFloat) -> CATransform3D
    {
        var scale: CATransform3D = CATransform3DIdentity
        scale.m34 = -1.0 / 1000.0
        let transform: CATransform3D = CATransform3DMakeTranslation(0.0, 0.0, z)
        return CATransform3DConcat(transform, scale)
        
    }
    func toast(_ msg: String)
    {
        self.toast(msg, during: DURING)
    }
    func toast(_ msg: String, postion: TOAST_POSTION)
    {
        self.toast(msg, during: DURING, postion: postion)
    }
    func toast(_ msg: String, type: TOAST_TYPE)
    {
        self.toast(msg, during: DURING, postion: TOAST_POSTION.bottom, type: type)
    }
    func toast(_ msg: String, postion: TOAST_POSTION, type: TOAST_TYPE)
    {
        self.toast(msg, during: DURING, postion: postion, type: type)
    }
    func toast(_ msg: String, during: TimeInterval)
    {
        self.toast(msg, during: DURING, postion: TOAST_POSTION.bottom)
    }
    func toast(_ msg: String, during: TimeInterval, postion: TOAST_POSTION)
    {
        self.toast(msg, during: DURING, postion: postion, type: TOAST_TYPE.white_FONT)
    }
    func toast(_ msg: String, during: TimeInterval, postion: TOAST_POSTION,type: TOAST_TYPE)
    {
        self.createContentLabWithMessage(msg, during: during, postion: postion, type: type)
    }
    func createContentLabWithMessage(_ msg: String, during: TimeInterval, postion: TOAST_POSTION, type: TOAST_TYPE) -> UILabel
    {
        
        self.isUserInteractionEnabled = false
        let screenSize = UIScreen.main.bounds.size
        var contentLabY: CGFloat = 0
        let fontColor: UIColor!
        let _: UIColor!
        
        switch postion{
            
        case TOAST_POSTION.top:
            contentLabY = 100
            break
        case TOAST_POSTION.middle:
            contentLabY = screenSize.height / 2
            break
        case .bottom:
            contentLabY = screenSize.height - 100
            break
            
        }
        switch type{
            
        case .white_FONT:
            fontColor = UIColor.white
            _ = UIColor.black
            break
        case .black_FONT:
            fontColor = UIColor.black
            _ = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
            break
            
        }
        
        let pading: CGFloat = 10.0
        
        
        let msgSize: CGSize = (msg as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: TFONT_SIZE)])
        var contentLabWidth: CGFloat = msgSize.width + pading * 2.0
        let multiple: NSInteger = NSInteger(msgSize.width / (screenSize.width - pading * 2.0)) + 1
        if multiple > 1
        {
            contentLabWidth = screenSize.width - pading * 2.0
        }
        let contentLab = UILabel(frame: CGRect(x: (screenSize.width - contentLabWidth) / 2.0, y: contentLabY, width: contentLabWidth, height: CGFloat(multiple) * msgSize.height + pading))
        contentLab.numberOfLines = 0
        contentLab.backgroundColor = UIColor.black
        contentLab.textColor = fontColor
        contentLab.font = UIFont.systemFont(ofSize: TFONT_SIZE)
        contentLab.textAlignment = NSTextAlignment.center
        contentLab.center = CGPoint(x: screenSize.width / 2.0, y: contentLabY)
        contentLab.text = msg
        contentLab.layer.cornerRadius = 8.0
        contentLab.layer.masksToBounds = true
        contentLab.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.addSubview(contentLab)
        
        UIView.animate(withDuration: ANIMATION_TIME, animations: { () -> Void in
            
            contentLab.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            
        }, completion: { (finished) -> Void in
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                contentLab.transform = CGAffineTransform.identity
            }, completion: { (finished) -> Void in
                
                Timer.scheduledTimer(timeInterval: during, target: self, selector: #selector(UIView.clearContentLab(_:)), userInfo: contentLab, repeats: false)
            })
            
        }) 

        
        return contentLab
        
    }
    func clearContentLab(_ timer: Timer)
    {
       let contentLab =  timer.userInfo as! UILabel
        
        
        UIView.animate(withDuration: ANIMATION_TIME, animations: { () -> Void in
            
            contentLab.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }, completion: { (finished) -> Void in
            
            contentLab.removeFromSuperview()
            self.isUserInteractionEnabled = true
        }) 
        
    }

    
    
    
    
    
    
    
    
    
}




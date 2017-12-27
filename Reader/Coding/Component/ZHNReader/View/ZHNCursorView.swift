//
//  ZHNCursorView.swift
//  Reader
//
//  Created by 张海南 on 2017/12/27.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNCursorView: UIView {

    /// 光标圆圈显示位置: true -> 圆圈在上面 , false -> 圆圈在下面
    var isTorB:Bool = true {
        
        didSet{ setNeedsDisplay() }
    }
    
    /// 光标颜色
    var color:UIColor = UIColor(red:0.20, green:0.44, blue:0.85, alpha:1.00) {
        
        didSet{ setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        color.set()
        
        let rectW:CGFloat = bounds.width / 2
        
        ctx?.addRect(CGRect(x: (bounds.width - rectW) / 2, y: (isTorB ? 1 : 0), width: rectW, height: bounds.height - 1))
        
        ctx?.fillPath()
        
        if isTorB {
            
            ctx?.addEllipse(in: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width))
            
        }else{
            
            ctx?.addEllipse(in: CGRect(x: 0, y: bounds.height - bounds.width, width: bounds.width, height: bounds.width))
        }
        
        color.set()
        
        
        ctx?.fillPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}

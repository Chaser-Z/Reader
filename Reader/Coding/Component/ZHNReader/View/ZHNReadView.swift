//
//  ZHNReadView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNReadView: UIView {

    /// 内容
    var content:String? {
        
        didSet{
            
            if content != nil && !content!.isEmpty {
                
                frameRef = ZHNReadParser.GetReadFrameRef(content: content!, attrs: ZHNReadConfigure.shared().readAttribute(), rect: GetReadViewFrame())
            }
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        
        didSet{
            
            if frameRef != nil {
                
                setNeedsDisplay()
            }
        }
    }
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height);
        
        ctx?.scaleBy(x: 1.0, y: -1.0);
        
        CTFrameDraw(frameRef!, ctx!);
    }

}

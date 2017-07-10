//
//  ZHNCoverView.swift
//  Reader
//
//  Created by 张海南 on 2017/7/10.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNCoverView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchBeginPoint = ((touches as NSSet).anyObject() as AnyObject).location(in: self)
        NOVELLog(touchBeginPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchBeginPoint = ((touches as NSSet).anyObject() as AnyObject).location(in: self)
        NOVELLog(touchBeginPoint)
        
    }
    

}

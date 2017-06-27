//
//  ZHNTopView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/26.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNTopView: ZHNBaseView {

    /// 返回按钮
    private(set) var back:UIButton!
    
    /// 书签
    private(set) var mark:UIButton!
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 返回
        back = UIButton(type:.custom)
        back.setImage(UIImage(named:"G_Back_0"), for: .normal)
        addSubview(back)
        
        // 书签
        mark = UIButton(type:.custom)
        mark.contentMode = .center
        mark.setImage(UIImage(named:"RM_17"), for: .normal)
        mark.setImage(UIImage(named:"RM_18"), for: .selected)
        mark.addTarget(self, action: #selector(ZHNTopView.clickMark(button:)), for: .touchUpInside)
        //addSubview(mark)
    }
    
    @objc private func clickMark(button:UIButton) {
        
        readMenu.delegate?.readMenuClickMarkButton?(readMenu: readMenu, button: button)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 按钮宽
        let buttonW:CGFloat = 50
        
        // 返回按钮
        back.frame = CGRect(x: 0, y: StatusBarHeight, width: buttonW, height: height - StatusBarHeight)
        
        // 书签按钮
        mark.frame = CGRect(x: width - buttonW, y: StatusBarHeight, width: buttonW, height: height - StatusBarHeight)
    }

    
    
}

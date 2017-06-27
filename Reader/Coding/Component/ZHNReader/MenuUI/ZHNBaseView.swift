//
//  ZHNBaseView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/26.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNBaseView: UIControl {

    
    /// 菜单
    weak var readMenu: ZHNReadMenu!
    
    /// 初始化方法
    convenience init(readMenu: ZHNReadMenu) {
        
        self.init(frame:CGRect.zero,readMenu:readMenu)
    }
    
    /// 初始化方法
    init(frame:CGRect,readMenu: ZHNReadMenu) {
        
        self.readMenu = readMenu
        
        super.init(frame: frame)
        
        addSubviews()
    }

    
    /// 初始化方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 添加子控件
    func addSubviews() {
        
        backgroundColor = MenuUIColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

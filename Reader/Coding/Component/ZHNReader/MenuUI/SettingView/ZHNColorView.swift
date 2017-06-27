//
//  ZHNColorView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/27.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNColorView: ZHNBaseView {

    /// 颜色数组
    private(set) var colors:[UIColor] = []
    
    /// 选中索引
    private(set) var selectIndex:NSInteger = 0
    
    /// 初始化方法
    init(frame:CGRect,readMenu: ZHNReadMenu,colors:[UIColor],selectIndex:NSInteger) {
        
        self.colors = colors
        
        self.selectIndex = selectIndex
        
        super.init(frame: frame, readMenu: readMenu)
    }
    
    //    // MARK: -- 无抖动效果
    //
    //    /// 选中按钮
    //    private var selectButton:UIButton?
    //
    //    override func addSubviews() {
    //
    //        // 创建颜色按钮
    //        let count = colors.count
    //
    //        // 设置的index大于颜色数组
    //        if selectIndex >= count {selectIndex = 0}
    //
    //        let PublicButtonWH:CGFloat = 40
    //
    //        let spaceW:CGFloat = (ScreenWidth - 2 * DZMSpace_1 - CGFloat(count) * PublicButtonWH) / CGFloat(count - 1)
    //
    //        for i in 0..<count {
    //
    //            let color = colors[i]
    //
    //            let publicButton = UIButton(frame:CGRect(x: DZMSpace_1 + CGFloat(i) * (PublicButtonWH + spaceW), y: DZMSpace_1, width: PublicButtonWH, height: PublicButtonWH))
    //
    //            publicButton.tag = i
    //
    //            publicButton.layer.cornerRadius = PublicButtonWH / 2
    //
    //            publicButton.backgroundColor = color
    //
    //            addSubview(publicButton)
    //
    //            publicButton.addTarget(self, action: #selector(DZMRMColorView.clickButton(button:)), for: .touchUpInside)
    //
    //            if selectIndex == i {
    //
    //                selectButton(button: publicButton)
    //            }
    //        }
    //
    //    }
    //
    //    /// 点击按钮
    //    func clickButton(button:UIButton) {
    //
    //        selectButton(button: button)
    //
    //        readMenu.delegate?.readMenuClickSetuptColor?(readMenu: readMenu, index: button.tag, color: colors[button.tag])
    //    }
    //
    //    /// 选中按钮
    //    private func selectButton(button:UIButton) {
    //
    //        selectButton?.layer.borderColor = UIColor.clear.cgColor
    //        selectButton?.layer.borderWidth = 0
    //
    //        button.layer.borderColor = DZMColor_2.cgColor
    //        button.layer.borderWidth = 2.0
    //
    //        selectButton = button
    //    }
    
    
    // MARK: -- 有抖动效果
    
    /// 选中按钮
    private var selectButton: ZHNHaloButton?
    
    override func addSubviews() {
        
        // 创建颜色按钮
        let count = colors.count
        
        // 设置的index大于颜色数组
        if selectIndex >= count {selectIndex = 0}
        
        let PublicButtonWH:CGFloat = ZHNHaloButton.HaloButtonSize(CGSize(width: 39, height: 39)).width
        
        let spaceW:CGFloat = (ScreenWidth - 2 * Space_1 - CGFloat(count) * PublicButtonWH) / CGFloat(count - 1)
        
        for i in 0..<count {
            
            let color = colors[i]
            
            let publicButton = ZHNHaloButton(CGRect(x: Space_1 + CGFloat(i) * (PublicButtonWH + spaceW), y: Space_1, width: PublicButtonWH, height: PublicButtonWH), haloColor:color)
            
            publicButton.tag = i
            
            publicButton.imageView.backgroundColor = color
            
            addSubview(publicButton)
            
            publicButton.addTarget(self, action: #selector(ZHNColorView.clickButton(button:)), for: .touchUpInside)
            
            if selectIndex == i {
                
                selectButton(button: publicButton)
            }
        }
        
    }
    
    /// 点击按钮
    func clickButton(button:ZHNHaloButton) {
        
        selectButton(button: button)
        
        readMenu.delegate?.readMenuClickSetuptColor?(readMenu: readMenu, index: button.tag, color: colors[button.tag])
    }
    
    /// 选中按钮
    private func selectButton(button:ZHNHaloButton) {
        
        selectButton?.imageView.layer.borderColor = UIColor.clear.cgColor
        selectButton?.imageView.layer.borderWidth = 0
        
        button.imageView.layer.borderColor = Color_2.cgColor
        button.imageView.layer.borderWidth = 2.0
        
        selectButton = button
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }


}

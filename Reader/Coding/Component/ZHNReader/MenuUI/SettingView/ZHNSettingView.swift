//
//  ZHNSettingView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/27.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNSettingView: ZHNBaseView {

    /// 颜色
    private(set) var colorView: ZHNColorView!
    
    /// 翻页效果
    private(set) var effectView: ZHNFuncView!
    
    /// 字体
    private(set) var fontView: ZHNFuncView!
    
    /// 字体大小
    private(set) var fontSizeView: ZHNFuncView!
    
    /// 添加控件
    override func addSubviews() {
        
        super.addSubviews()
        
        // 颜色
        colorView = ZHNColorView(frame:CGRect(x: 0, y: 0, width: ScreenWidth, height: 74),readMenu:readMenu,colors:ReadBGColors,selectIndex: ZHNReadConfigure.shared().colorIndex)
        addSubview(colorView)
        
        // funcViewH
        let funcViewH:CGFloat = (height - colorView.height) / 3
        
        // 翻页效果 labels 排放顺序参照 DZMRMNovelEffectType
        effectView = ZHNFuncView(frame:CGRect(x: 0, y: colorView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .effect, title:"翻书动画", labels:["无效果","平移","仿真","上下"], selectIndex: ZHNReadConfigure.shared().effectType)
        addSubview(effectView)
        
        // 字体 labels 排放顺序参照 DZMRMNovelFontType
        fontView = ZHNFuncView(frame:CGRect(x: 0, y: effectView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .font, title:"字体", labels:["系统","黑体","楷体","宋体"], selectIndex: ZHNReadConfigure.shared().fontType)
        addSubview(fontView)
        
        // 字体大小
        fontSizeView = ZHNFuncView(frame:CGRect(x: 0, y: fontView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .fontSize, title:"字号")
        addSubview(fontSizeView)
    }
    


}

//
//  GlobalProperty.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 屏幕属性
/// 屏幕宽度
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

/// 导航栏高度
let NavgationBarHeight:CGFloat = 64

/// TabBar高度
let TabBarHeight:CGFloat = 49

/// StatusBar高度
let StatusBarHeight:CGFloat = 20


// MARK: -- 颜色支持

/// 灰色
let Color_1:UIColor = RGB(51, g: 51, b: 51)

/// 粉红色
let Color_2:UIColor = RGB(253, g: 85, b: 103)

/// 阅读上下状态栏颜色
let Color_3:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读上下状态栏字体颜色
let Color_4:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读颜色
let Color_5:UIColor = RGB(145, g: 145, b: 145)

/// LeftView文字颜色
let Color_6:UIColor = RGB(200, g: 200, b: 200)


/// 阅读背景颜色支持
let ReadBGColor_1:UIColor = RGB(238, g: 224, b: 202)
let ReadBGColor_2:UIColor = RGB(205, g: 239, b: 205)
let ReadBGColor_3:UIColor = RGB(206, g: 233, b: 241)
let ReadBGColor_4:UIColor = RGB(251, g: 237, b: 199)  // 牛皮黄
let ReadBGColor_5:UIColor = RGB(51, g: 51, b: 51)

/// 菜单背景颜色
let MenuUIColor:UIColor = UIColor.black.withAlphaComponent(0.85)

// MARK: -- 字体支持
let Font_10:UIFont = UIFont.systemFont(ofSize: 10)
let Font_12:UIFont = UIFont.systemFont(ofSize: 12)
let Font_18:UIFont = UIFont.systemFont(ofSize: 18)


// MARK: -- 间距支持
let Space_1:CGFloat = 15
let Space_2:CGFloat = 25
let Space_3:CGFloat = 1
let Space_4:CGFloat = 10
let Space_5:CGFloat = 20
let Space_6:CGFloat = 5


// MARK: -- Key
/// 是夜间还是日间模式   true:夜间 false:日间
let Key_IsNighOrtDay:String = "isNightOrDay"

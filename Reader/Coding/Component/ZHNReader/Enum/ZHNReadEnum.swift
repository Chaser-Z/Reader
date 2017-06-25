//
//  ZHNReadEnum.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

/// 翻页类型
enum ZHNEffectType:NSInteger {
    case none               // 无效果
    case translation        // 平移
    case simulation         // 仿真
    case upAndDown          // 上下
}

/// 字体类型
enum ZHNFontType:NSInteger {
    case system             // 系统
    case one                // 黑体
    case two                // 楷体
    case three              // 宋体
}

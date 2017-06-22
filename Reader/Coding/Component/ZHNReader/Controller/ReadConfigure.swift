//
//  ReadConfigure.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

/// key
let ReadConfigureKey:String = "ReadConfigure"

/// 单利对象
private var instance:ReadConfigure? = ReadConfigure.readInfo()

// MARK: -- 配置属性

/// 背景颜色数组
let ReadBGColors:[UIColor] = [UIColor.white,ReadBGColor_1,ReadBGColor_2,ReadBGColor_3,ReadBGColor_4,ReadBGColor_5]

/// 根据背景颜色 对应的文字颜色 数组(数量必须与 ReadBGColors 相同)
// let ReadTextColors:[UIColor] = [Color_5,Color_5,Color_5,Color_5,Color_5,Color_5]

/// 阅读最小阅读字体大小
let ReadMinFontSize:NSInteger = 12

/// 阅读最大阅读字体大小
let ReadMaxFontSize:NSInteger = 25

/// 阅读当前默认字体大小
let ReadDefaultFontSize:NSInteger = 14

import UIKit

class ReadConfigure: NSObject {
    
    // MARK: -- 属性
    
    /// 当前阅读的背景颜色
    var colorIndex:NSInteger = 0 {didSet{save()}}
    
    /// 字体类型
    var fontType:NSInteger = RMFontType.system.rawValue {didSet{save()}}
    
    /// 字体大小
    var fontSize:NSInteger = ReadDefaultFontSize {didSet{save()}}
    
    /// 翻页效果
    var effectType:NSInteger = RMEffectType.simulation.rawValue {didSet{save()}}
    
    /// 阅读文字颜色(更加需求自己选)
    var textColor:UIColor {
        
        // 固定颜色使用
        get{return Color_5}
        
        
        // 根据背影颜色选择字体颜色(假如想要根据背景颜色切换字体颜色 需要在 configureBGColor() 方法里面调用 tableView.reloadData())
        //        get{return ReadTextColors[colorIndex]}
        
        
        // 日夜间区分颜色使用 (假如想要根据日夜间切换字体颜色 需要调用 tableView.reloadData() 或者取巧 使用上面的方式)
        //        get{
        //
        //            if UserDefaults.boolForKey(Key_IsNighOrtDay) { // 夜间
        //
        //                return Color_5
        //
        //            }else{ // 日间
        //
        //                return Color_5
        //            }
        //        }
    }
    
    // MARK: -- 操作
    
    /// 单例
    class func shared() ->ReadConfigure {
        
        if instance == nil {
            
            instance = ReadConfigure.readInfo()
        }
        
        return instance!
    }
    
    /// 保存
    func save() {
        
        var dict = allPropertys()
        
        dict.removeValue(forKey: "lineSpacing")
        
        dict.removeValue(forKey: "textColor")
        
        MyUserDefaults.setObject(dict, key: ReadConfigureKey)
    }
    
    /// 清理(暂无需求使用)
    private func clear() {
        
        instance = nil
        
        MyUserDefaults.removeObjectForKey(ReadConfigureKey)
    }
    
    /// 获得文字属性字典
    func readAttribute() ->[String:NSObject] {
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 行间距
        paragraphStyle.lineSpacing = Space_4
        
        // 段间距
        paragraphStyle.paragraphSpacing = Space_6
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = 1.0
        
        // 对其
        paragraphStyle.alignment = NSTextAlignment.justified
        
        // 返回
        return [NSForegroundColorAttributeName:textColor,NSFontAttributeName:readFont(),NSParagraphStyleAttributeName:paragraphStyle]
    }
    
    /// 获得颜色
    func readColor() ->UIColor {
        
        if colorIndex == ReadBGColors.index(of: ReadBGColor_4) { // 牛皮黄
            
            return UIColor(patternImage:UIImage(named: "read_bg_0")!)
            
        }else{
            
            return ReadBGColors[colorIndex]
        }
    }
    
    /// 获得文字Font
    func readFont() ->UIFont {
        
        if fontType == RMFontType.one.rawValue { // 黑体
            
            return UIFont(name: "EuphemiaUCAS-Italic", size: CGFloat(fontSize))!
            
        }else if fontType == RMFontType.two.rawValue { // 楷体
            
            return UIFont(name: "AmericanTypewriter-Light", size: CGFloat(fontSize))!
            
        }else if fontType == RMFontType.three.rawValue { // 宋体
            
            return UIFont(name: "Papyrus", size: CGFloat(fontSize))!
            
        }else{ // 系统
            
            return UIFont.systemFont(ofSize: CGFloat(fontSize))
        }
    }
    
    // MARK: -- 构造初始化
    
    /// 创建获取内存中的用户信息
    class func readInfo() ->ReadConfigure {
        
        let info = MyUserDefaults.objectForKey(ReadConfigureKey)
        
        return ReadConfigure(dict:info)
    }
    
    /// 初始化
    private init(dict:Any?) {
        
        super.init()
        
        setData(dict: dict)
    }
    
    /// 更新设置数据
    private func setData(dict:Any?) {
        
        if dict != nil {
            
            setValuesForKeys(dict as! [String : AnyObject])
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

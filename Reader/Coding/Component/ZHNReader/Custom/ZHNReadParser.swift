//
//  ZHNReadParser.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNReadParser  {

    open static let shared = ZHNReadParser()
    
    /// 文章章节
    var chapters = [Chapter]()
    
    /// 文字章节内容
    var content: String? {
        didSet{
            updateFont()
        }
    }
    
    /// 文章有多少页
    var pageCount: Int = 0
    
    /// 每一页的Range数组
    var rangeArray:[NSRange] = []
    
    /// 记录该章使用的字体属性
    private var readAttribute:[String:NSObject] = [:]

    
//    // MARK: - 初始化
//    init(content: String) {
//        super.init()
//        self.content = content
//        self.updateFont()
//    }
    
    
    
    // MARK: - 解析文字内容,获取页数和rang数组
    
    /// 更新字体
    func updateFont(isSave:Bool = false) {
        
        let readAttribute = ZHNReadConfigure.shared().readAttribute()
        
//        if self.readAttribute != readAttribute {
        
            self.readAttribute = readAttribute
            
            rangeArray = ZHNReadParser.ParserPageRange(string: content!, rect: GetReadViewFrame(), attrs: readAttribute)
            NOVELLog(rangeArray.count)
            pageCount = rangeArray.count
            
            if isSave {
                //save()
            }
        //}
    }
    
    /// 通过page获得字符串
    func string(page: Int) -> String {
        
        return content?.substring(rangeArray[page]) ?? ""
    }
    
    /// 通过 Location 获得 Page
    func page(location:NSInteger) -> Int {
    
        let count = rangeArray.count
        
        for i in 0..<count {
            
            let range = rangeArray[i]
            
            if location < (range.location + range.length) {
                
                return i
            }
        }
        
        return 0
    }

    // MARK: -- 内容分页
    
    /**
     内容分页
     
     - parameter string: 内容
     
     - parameter rect: 范围
     
     - parameter attrs: 文字属性
     
     - returns: 每一页的起始位置数组
     */
    class func ParserPageRange(string:String, rect:CGRect, attrs:[String : Any]?) ->[NSRange] {
        
        // 记录
        var rangeArray:[NSRange] = []
        
        // 拼接字符串
        let attrString = NSMutableAttributedString(string: string, attributes: attrs)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        
        return rangeArray
    }

    
    // MARK: - 获得 FrameRef CTFrame
    
    /// 获得 CTFrame
    class func GetReadFrameRef(content:String, attrs:[String : Any]?, rect:CGRect) ->CTFrame {
        
        let attributedString = NSMutableAttributedString(string: content,attributes: attrs)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        return frameRef
    }

}

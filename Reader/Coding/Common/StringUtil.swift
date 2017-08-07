//
//  StringUtil.swift
//  Reader
//
//  Created by 张海南 on 2017/8/7.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit


class StringUtil {

    

    class func attributeStringFromString(string: String, alignment: NSTextAlignment, color: UIColor, lineSpacing: CGFloat, fontSize: CGFloat, fontWeight: CGFloat = UIFontWeightLight) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, string.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, string.characters.count))
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        attributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, string.characters.count))
        return attributedString
    }


    class func attributeStringFromString(string: String?, subString: String?, color: UIColor, alignment: NSTextAlignment, lineSpacing: CGFloat, font: UIFont) -> NSMutableAttributedString {
        if let string = string, let subString = subString {
            let myMutableString = NSMutableAttributedString(string: string)
            let ranges = rangesOfString(string: string as NSString, subString: subString)
            for range in ranges {
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = alignment
            paragraphStyle.lineBreakMode = .byTruncatingTail
            myMutableString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, string.characters.count))
            
            myMutableString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, string.characters.count))
            return myMutableString
        }
        return NSMutableAttributedString()
    }

    class func rangesOfString(string: NSString, subString: String) -> [NSRange] {
        var ranges = [NSRange]()
        
        var searchRange = NSMakeRange(0, string.length)
        while (searchRange.location < string.length) {
            searchRange.length = string.length - searchRange.location
            let foundRange = string.range(of: subString, options: .literal, range: searchRange)
            
            if foundRange.location != NSNotFound {
                searchRange.location = foundRange.location + foundRange.length
            } else {
                break
            }
            
            ranges.append(foundRange)
        }
        
        return ranges
    }


}

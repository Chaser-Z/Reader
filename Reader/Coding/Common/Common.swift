//
//  Common.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

// MARK: - Custom Logging

func NOVELLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))- \(message)")
    #endif
}

// MARK: - Color
let DefaultColor = RGBA(35.0, 205.0, 253.0)
let ReverseColor = RGBA(253.0, 153.0, 107.0)

func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func HexColor(netHex: Int) -> UIColor {
    return RGBA(CGFloat((netHex >> 16) & 0xff), CGFloat((netHex >> 8) & 0xff), CGFloat(netHex & 0xff))
}


// MARK: - Inch
func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

// 5,5s,SE
func is4InchPhone() -> Bool {
    if isPhone() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if screenWidth <= 320.0 {
            return true
        }
    }
    
    return false
}

// 6，6s,7,7s
func is4_7InchPhone() -> Bool {
    
    if isPhone() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if screenWidth <= 375.0 && screenWidth > 320.0{
            return true
        }
    }
    return false
}

// 6p,7p
func is5_5InchPhone() -> Bool {
    if isPhone() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if screenWidth <= 414.0 && screenWidth > 375.0{
            return true
        }
    }
    return false
}

func is129InchPad() -> Bool {
    if !isPhone() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if screenWidth >= 1024 {
            return true
        }
    }
    
    return false
}

func isPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

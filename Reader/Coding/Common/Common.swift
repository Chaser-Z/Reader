//
//  Common.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import MBProgressHUD

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



// MARK: - Show HUD

func showMessage(_ message: String, errorCode: Int? = nil, onView view: UIView?) {
    if let view = view {
        if let hud = MBProgressHUD.showAdded(to: view, animated: true) {
            hud.mode = .text
            
            if let code = errorCode {
                let text = "\(message)：\(code)"
                
                if isPhone() {
                    hud.detailsLabelText = text
                } else {
                    hud.labelText = text
                }
            } else {
                if isPhone() {
                    hud.detailsLabelText = message
                } else {
                    hud.labelText = message
                }
            }
            
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1.2)
        }
    }
}

// MARK: - Internet connection

func isInternetReachable() -> Bool {
    let reach = Reachability()
    if let isReachable = reach?.isReachable {
        return isReachable
    }
    
    return false
}

func isWifiReachable() -> Bool {
    let reach = Reachability()
    if let isReachable = reach?.isReachableViaWiFi {
        return isReachable
    }
    
    return false
}

// MARK: - Text Field & Text View

func textOfTextField(_ textField: UITextField) -> String? {
    if let text = textField.text, text.characters.count > 0 {
        return text
    }
    
    return nil
}

func textOfTextView(_ textView: UITextView) -> String? {
    if let text = textView.text, text.characters.count > 0 {
        return text
    }
    
    return nil
}

// MARK: - Validate email

func validateEmail(_ email: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, email.characters.count)) != nil
    } catch {
        return false
    }
}

func validateGender(_ input: String?) -> Int32 {
    guard let input = input else {
        return 0 // Unknown
    }
    
    if input == "男" {
        return 1
    } else if input == "女" {
        return 2
    }
    
    return 0
}

// MARK: - MD5

func md5(_ input: String) -> String {
    let cString = input.cString(using: String.Encoding.utf8)
    let length = CUnsignedInt(input.lengthOfBytes(using: String.Encoding.utf8))
    let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
    
    CC_MD5(cString!, length, result)
    
    return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                  result[0], result[1], result[2], result[3],
                  result[4], result[5], result[6], result[7],
                  result[8], result[9], result[10], result[11],
                  result[12], result[13], result[14], result[15])
}


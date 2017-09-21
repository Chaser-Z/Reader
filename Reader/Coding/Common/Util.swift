//
//  Util.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class Util {
    
    class func getWindowWidth() -> CGFloat {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.window!.frame.width
    }
    
    class func getWindowCenter() -> CGPoint {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.window!.center
    }
    
    class func getDeviceInfo() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        let device = UIDevice.current
        let osType = device.systemName
        let brand = "Apple"
        let model = device.model
        let sdkVersion = "\(device.systemName) \(device.systemVersion)"
        let releaseVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        let uniqueId = device.identifierForVendor?.uuidString ?? ""
        
        dict["osType"] = osType as AnyObject
        dict["brand"] = brand as AnyObject
        dict["model"] = model as AnyObject
        dict["sdkVersion"] = sdkVersion as AnyObject
        dict["releaseVersion"] = releaseVersion as AnyObject
        dict["uniqueId"] = uniqueId as AnyObject
        
        return dict
    }
    
    class func getDeviceToken() -> String? {
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "deviceToken") as? String
        return token
    }
    
    class func showAlert(title: String?,
                         message: String?,
                         parentController: UIViewController?,
                         completion: (() -> Void)? = nil,
                         closed: (() -> Void)? = nil) {
        
        if let controller = parentController {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "关闭", style: .cancel) { (action) -> Void in
                closed?()
            })
            
            controller.present(alertController, animated: true, completion: completion)
        }
    }
    
    class func showOptionAlert(title: String?,
                               message: String?,
                               parentController: UIViewController?,
                               confirmed: (() -> Void)? = nil,
                               cancelled: (() -> Void)? = nil,
                               completed: (() -> Void)? = nil) {
        if let controller = parentController {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
                cancelled?()
            }
            
            let confirmAction = UIAlertAction(title: "确定", style: .default) { action in
                confirmed?()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            controller.present(alertController, animated: true, completion: completed)
        }
    }
    
    class func callNumber(phone: String) {
        DispatchQueue.main.async() {
            if let url = URL(string: "tel://\(phone)") {
                let application = UIApplication.shared
                if application.canOpenURL(url) {
                    application.openURL(url)
                }
            }
        }
    }
    
    class func stringFromList<T: CustomStringConvertible>(list: [T]) -> String {
        if list.count == 0 {
            return ""
        }
        
        var str = list.reduce("") { "\($0)\($1)," }
        if str.characters.count > 0 {
            if str.characters.last! == "," {
                str = str.substring(to: str.endIndex)
            }
        }
        
        return str
    }
    
    class func int64ListFromString(str: String) -> [Int64] {
        let items = str.components(separatedBy: ",")
        return items.map { Int64($0)! }
    }
    
    class func setBadgeNumberForMyTab(number: Int?) {
        setBadgeNumber(number: number, forTabIndex: 3)
    }
    
    class func setBadgeNumber(number: Int?, forTabIndex tabIndex: Int) {
        DispatchQueue.main.async() {
            if let tabController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
                if let item = tabController.tabBar.items?[tabIndex] {
                    if let num = number {
                        if num > 0 {
                            item.badgeValue = "\(num)"
                        } else {
                            item.badgeValue = nil
                        }
                    } else {
                        item.badgeValue = nil
                    }
                }
            }
        }
    }
}


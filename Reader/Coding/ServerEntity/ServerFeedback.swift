//
//  ServerFeedback.swift
//  Reader
//
//  Created by 张海南 on 2017/8/3.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation


class ServerFeedback {
    
    var userId: String?
    var email: String?
    var name: String?
    var phone: String?
    var qq: String?
    var wechat: String?
    var content: String?
    var createTime: Int64 = 0
    
    init(userId: String?, email: String?, name: String?, content: String?) {
        self.userId = userId
        self.email = email
        self.name = name
        self.content = content
        self.createTime = Int64(Date().timeIntervalSince1970)
    }
    
}

extension ServerFeedback {
    
    func toDict() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if let userId = userId {
            dict["userId"] = userId as AnyObject
        }
        
        if let email = email {
            dict["email"] = email as AnyObject
        }
        
        if let name = name {
            dict["name"] = name as AnyObject
        }
        
        if let phone = phone {
            dict["phone"] = phone as AnyObject
        }
        
        if let qq = qq {
            dict["qq"] = qq as AnyObject
        }
        
        if let wechat = wechat {
            dict["wechat"] = wechat as AnyObject
        }
        
        if let content = content {
            dict["content"] = content as AnyObject
        }
        
        dict["createTime"] = createTime as AnyObject
        
        return dict
    }
    
}


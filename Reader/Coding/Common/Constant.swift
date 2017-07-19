//
//  Constant.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

//let HOST = "http://47.94.86.211:8080/novel/"
let HOST = "http://localhost:9090"
//let HOST = "http://localhost:9091"
//let HOST = "http://192.168.6.177:8090"


let kSeparatorViewH: CGFloat = 0.5


// MARK: - Notification

let kUserLoginNotificationName = Notification.Name("UserLoginNotificationName")


// MARK: - ShareSDK

let kShareSDKAppKey = "1f8c0134f6651"

// Wechat Login
let kWeChatAppId = "wx857fd6c5b3995a87"
let kWeChatAppSecret = "e8bb16bd7eb50cc53275cfcacb743c87"

// QQ Login
let kQQAppId = "101376383"
let kQQAppKey = "fad7c765e3662a8925a892850a1a5598"

// Weibo
let kWeiboAppKey = "745622145"
let kWeiboAppSecret = "4504b37688015e9d1226010e4039980f"
let kWeiboReturnUri = "http://www.sharesdk.cn"

// MARK: - User Identity Type

let kIdentityTypeEmail    = "email"
let kIdentityTypeWechat   = "wechat"
let kIdentityTypeQQ       = "qq"
let kIdentityTypeWeibo    = "weibo"
let kIdentityTypeFacebook = "facebook"
let kIdentityTypeTwitter  = "twitter"

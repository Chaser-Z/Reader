//
//  Constant.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

//let HOST = "http://47.94.86.211:8080/novel/"
//let HOST = "http://192.168.1.104:9090"
//let HOST = "http://localhost:9091"
//let HOST = "http://192.168.6.177:8090"
//let HOST = "http://47.94.86.211:8080/new_novel/"
let HOST = "http://47.94.86.211:8080/read_novel/"

let kSeparatorViewH: CGFloat = 0.5


// MARK: - Notification

let kUserLoginNotificationName = Notification.Name("UserLoginNotificationName")
let bookShelfNotificationName = Notification.Name("BookShelfNotificationName")
let kUserLogoutNotificationName = Notification.Name("UserLogoutNotificationName")
let kUserInfoUpdateNotificationName = Notification.Name("UserInfoUpdateNotificationName")
let kUserAvatarUpdateNotificationName = Notification.Name("UserAvatarUpdateNotificationName")


// MARK: - ShareSDK

let kShareSDKAppKey = "1f8c0134f6651"

// Wechat Login
let kWeChatAppId = "wx4d1cb9a62efd22b7"
let kWeChatAppSecret = "5d30898ed49c28dd6e869c6ceca975e7"

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

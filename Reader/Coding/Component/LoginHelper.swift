//
//  LoginHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

typealias LoginHandler = (_ succes: Bool, _ user: ServerUser?) -> Void

class LoginHelper {
    
    // QQ Login
    class func qqLogin(completion: @escaping LoginHandler) {
        ShareSDK.getUserInfo(.typeQQ) { (state, user, error) in
            if state == SSDKResponseState.success, let user = user {
                let openid = user.uid ?? ""
                let token = user.credential.token ?? ""
                let expiresIn = user.credential.rawData["expires_in"] as? Int32
                let nickname = user.nickname ?? ""
                let icon = user.icon
                let city = user.rawData["city"] as? String
                let gender = validateGender(user.rawData["gender"] as? String)
                let province = user.rawData["province"] as? String
                
                NOVELLog("QQ Login :")
                NOVELLog("openid   : \(openid)")
                NOVELLog("token    : \(token)")
                NOVELLog("expiresIn: \(String(describing: expiresIn))")
                NOVELLog("nickname : \(nickname)")
                NOVELLog("icon     : \(String(describing: icon))")
                NOVELLog("city     : \(String(describing: city))")
                NOVELLog("gender   : \(gender)")
                NOVELLog("province : \(String(describing: province))")
                
                let serverUser = ServerUser(userId: nil, identityType: kIdentityTypeQQ, identifier: openid, credential: token)
                
                serverUser.expiresIn = expiresIn ?? 0
                serverUser.nickname = nickname
                serverUser.avatar = icon
                serverUser.city = city
                serverUser.gender = gender
                serverUser.province = province
                
                completion(true, serverUser)
            } else {
                NOVELLog("QQ login error: \(String(describing: error))")
                completion(false, nil)
            }
        }
        
    }
    
    // Wechat Login
    class func wechatLogin(completion: @escaping LoginHandler) {
        ShareSDK.getUserInfo(.typeWechat) { (state, user, error) in
            if state == SSDKResponseState.success, let user = user {
                let openid = user.uid ?? ""
                let token = user.credential.token ?? ""
                let expiresIn = user.credential.rawData["expires_in"] as? Int32
                let refreshToken = (user.credential.rawData["refresh_token"] as? String) ?? ""
                let unionId = (user.rawData["unionid"] as? String) ?? ""
                let nickname = user.nickname ?? ""
                let icon = user.icon
                let city = user.rawData["city"] as? String
                let country = user.rawData["country"] as? String
                let province = user.rawData["province"] as? String
                let sex = user.rawData["sex"] as? Int32
                
                NOVELLog("Wechat Login :")
                NOVELLog("openid   : \(openid)")
                NOVELLog("token    : \(token)")
                NOVELLog("expiresIn: \(String(describing: expiresIn))")
                NOVELLog("refrsh   : \(refreshToken)")
                NOVELLog("unionid  : \(unionId)")
                NOVELLog("nickname : \(nickname)")
                NOVELLog("icon     : \(String(describing: icon))")
                NOVELLog("city     : \(String(describing: city))")
                NOVELLog("country  : \(String(describing: country))")
                NOVELLog("sex      : \(String(describing: sex))")
                NOVELLog("province : \(String(describing: province))")
                
                let serverUser = ServerUser(userId: nil, identityType: kIdentityTypeWechat, identifier: openid, credential: token)
                serverUser.expiresIn = expiresIn ?? 0
                serverUser.refreshToken = refreshToken
                serverUser.unionid = unionId
                serverUser.nickname = nickname
                serverUser.avatar = icon
                serverUser.city = city
                serverUser.country = country
                serverUser.province = province
                serverUser.gender = sex ?? 0
                
                completion(true, serverUser)
            } else {
                NOVELLog("Wechat login error: \(String(describing: error))")
                completion(false, nil)
            }
        }
    }
    
    // Weibo Login
    class func weiboLogin(completion: @escaping LoginHandler) {
        ShareSDK.getUserInfo(.typeSinaWeibo) { (state, user, error) in
            NOVELLog(error.debugDescription)
            NOVELLog(error?.localizedDescription)
            if state == SSDKResponseState.success, let user = user {
                let uid = user.uid ?? ""
                let token = user.credential.token ?? ""
                let expiresIn = user.credential.rawData["expires_in"] as? Int32
                let refreshToken = (user.credential.rawData["refresh_token"] as? String) ?? ""
                let nickname = user.nickname ?? ""
                var icon = user.icon
                
                var gender: Int32 = 0 // Unknow
                if user.gender == Int(SSDKGender.male.rawValue) {
                    gender = 1 // Male
                } else if user.gender == Int(SSDKGender.female.rawValue) {
                    gender = 2 // Female
                }
                
                if let avatarHD = user.rawData["avatar_hd"] as? String {
                    icon = avatarHD
                } else if let avatarLarge = user.rawData["avatar_large"] as? String {
                    icon = avatarLarge
                }
                
                let serverUser = ServerUser(userId: nil, identityType: kIdentityTypeWeibo, identifier: uid, credential: token)
                serverUser.expiresIn = expiresIn ?? 0
                serverUser.refreshToken = refreshToken
                serverUser.nickname = nickname
                serverUser.avatar = icon
                serverUser.gender = gender
                
                completion(true, serverUser)
            } else {
                NOVELLog("Weibo login error: \(String(describing: error))")
                completion(false, nil)
            }
        }
    }
    
    private class func showUser(_ user: SSDKUser?) {
        if let user = user {
            NOVELLog("uid  = \(user.uid)")
            NOVELLog("cred = \(user.credential)")
            NOVELLog("toke = \(user.credential.token)")
            NOVELLog("nick = \(user.nickname)")
            NOVELLog("gend = \(user.gender)")
            NOVELLog("icon = \(user.icon)")
        }
    }
    
}

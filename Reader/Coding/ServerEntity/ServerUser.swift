//
//  ServerUser.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ServerUser {
    
    var userId: String!
    
    // Usr auth
    var identityType: String
    var identifier: String
    var credential: String?
    var expiresIn: Int32 = 0
    var refreshToken: String?
    var unionid: String?
    var verified: Int32 = 0
    
    // Basic info
    var email: String?
    var nickname: String?
    var avatar: String?
    var nationalityId: Int32?
    var hskId: Int32?
    var interestedLangs: String?
    var username: String?
    var gender: Int32 = 0
    var phone: String?
    var desc: String?
    var address: String?
    var zipCode: String?
    var city: String?
    var province: String?
    var country: String?
    
    // Meta data
    var createTime: Int64 = 0
    var lastUpdateTime: Int64 = 0
    var isDel: Int32 = 0
    var status: Int32 = 1
    
    // Extended
    var sessionId: String?
    
    init(userId: String!, identityType: String, identifier: String, credential: String?) {
        self.userId = userId
        self.identityType = identityType
        self.identifier = identifier
        self.credential = credential
    }
}

extension ServerUser {
    
    class func fromDict(_ dict: [String: Any]) -> ServerUser {
        let userId = dict["userId"] as! String
        let identityType = dict["identityType"] as! String
        let identifier = dict["identifier"] as! String
        let credential = dict["credential"] as? String
        
        let serverUser = ServerUser(userId: userId, identityType: identityType, identifier: identifier, credential: credential)
        
        serverUser.expiresIn = (dict["expiresIn"] as? Int32) ?? 0
        serverUser.refreshToken = dict["refreshToken"] as? String
        serverUser.unionid = dict["unionid"] as? String
        serverUser.verified = dict["verified"] as! Int32
        serverUser.email = dict["email"] as? String
        serverUser.nickname = dict["nickname"] as? String
        serverUser.avatar = dict["avatar"] as? String
        serverUser.nationalityId = (dict["nationalityId"] as? Int32) ?? 0
        serverUser.hskId = (dict["hskId"] as? Int32) ?? 0
        serverUser.interestedLangs = dict["interestedLangs"] as? String
        serverUser.username = dict["username"] as? String
        serverUser.gender = dict["gender"] as! Int32
        serverUser.phone = dict["phone"] as? String
        serverUser.desc = dict["description"] as? String
        serverUser.address = dict["address"] as? String
        serverUser.zipCode = dict["zipCode"] as? String
        serverUser.city = dict["city"] as? String
        serverUser.province = dict["province"] as? String
        serverUser.country = dict["country"] as? String
        
        serverUser.createTime = dict["createTime"] as! Int64
        serverUser.lastUpdateTime = dict["lastUpdateTime"] as! Int64
        serverUser.isDel = dict["isDel"] as! Int32
        serverUser.status = dict["status"] as! Int32
        
        serverUser.sessionId = dict["sessionId"] as? String
        
        return serverUser
    }
    
    func toDict() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if let userId = userId {
            dict["userId"] = userId as AnyObject
        }
        
        if let sessionId = sessionId {
            dict["sessionId"] = sessionId as AnyObject
        }
        
        dict["identityType"]    = identityType    as AnyObject
        dict["identifier"]      = identifier      as AnyObject
        
        if let credential = credential {
            dict["credential"]  = credential      as AnyObject
        }
        
        dict["expiresIn"] = "\(expiresIn)" as AnyObject
        
        if let refreshToken = refreshToken {
            dict["refreshToken"] = refreshToken as AnyObject
        }
        
        if let unionid = unionid {
            dict["unionid"] = unionid as AnyObject
        }
        
        dict["verified"]        = "\(verified)"   as AnyObject
        
        if let email = email {
            dict["email"]       = email           as AnyObject
        }
        
        if let nickname = nickname {
            dict["nickname"]        = nickname        as AnyObject
        }
        
        if let avatar = avatar {
            dict["avatar"]          = avatar          as AnyObject
        }
        
        if let nationalityId = nationalityId, nationalityId > 0 {
            dict["nationalityId"]   = "\(nationalityId)"  as AnyObject
        }
        
        if let hskId = hskId, hskId > 0 {
            dict["hskId"]           = "\(hskId)"          as AnyObject
        }
        
        if let interestedLangs = interestedLangs {
            dict["interestedLangs"] = interestedLangs as AnyObject
        }
        
        if let username = username {
            dict["username"]        = username        as AnyObject
        }
        
        dict["gender"]          = "\(gender)"         as AnyObject
        
        if let phone = phone {
            dict["phone"]           = phone           as AnyObject
        }
        
        if let desc = desc  {
            dict["description"]     = desc            as AnyObject
        }
        
        if let address = address {
            dict["address"]         = address         as AnyObject
        }
        
        if let zipCode = zipCode {
            dict["zipCode"]         = zipCode         as AnyObject
        }
        
        if let city = city {
            dict["city"]            = city            as AnyObject
        }
        
        if let province = province {
            dict["province"]        = province        as AnyObject
        }
        
        if let country = country {
            dict["country"]         = country         as AnyObject
        }
        
        return dict
    }
    
    
}

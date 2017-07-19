//
//  UserManager.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

class UserManager {
    
    fileprivate static let entityUser = "User"
    fileprivate static var current: User?
    
    fileprivate class func add(_ serverUser: ServerUser) -> User? {
        var user: User? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", serverUser.userId)
        
        do {
            let list = try context.fetch(request)
            if list.count > 0 {
                user = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityUser, in: context)
                user = User(entity: entity!, insertInto: context)
            }
            
            setFields(user!, serverUser: serverUser)
            try context.save()
        } catch {
            NOVELLog("Failed to add user: \(error)")
        }
        
        return user
    }
    
    fileprivate class func updateAvatarForCurrentUser(_ path: String) {
        if let user = current {
            user.avatar = path
            
            do {
                try user.managedObjectContext?.save()
            } catch {
                NOVELLog("Failed to update avatar for current user: \(error)")
            }
        }
    }
    
    fileprivate class func getCurrent() -> User? {
        var user: User? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let list = try context.fetch(request)
            if list.count > 1 {
                NOVELLog("More than one user found")
            } else if list.count == 1 {
                user = list.first
            }
        } catch {
            NOVELLog("Failed to get current user: \(error)")
        }
        
        return user
    }
    
    fileprivate class func delete() {
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let list = try context.fetch(request)
            for user in list {
                context.delete(user)
            }
            
            try context.save()
        } catch {
            NOVELLog("Failed to delete user: \(error)")
        }
    }
    
    fileprivate class func setFields(_ user: User, serverUser: ServerUser) {
        user.userId          = serverUser.userId
        user.identityType    = serverUser.identityType
        user.identifier      = serverUser.identifier
        user.credential      = serverUser.credential
        user.expiresIn       = serverUser.expiresIn
        user.refreshToken    = serverUser.refreshToken
        user.unionid         = serverUser.unionid
        user.verified        = serverUser.verified
        user.email           = serverUser.email
        user.nickname        = serverUser.nickname
        user.avatar          = serverUser.avatar
        user.nationalityId   = serverUser.nationalityId ?? 0
        user.hskId           = serverUser.hskId ?? 0
        user.interestedLangs = serverUser.interestedLangs
        user.username        = serverUser.username
        user.gender          = serverUser.gender
        user.phone           = serverUser.phone
        user.desc            = serverUser.desc
        user.address         = serverUser.address
        user.zipCode         = serverUser.zipCode
        user.city            = serverUser.city
        user.province        = serverUser.province
        user.country         = serverUser.country
        user.createTime      = serverUser.createTime
        user.lastUpdateTime  = serverUser.lastUpdateTime
        user.isDel           = serverUser.isDel
        user.status          = serverUser.status
        user.sessionId       = serverUser.sessionId
    }
    
    class func serverUserFromUser(_ user: User) -> ServerUser {
        let serverUser = ServerUser(userId: user.userId, identityType: user.identityType, identifier: user.identifier, credential: nil)
        
        if user.identityType != kIdentityTypeEmail {
            serverUser.credential  = user.credential
        }
        
        serverUser.expiresIn       = user.expiresIn
        serverUser.refreshToken    = user.refreshToken
        serverUser.unionid         = user.unionid
        serverUser.email           = user.email
        serverUser.nickname        = user.nickname
        serverUser.avatar          = user.avatar
        serverUser.nationalityId   = user.nationalityId
        serverUser.hskId           = user.hskId
        serverUser.interestedLangs = user.interestedLangs
        serverUser.username        = user.username
        serverUser.gender          = user.gender
        serverUser.phone           = user.phone
        serverUser.desc            = user.desc
        serverUser.address         = user.address
        serverUser.zipCode         = user.zipCode
        serverUser.city            = user.city
        serverUser.province        = user.province
        serverUser.country         = user.country
        serverUser.sessionId       = user.sessionId
        
        return serverUser
    }
}

extension UserManager {
    
    class func addUser(_ serverUser: ServerUser) -> User? {
        current = add(serverUser)
        return current
    }
    
    class func currentUser() -> User? {
        if current == nil {
            current = getCurrent()
        }
        
        return current
    }
    
    class func hasUser() -> Bool {
        if current == nil {
            current = getCurrent()
        }
        
        return current != nil
    }
    
    class func deleteUser() {
        current = nil
        delete()
    }
    
    class func saveCurrent() {
        if let current = current {
            do {
                try current.managedObjectContext?.save()
            } catch {
                NOVELLog("Failed to update user info: \(error)")
            }
        }
    }
    
    class func updateAvatar(_ path: String) {
        if current == nil {
            current = getCurrent()
        }
        
        updateAvatarForCurrentUser(path)
    }
    
}

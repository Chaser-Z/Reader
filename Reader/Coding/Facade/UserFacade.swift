//
//  UserFacade.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation


class UserFacade {
    
    class func register(serverUser: ServerUser, completion: @escaping (_ user: User?, _ errorCode: Int) -> Void) {
        var params = serverUser.toDict()
        params["regPlatform"] = "iOS" as AnyObject
        params.mergeInPlace(Util.getDeviceInfo())
        
        UserWSHelper.register(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverUser = resp.dict["user"] as! ServerUser
                let user = UserManager.addUser(serverUser)
                completion(user, ErrorCode.Success)
            } else {
                NOVELLog("Failed to register user to server: \(errorCode)")
                completion(nil, errorCode)
            }
        }
    }
    
    // Email login
    class func login(identityType: String, identifier: String, credential: String, completion: @escaping (_ user: User?, _ errorCode: Int) -> Void) {
        var params = [String: AnyObject]()
        params["identityType"] = identityType as AnyObject
        params["identifier"] = identifier as AnyObject
        params["credential"] = credential as AnyObject
        params.mergeInPlace(Util.getDeviceInfo())
        
        UserWSHelper.login(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverUser = resp.dict["user"] as! ServerUser
                let user = UserManager.addUser(serverUser)
                completion(user, ErrorCode.Success)
            } else {
                NOVELLog("Failed to login to server: \(errorCode)")
                completion(nil, errorCode)
            }
        }
    }

    // 3rd Login: wechat, qq, weibo
    class func login(_ serverUser: ServerUser, completion: @escaping (_ user: User?, _ errorCode: Int) -> Void) {
        var params = serverUser.toDict()
        params["regPlatform"] = "iOS" as AnyObject
        params.mergeInPlace(Util.getDeviceInfo())
        
        UserWSHelper.login(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let tempUser = resp.dict["user"] as! ServerUser
                let user = UserManager.addUser(tempUser)
                completion(user, ErrorCode.Success)
            } else {
                NOVELLog("Failed to 3rd login to server: \(errorCode)")
                completion(nil, errorCode)
            }
        }
    }
    
    class func logout(userId: String, sessionId: String, completion: @escaping (_ success: Bool, _ errorCode: Int) -> Void) {
        var params = [String: AnyObject]()
        params["userId"] = userId as AnyObject
        params["sessionId"] = sessionId as AnyObject
        
        UserWSHelper.logout(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                completion(true, ErrorCode.Success)
            } else {
                NOVELLog("Failed to logout from server: \(errorCode)")
                completion(false, errorCode)
            }
        }
    }
    
    class func checkSession(userId: String, sessionId: String, completion: @escaping (_ success: Bool, _ errorCode: Int) -> Void) {
        var params = [String: AnyObject]()
        params["userId"] = userId as AnyObject
        params["sessionId"] = sessionId as AnyObject
        
        UserWSHelper.checkSession(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                completion(true, ErrorCode.Success)
            } else {
                NOVELLog("Failed to check session from server: \(errorCode)")
                completion(false, errorCode)
            }
        }
    }
    
    class func resetPassword(identityType: String, identifier: String, completion: @escaping (_ success: Bool, _ errorCode: Int) -> Void) {
        var params = [String: AnyObject]()
        params["identityType"] = identityType as AnyObject
        params["identifier"] = identifier as AnyObject
        
        UserWSHelper.resetPassword(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                completion(true, ErrorCode.Success)
            } else {
                NOVELLog("Failed to reset password: \(errorCode)")
                completion(false, errorCode)
            }
        }
    }
    
    class func changePassword(userId: String, sessionId: String, identityType: String, identifier: String, credentialOld: String, credential: String, completion: @escaping (_ success: Bool, _ errorCode: Int) -> Void) {
        var params = [String: AnyObject]()
        params["userId"] = userId as AnyObject
        params["sessionId"] = sessionId as AnyObject
        params["identityType"] = identityType as AnyObject
        params["identifier"] = identifier as AnyObject
        params["credentialOld"] = credentialOld as AnyObject
        params["credential"] = credential as AnyObject
        
        UserWSHelper.changePassword(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                completion(true, ErrorCode.Success)
            } else {
                NOVELLog("Failed to change password: \(errorCode)")
                completion(false, errorCode)
            }
        }
    }
    
    class func update(serverUser: ServerUser, completion: @escaping (_ user: User?, _ errorCode: Int) -> Void) {
        let params = serverUser.toDict()
        
        UserWSHelper.update(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverUser = resp.dict["user"] as! ServerUser
                let user = UserManager.addUser(serverUser)
                completion(user, ErrorCode.Success)
            } else {
                NOVELLog("Failed to update user: \(errorCode)")
                completion(nil, errorCode)
            }
        }
    }
    
    class func updateAvatar(userId: String, sessionId: String, avatar: Data, progress: ProgressHandler?, completion: @escaping (_ path: String?, _ errorCode: Int) -> Void) {
        var params = [String: AnyObject]()
        params["userId"] = userId as AnyObject
        params["sessionId"] = sessionId as AnyObject
        
        UserWSHelper.updateAvatar(params, avatar: avatar, progress: progress) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let path = resp.dict["path"] as! String
                UserManager.updateAvatar(path)
                completion(path, ErrorCode.Success)
            } else {
                NOVELLog("Failed to update avatar: \(errorCode)")
                completion(nil, errorCode)
            }
        }
    }

    
}

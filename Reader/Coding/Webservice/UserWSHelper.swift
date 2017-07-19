//
//  UserWSHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class UserWSHelper {
    
    class func register(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/register"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            NOVELLog(resp)
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                var info = [String: Any]()
                
                if let dict = json as? [String: Any] {
                    if let userDict = dict["data"] as? [String: Any] {
                        let user = ServerUser.fromDict(userDict)
                        info["user"] = user
                    }
                }
                
                return info
            }
            
            completion(serviceResponse)
        }
    }
    
    class func login(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/login"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                var info = [String: Any]()
                
                if let dict = json as? [String: Any] {
                    if let userDict = dict["data"] as? [String: Any] {
                        let user = ServerUser.fromDict(userDict)
                        info["user"] = user
                    }
                }
                
                return info
            }
            
            completion(serviceResponse)
        }
    }
    
    class func logout(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/logout"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                return [:]
            }
            
            completion(serviceResponse)
        }
    }
    
    class func checkSession(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/checkSession"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                return [:]
            }
            
            completion(serviceResponse)
        }
    }
    
    class func resetPassword(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/resetPassword"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                return [:]
            }
            
            completion(serviceResponse)
        }
    }
    
    class func changePassword(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/changePassword"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                return [:]
            }
            
            completion(serviceResponse)
        }
    }
    
    class func update(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/user/update"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                var info = [String: Any]()
                
                if let dict = json as? [String: Any] {
                    if let userDict = dict["data"] as? [String: Any] {
                        let user = ServerUser.fromDict(userDict)
                        info["user"] = user
                    }
                }
                
                return info
            }
            
            completion(serviceResponse)
        }
    }
    
    class func updateAvatar(_ params: [String: AnyObject], avatar: Data, progress: ProgressHandler?, completion: @escaping ServiceHandler) {
        let path = "/user/updateAvatar"
        
        CommonWSHelper.request(path: path, params: params, datum: [avatar], progress: progress) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                var info = [String: Any]()
                
                if let dict = json as? [String: Any] {
                    if let path = dict["data"] as? String {
                        info["path"] = path
                    }
                }
                
                return info
            }
            
            completion(serviceResponse)
        }
    }
    
}

//
//  ContentFacade.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ContentFacade {
    
    class func getContent(params: [String: AnyObject], completion: @escaping (_ content: Content?) -> Void) {
        ContentWSHelper.getContent(params) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverContent = resp.dict["content"] as! ServerContent
                let content = ContentManager.add(serverContent)
                completion(content!)
                
            } else {
                NOVELLog("Failed to get getContent: \(errorCode)")
                completion(nil)
            }
            
        }
    }

    class func getAllContent(params: [String: AnyObject], completion: @escaping (_ content: [Content]) -> Void) {
        
        ContentWSHelper.getAllContent(params) { (resp) in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverContents = resp.dict["contents"] as! [ServerContent]
                let contents = serverContents.map{
                    ContentManager.add($0)
                }
                completion(contents as! [Content])
                
            } else {
                NOVELLog("Failed to get all Content: \(errorCode)")
                completion([])
            }

        }

    }
}

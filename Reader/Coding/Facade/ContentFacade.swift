//
//  ContentFacade.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ContentFacade {
    
    class func getContent(params: [String: AnyObject], completion: @escaping (_ content: Content) -> Void) {
        ContentWSHelper.getContent(params) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverChapter = resp.dict["content"] as! ServerContent
                let content = ContentManager.add(serverChapter)
                completion(content!)
                
            } else {
                NOVELLog("Failed to get all novels: \(errorCode)")
                completion(Content())
            }
            
        }
    }

    

}

//
//  ContentWSHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ContentWSHelper {

    class func getContent(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        
        let path = "/articleContent/getArticleByDriectoryLink"
        
        CommonWSHelper.request(path: path, params: params) { (resp) in
            
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                var info = [String: Any]()
                if let dict = json as? [String: Any] {
                    
                    if let contentListDict = dict["data"] as? [String: Any] {
                        let chapter = ServerContent.fromDict(contentListDict)
                        info["content"] = chapter
                    }
                }
                return info
                
            }
            
            completion(serviceResponse)
        }
        
        
    }
}

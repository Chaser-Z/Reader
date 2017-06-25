//
//  NovelWSHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation


class NovelWSHelper {
    
    class func getNovelList(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/article/getHot"
        
        CommonWSHelper.request(path: path, params: params) { (resp) in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                var info = [String: Any]()
                if let dict = json as? [String: Any] {
                    if let novelListDict = dict["data"] as? [[String: Any]] {
                        let novels = novelListDict.map{
                            ServerNovel.fromDict($0)
                        }
                        info["novels"] = novels
                    }
                }
                
                return info
                
            }
            completion(serviceResponse)
        }
    }
    
    
}

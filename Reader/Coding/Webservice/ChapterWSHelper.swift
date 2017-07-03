//
//  ChapterWSHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ChapterWSHelper {
    
    class func getChapterList(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        
        let path = "/articleInfo/getArticlesByArticleId"
        
        CommonWSHelper.request(path: path, params: params) { (resp) in
            
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                
                var info = [String: Any]()
                if let dict = json as? [String: Any] {
                    
                    if let chapterListDict = dict["data"] as? [[String: Any]] {
                        let chapters = chapterListDict.map{
                            ServerChapter.fromDict($0)
                        }
                        info["chapters"] = chapters
                    }
                }
                return info
            
            }
            
            completion(serviceResponse)
        }
        
    }
    
    class func getUpdated(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        
        let path = "/articleInfo/getLatestArticles"
        
        CommonWSHelper.request(path: path, params: params) { (resp) in
            
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                
                var info = [String: Any]()
                if let dict = json as? [String: Any] {
                    
                    if let chapterListDict = dict["data"] as? [[String: Any]] {
                        let chapters = chapterListDict.map{
                            ServerChapter.fromDict($0)
                        }
                        info["updated"] = chapters
                    }
                }
                return info
                
            }
            
            completion(serviceResponse)
        }

        
    }
    
    
    
}

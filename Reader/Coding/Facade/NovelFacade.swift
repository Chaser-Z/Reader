//
//  NovelFacade.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation


class NovelFacade {
    
    class func getNovelList(completion: @escaping (_ novel: [Novel]) -> Void) {
        
        NovelWSHelper.getNovelList([:]) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverNovels = resp.dict["novels"] as! [ServerNovel]
                let novels = serverNovels.map {
                    NovelManager.add($0)
                }
                completion(novels as! [Novel])
                
            } else {
                NOVELLog("Failed to get all novels: \(errorCode)")
                completion([])
            }
            
        }
    }
    
    class func getNovelByType(params: [String: AnyObject], completion: @escaping (_ novel: [Novel]) -> Void) {
        
        NovelWSHelper.getNovelByType(params) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverNovels = resp.dict["novels"] as! [ServerNovel]
                let novels = serverNovels.map {
                    NovelManager.add($0)
                }
                completion(novels as! [Novel])
                
            } else {
                NOVELLog("Failed to get all novels: \(errorCode)")
                completion([])
            }
            
        }
    }

    
//    class func getHomeNovelList(completion: @escaping (_ novel: [ServerNovel]) -> Void) {
//        
//        NovelWSHelper.getHomeNovels([:]) { (resp) in
//            
//            let errorCode = resp.errorCode
//            if errorCode == ErrorCode.Success {
//                let serverNovels = resp.dict["novels"] as! [ServerNovel]
//                completion(serverNovels)
//                
//            } else {
//                NOVELLog("Failed to getHomeNovelList: \(errorCode)")
//                completion([])
//            }
//            
//        }
//        
//    }
    
    class func getHomeNovelList(completion: @escaping (_ novel: [Novel]) -> Void) {
        
        NovelWSHelper.getHomeNovels([:]) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverNovels = resp.dict["novels"] as! [ServerNovel]
                let novels = serverNovels.map {
                    NovelManager.add($0)
                }
                completion(novels as! [Novel])
                
            } else {
                NOVELLog("Failed to getHomeNovelList: \(errorCode)")
                completion([])
            }
            
        }
        
    }
    
    class func searchNovelByKeyword(_ keyword: String, completion: @escaping (_ articles: [Novel]) -> Void) {
        var params = [String: AnyObject]()
        params["keyword"] = keyword as AnyObject?
        
        NovelWSHelper.searchNovelByKeyword(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverNovels = resp.dict["novels"] as! [ServerNovel]
                let novels = serverNovels.map { NovelManager.add($0)! }
                completion(novels)
            } else {
                NOVELLog("Failed to search articles by keyword: \(errorCode)")
                completion([])
            }
        }
    }

}

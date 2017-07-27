//
//  ChapterFacade.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ChapterFacade {
    
    class func getChapterList(params: [String: AnyObject], completion: @escaping (_ chapter: [Chapter]) -> Void) {
        ChapterWSHelper.getChapterList(params) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                
                
                let serverChapters = resp.dict["chapters"] as! [ServerChapter]
                let chapters = serverChapters.map {
                    ChapterManager.add($0)
                }
                completion(chapters as! [Chapter])
                
            } else {
                NOVELLog("Failed to get all novels: \(errorCode)")
                completion([])
            }

        }
    }
    
    class func getUpdated(params: [String: AnyObject], completion: @escaping (_ chapter: [Chapter]) -> Void) {
        
        ChapterWSHelper.getUpdated(params) { (resp) in
            
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                let serverChapters = resp.dict["updated"] as! [ServerChapter]
                let chapters = serverChapters.map {
                    ChapterManager.add($0)
                }
                completion(chapters as! [Chapter])
            } else {
                NOVELLog("Failed to get getUpdated: \(errorCode)")
                completion([])
            }
            
        }
        
    }
    
    
}

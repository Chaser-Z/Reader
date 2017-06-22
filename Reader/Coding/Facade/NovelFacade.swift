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
                NOVELLog(resp.dict["novels"])
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
    
    
    
    
    
    
    
    
    
}

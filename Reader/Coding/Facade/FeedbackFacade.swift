//
//  FeedbackFacade.swift
//  Reader
//
//  Created by 张海南 on 2017/8/3.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation


class FeedbackFacade {
    
    class func add(_ serverFeedback: ServerFeedback, completion: @escaping (_ success: Bool) -> Void) {
        let params = serverFeedback.toDict()
        FeedbackWSHelper.add(params) { resp in
            let errorCode = resp.errorCode
            if errorCode == ErrorCode.Success {
                completion(true)
            } else {
                NOVELLog("Failed to add feedback to server: \(errorCode)")
                completion(false)
            }
        }
    }
    
}

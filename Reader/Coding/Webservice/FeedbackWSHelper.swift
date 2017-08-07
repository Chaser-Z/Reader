//
//  FeedbackWSHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/8/3.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation


class FeedbackWSHelper {
    
    class func add(_ params: [String: AnyObject], completion: @escaping ServiceHandler) {
        let path = "/feedback/add"
        
        CommonWSHelper.request(path: path, params: params) { resp in
            let serviceResponse = CommonWSHelper.processServiceResponse(resp) { json in
                return [:]
            }
            
            completion(serviceResponse)
        }
    }
}

//
//  ServiceResponse.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ServiceResponse {
    
    var isSuccess: Bool
    var errorCode: Int
    var dict: [String: Any] = [:]
    var data: Data?
    var pdfPath: String?
    
    init(isSuccess: Bool, errorCode: Int) {
        self.isSuccess = isSuccess
        self.errorCode = errorCode
    }
    
}

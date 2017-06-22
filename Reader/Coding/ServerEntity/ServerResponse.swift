//
//  ServerResponse.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ServerResponse {


    var isSuccess: Bool
    var errorCode: Int
    
    var json: [String: Any]?
    var data: Data?
    var pdfPath: String?
    
    init(isSuccess: Bool, errorCode: Int, json: [String: Any]?) {
        self.isSuccess = isSuccess
        self.errorCode = errorCode
        self.json = json
    }
    
    
    init(isSuccess: Bool, errorCode: Int, data: Data?) {
        self.isSuccess = isSuccess
        self.errorCode = errorCode
        self.data = data
    }
    
    init(isSuccess: Bool, errorCode: Int, pdfPath: String?) {
        self.isSuccess = isSuccess
        self.errorCode = errorCode
        self.pdfPath = pdfPath
    }
    
    init(isSuccess: Bool, errorCode: Int) {
        self.isSuccess = isSuccess
        self.errorCode = errorCode
    }


}

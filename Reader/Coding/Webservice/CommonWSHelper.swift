//
//  CommonWSHelper.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias ServiceHandler = (ServiceResponse) -> Void
typealias ServerHandler = (ServerResponse) -> Void
typealias ProgressHandler = (Double) -> Void


class CommonWSHelper {
    
    class func request(path: String, params: [String: AnyObject], completion: @escaping ServerHandler) {
        
        Alamofire.request("\(HOST)\(path)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            processServerResponse(response, completion: completion)
        }
        
    }
    
    class func request(path: String, params: [String: AnyObject], datum: [Data], progress: ProgressHandler?, completion: @escaping ServerHandler) {
        let multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
            for (index, data) in datum.enumerated() {
                multipartFormData.append(data, withName: "file", fileName: "file\(index).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
        }
        
        request(path: path, multipartFormData: multipartFormData, progress: progress, completion: completion)
    }
    
    class func request(path: String, multipartFormData: @escaping (MultipartFormData) -> Void, progress: ProgressHandler?, completion: @escaping ServerHandler) {
        Alamofire.upload(multipartFormData: multipartFormData, to: "\(HOST)\(path)", method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { (myProgress) in
                    progress?(myProgress.fractionCompleted)
                }
                
                upload.responseJSON { response in
                    processServerResponse(response, completion: completion)
                }
                
            case .failure(let error):
                NOVELLog("CommonWSHelper encoding error: \(error)")
                let resp = ServerResponse(isSuccess: false, errorCode: ErrorCode.ClientEncodingError, json: nil)
                completion(resp)
            }
        })
    }
    
    class func processServiceResponse(_ resp: ServerResponse, handler: (_ data: Any) -> [String: Any]?) -> ServiceResponse {
        var result: ServiceResponse
        
        if resp.isSuccess {
            if let data = resp.data {
                result = ServiceResponse(isSuccess: true, errorCode: ErrorCode.Success)
                result.data = data
            } else if let pdfPath = resp.pdfPath {
                result = ServiceResponse(isSuccess: true, errorCode: ErrorCode.Success)
                result.pdfPath = pdfPath
            } else if let dict = resp.json {
                if let errorCode = dict["errorCode"] as? Int {
                    if errorCode == ErrorCode.Success {
                        result = ServiceResponse(isSuccess: true, errorCode: ErrorCode.Success)
                        if let info = handler(dict) {
                            for (key, value) in info {
                                result.dict[key] = value
                            }
                        }
                    } else {
                        result = ServiceResponse(isSuccess: false, errorCode: errorCode)
                    }
                } else {
                    result = ServiceResponse(isSuccess: false, errorCode: ErrorCode.JSONMissingErrorCode)
                }
            } else {
                result = ServiceResponse(isSuccess: false, errorCode: ErrorCode.JSONEmptyError)
            }
        } else {
            result = ServiceResponse(isSuccess: false, errorCode: resp.errorCode)
        }
        
        return result
    }
    
    fileprivate class func processServerResponse(_ resp: DataResponse<Any>, completion: ServerHandler) {
        
        var errorCode = ErrorCode.ClientError
        var success = false
        var json: [String: Any]? = nil
        
        switch resp.result {
        case .success(let value):
            if let dict = value as? [String: Any] {
                errorCode = ErrorCode.Success
                success = true
                json = dict
            } else {
                errorCode = ErrorCode.ClientNoDataReturned
            }
            
        case .failure(let error):
            NOVELLog("Server response error: \(error)")
            errorCode = ErrorCode.ClientError
        }
        
        let serverResp = ServerResponse(isSuccess: success, errorCode: errorCode, json: json)
        completion(serverResp)
        
    }
    
}




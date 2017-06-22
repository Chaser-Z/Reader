//
//  ErrorCode.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

struct ErrorCode {
    
    // Success
    
    static let Success = 0
    
    // Client Error Code
    
    static let ClientError = -100
    static let ClientNoDataReturned = -110
    static let ClientEncodingError = -120
    static let FileDownloadError = -130
    static let JSONEmptyError = -150
    static let JSONParsingError = -160
    static let JSONMissingErrorCode = -170
    
    // PDF Downlaod Error Code
    
    static let PdfDownloadError = -200
    static let PdfIsDownloading = -201
    static let PdfDownloadingExceedMax = -202
    static let PdfNotFound = -203
    static let PdfDownloadCancelled = -204
    
    // User Error Code
    
    static let UserIdentityExisting = 200
    static let UserNotExist = 201
    static let OnlyForEmailUser = 202
    static let UserOldCredentialInvalid = 203
    static let UserCredentialIncorrect = 204
    
}

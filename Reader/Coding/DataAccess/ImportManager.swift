//
//  ImportManager.swift
//  Reader
//
//  Created by 张海南 on 2017/8/16.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData


class ImportManager {

    class func importContent(serverContents: [ServerContent]) {
        
        DispatchQueue.global(qos: .default).async {
            if serverContents.count > 0 {
                ContentManager.importAllAndWait(serverContents)
            }
        }
    }
    
    class func importContent(serverContent: ServerContent) {
        DispatchQueue.global(qos: .default).async {
            ContentManager.importAllAndWait(serverContent)
        }
    }

}

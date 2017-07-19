//
//  User+CoreDataClass.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    var interestedLangIds: [Int32] {
        get {
            guard let strs = interestedLangs else {
                return []
            }
            
            var ids = [Int32]()
            let items = strs.components(separatedBy: CharacterSet(charactersIn: ",;"))
            for item in items {
                if let id = Int32(item) {
                    ids.append(id)
                }
            }
            
            return ids
        }
        
        set {
            if newValue.count == 0 {
                interestedLangs = nil
            } else {
                interestedLangs = newValue.reduce("") { $0 == "" ? "\($1)" : "\($0),\($1)" }
            }
        }
    }
    
    var avatarFullPath: String? {
        guard let path = avatar else {
            return nil
        }
        
        if identityType == kIdentityTypeEmail {
            return "\(HOST)\(path)"
        } else if path.hasPrefix("http") {
            return path
        } else {
            return "\(HOST)\(path)"
        }
    }
    
}

//
//  Novel+CoreDataProperties.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

extension Novel {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Novel> {
        
        return NSFetchRequest<Novel>(entityName: "Novel")
    }
    
    @NSManaged public var article_id: String
    @NSManaged public var title: String?
    @NSManaged public var author: String
    @NSManaged public var article_abstract: String?
    @NSManaged public var link: String
    @NSManaged public var image_link: String
    @NSManaged public var article_type: String
    @NSManaged public var isSave: String 

    
    
}

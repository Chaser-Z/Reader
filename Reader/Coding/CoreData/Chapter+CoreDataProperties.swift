//
//  Chapter+CoreDataProperties.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData
extension Chapter {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapter> {
        
        return NSFetchRequest<Chapter>(entityName: "Chapter")
    }
    
    @NSManaged public var article_directory: String
    @NSManaged public var article_directory_link: String
    @NSManaged public var article_id: String
    @NSManaged public var last_update_date: String?
    @NSManaged public var last_update_directory: String
    @NSManaged public var update_status: String

    
    
}

//
//  Content+CoreDataProperties.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData
extension Content {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        
        return NSFetchRequest<Content>(entityName: "Content")
    }
    
    @NSManaged public var article_directory_link: String
    @NSManaged public var content: String
    @NSManaged public var article_directory: String
    @NSManaged public var pageCount: Int

    
    
}

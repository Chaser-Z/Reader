//
//  Record+CoreDataProperties.swift
//  Reader
//
//  Created by 张海南 on 2017/6/28.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

extension Record {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        
        return NSFetchRequest<Record>(entityName: "Record")
    }
    
    @NSManaged public var article_id: String
    @NSManaged public var last_update_date: String
    @NSManaged public var article_directory_link: String
    @NSManaged public var content: String
    @NSManaged public var article_directory: String
    @NSManaged public var pageCount: Int32
    @NSManaged public var currentPage: Int32
    @NSManaged public var currentChapterIndex: Int32
    @NSManaged public var id: Int64
    
}




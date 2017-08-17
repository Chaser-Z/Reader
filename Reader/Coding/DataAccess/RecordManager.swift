//
//  RecordManager.swift
//  Reader
//
//  Created by 张海南 on 2017/6/28.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

class RecordManager {
    
    fileprivate static let entityRecord = "Record"
    
    class func add(_ serverRecord: ServerRecord) -> Record? {
        
        var record: Record? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@", serverRecord.article_id!)
        
        do {
            
            let list = try context.fetch(request)
            if list.count > 0 {
                record = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityRecord, in: context)
                record = Record(entity: entity!, insertInto: context)
            }
            
            setFields(record!, serverRecord: serverRecord)
            try context.save()
        } catch {
            NOVELLog("Failed to add Record: \(error)")
        }
        
        return record
    }
    
    class func getRecord(_ articleId: String) -> [Record] {
        
        var record = [Record]()
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@", articleId)
        
        do {
            record = try context.fetch(request)
        } catch {
            NOVELLog("Failed to get record: \(error)")
        }
        return record
    }
    
    class func deleteAll() {
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        
        do {
            let list = try context.fetch(request)
            for record in list {
                context.delete(record)
            }
            
            try context.save()
        } catch {
            NOVELLog("Failed to delete all records: \(error)")
        }
    }
    
    fileprivate class func setFields(_ record: Record, serverRecord: ServerRecord) {
        record.article_id = serverRecord.article_id!
        record.last_update_date = serverRecord.last_update_date!
        record.article_directory_link = serverRecord.article_directory_link!
        record.content = serverRecord.content!
        record.article_directory = serverRecord.article_directory!
        record.pageCount = serverRecord.pageCount!
        record.currentPage = serverRecord.currentPage!
        record.currentChapterIndex = serverRecord.currentChapterIndex!
        record.id = serverRecord.id ?? -1
    }
    
    
    
}

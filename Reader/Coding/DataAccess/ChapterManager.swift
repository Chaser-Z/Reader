//
//  ChapterManager.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

class ChapterManager {
    
    fileprivate static let entityChapter = "Chapter"
    
    class func add(_ serverChapter: ServerChapter) -> Chapter? {
        
        var chapter: Chapter? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Chapter> = Chapter.fetchRequest()
        request.predicate = NSPredicate(format: "article_directory == %@ AND article_id == %@", serverChapter.article_directory, serverChapter.article_id)
        do {
            let list = try context.fetch(request)
            if list.count > 0 {
                chapter = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityChapter, in: context)
                chapter = Chapter(entity: entity!, insertInto: context)
            }
            
            setFields(chapter!, serverChapter: serverChapter)
            try context.save()
        } catch {
            NOVELLog("Failed to add chapter: \(error)")
        }
        return chapter
        
    }
    
    class func getAll(_ articleId: String) -> [Chapter] {
        
        var chapters = [Chapter]()
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Chapter> = Chapter.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@", articleId)

        do {
            chapters = try context.fetch(request)
        } catch {
            NOVELLog("Failed to get all novels: \(error)")
        }
        return chapters
    }
        
    fileprivate class func setFields(_ chapter: Chapter, serverChapter: ServerChapter) {
        chapter.article_directory = serverChapter.article_directory
        chapter.id = serverChapter.id
        //chapter.article_directory_link =  serverChapter.article_directory_link
        chapter.article_id = serverChapter.article_id
        chapter.last_update_date = serverChapter.last_update_date
        chapter.last_update_directory = serverChapter.last_update_directory
        //chapter.update_status = serverChapter.update_status
    }

    
}

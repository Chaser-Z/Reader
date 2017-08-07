//
//  NovelManager.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

class NovelManager {
    
    fileprivate static let entityNovel = "Novel"
    
    class func add(_ serverNovel: ServerNovel) -> Novel? {
        
        var novel: Novel? = nil
        
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@", serverNovel.article_id)
        do {
            let list = try context.fetch(request)
            if list.count > 0 {
                novel = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityNovel, in: context)
                novel = Novel(entity: entity!, insertInto: context)
            }
            
            setFields(novel!, serverNovel: serverNovel)
            try context.save()
        } catch {
            NOVELLog("Failed to add novel: \(error)")
        }
        
        return novel
    }
    
    class func add(_ novel: Novel) {
        
        NOVELLog(novel.title)
        novel.isSave = "1"
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@ AND isSave == %@", novel.article_id, "1")
        do {
            let list = try context.fetch(request)
            if list.count > 0 {
                let _ = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityNovel, in: context)
                let _ = Novel(entity: entity!, insertInto: context)
            }
            try context.save()
        } catch {
            NOVELLog("Failed to add novel: \(error)")
        }
        
    }

    
    class func getAll() -> [Novel] {
        var novels = [Novel]()
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        request.predicate = NSPredicate(format: "isSave == %@", "1")

        do {
            novels = try context.fetch(request)
        } catch {
            NOVELLog("Failed to get all novels: \(error)")
        }
        return novels
    }
    
    class func getNovel(_ articleId: String) -> Novel? {
        
        var novel: Novel?
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@ AND isSave == %@", articleId, "1")
        
        do {
            let list = try context.fetch(request)
            novel = list.first
        } catch {
            NOVELLog("Failed to getNovel: \(error)")
        }
        return novel
    }
    
    class func deleteAll() {
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        
        do {
            let list = try context.fetch(request)
            for novel in list {
                context.delete(novel)
            }
            try context.save()
        } catch {
            NOVELLog("Failed to delete All novels: \(error)")
        }
    }
    
    class func deleteNovel(_ articleId: String) {
        
        let novel = geteleteNovel(articleId)
        
        novel?.isSave = "0"
        do {
            try novel?.managedObjectContext?.save()
        } catch {
            NOVELLog("Failed to update deleteNovel: \(error)")
        }
    }
    
    class func geteleteNovel(_ articleId: String) -> Novel? {
        var deleteNovel: Novel? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        
        request.predicate = NSPredicate(format: "article_id == %@ AND isSave == %@", articleId, "1")
        
        do {
            let list = try context.fetch(request)
            for novel in list {
                deleteNovel = novel
            }
        } catch {
            NOVELLog("Failed to deleteNovel: \(error) \(articleId)")
        }
        return deleteNovel
    }
    
     class func setFields(_ novel: Novel, serverNovel: ServerNovel) {
        novel.article_id = serverNovel.article_id
        novel.article_abstract =  serverNovel.article_abstract
        novel.author = serverNovel.author
        novel.image_link = serverNovel.image_link
        novel.link = serverNovel.link
        novel.title = serverNovel.title
        novel.article_type = serverNovel.article_type

    }
    
}

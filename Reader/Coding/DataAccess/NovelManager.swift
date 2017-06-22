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
    
    class func getAll() -> [Novel] {
        
        var novels = [Novel]()
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Novel> = Novel.fetchRequest()
        
        do {
            novels = try context.fetch(request)
        } catch {
            NOVELLog("Failed to get all novels: \(error)")
        }
        return novels
    }
    
    fileprivate class func setFields(_ novel: Novel, serverNovel: ServerNovel) {
        novel.article_id = serverNovel.article_id
        novel.article_abstract =  "tt" 
        novel.author = serverNovel.author
        novel.image_link = serverNovel.image_link
        novel.link = serverNovel.link
        novel.image_link = serverNovel.image_link
    }
    
}

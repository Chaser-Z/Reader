//
//  ContentManager.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import CoreData

class ContentManager{
    
    fileprivate static let entityConetent = "Content"
    
    class func add(_ serverContent: ServerContent) -> Content? {
        
        var content: Content? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld AND article_id == %@", serverContent.id, serverContent.article_id)
        do {
            let list = try context.fetch(request)
            if list.count > 0 {
                content = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityConetent, in: context)
                content = Content(entity: entity!, insertInto: context)
            }
            
            setFields(content!, serverContent: serverContent)
            try context.save()
        } catch {
            NOVELLog("Failed to add chapter: \(error)")
        }
        return content
        
    }
    
    class func getAll(_ articleId: String) -> [Content] {
        
        var content = [Content]()
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        request.predicate = NSPredicate(format: "article_id == %@", articleId)
        
        do {
            content = try context.fetch(request)
        } catch {
            NOVELLog("Failed to get All content: \(error)")
        }
        return content
    }
    
    class func getContent(_ id: Int64, article_id: String) -> Content? {
        
        var content: Content? = nil
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld AND article_id == %@", id, article_id)
        
        do {
            let list = try context.fetch(request)
            content = list.first
        } catch {
            NOVELLog("Failed to get content: \(error)")
        }
        
        return content
    }
    
    fileprivate class func setFields(_ content: Content, serverContent: ServerContent) {
        content.article_directory = serverContent.article_directory
        content.article_directory_link =  serverContent.article_directory_link
        content.content = serverContent.content
        content.article_id = serverContent.article_id
        content.id = serverContent.id
    }
    
    
}

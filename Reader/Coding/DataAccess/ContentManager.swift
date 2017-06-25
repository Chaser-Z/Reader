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

    fileprivate static let entityChapter = "Content"
    
    class func add(_ serverContent: ServerContent) -> Content? {
        
        var content: Content? = nil
        
        let context = CoreDataManager.sharedInstance.context
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        request.predicate = NSPredicate(format: "article_directory_link == %@", serverContent.article_directory_link)
        do {
            let list = try context.fetch(request)
            if list.count > 0 {
                content = list.first
            } else {
                let entity = NSEntityDescription.entity(forEntityName: entityChapter, in: context)
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
        //request.predicate = NSPredicate(format: "article_id == %@", articleId)
        
        do {
            content = try context.fetch(request)
        } catch {
            NOVELLog("Failed to get content: \(error)")
        }
        return content
    }
    
    fileprivate class func setFields(_ content: Content, serverContent: ServerContent) {
        content.article_directory = serverContent.article_directory
        content.article_directory_link =  serverContent.article_directory_link
        content.content = serverContent.content
    }

    
}
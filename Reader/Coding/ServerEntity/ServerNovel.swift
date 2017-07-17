//
//  ServerNovel.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ServerNovel {
    
    
    var article_id: String
    var title: String?
    var author: String
    var article_abstract: String?
    var link: String
    var image_link: String
    var status: String = "0"
    var article_type: String
    
    init(article_id: String, title: String, author: String, article_abstract: String, link: String, image_link: String, article_type: String) {
        self.article_id = article_id
        self.title = title
        self.author = author
        self.article_abstract = article_abstract
        self.link = link
        self.image_link = image_link
        self.article_type = article_type
    }
    
    
}

extension ServerNovel {
    
    class func fromDict(_ dict: [String: Any]) -> ServerNovel {
        
        let article_id = dict["article_id"] as! String
        let title = dict["title"] as! String
        let author = dict["author"] as! String
        let article_abstract = dict["article_abstract"] as! String
        let link = dict["link"] as! String
        let image_link = dict["image_link"] as! String
        let article_type = dict["article_type"] as! String

        let novel = ServerNovel(article_id: article_id, title: title, author: author, article_abstract: article_abstract, link: link, image_link: image_link, article_type: article_type)
        
        
        return novel

    }
    
    
    
}




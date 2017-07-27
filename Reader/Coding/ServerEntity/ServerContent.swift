//
//  ServerContent.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ServerContent {
    
    var article_directory_link: String
    var content: String
    var article_directory: String
    var article_id: String
    var id: Int64

    init(article_directory_link: String, content: String, article_directory: String, article_id: String, id: Int64) {
        self.article_directory_link = article_directory_link
        self.content = content
        self.article_directory = article_directory
        self.article_id = article_id
        self.id = id
    }
    
    
}

extension ServerContent {
    
    class func fromDict(_ dict: [String: Any]) -> ServerContent {
        
        let article_directory_link = dict["article_directory_link"] as! String
        let content = dict["content"] as! String
        let article_directory = dict["article_directory"] as! String
        let article_id = dict["article_id"] as! String
        let id = dict["id"] as! Int64

        
        let novel_content = ServerContent(article_directory_link: article_directory_link, content: content, article_directory: article_directory, article_id: article_id, id: id)
        
        return novel_content
        
    }
    
    
}

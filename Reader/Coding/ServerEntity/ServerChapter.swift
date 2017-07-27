//
//  ServerChapter.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation

class ServerChapter {
    
    var article_directory: String
    //var article_directory_link: String
    var article_id: String
    var last_update_date: String?
    var last_update_directory: String
    //var update_status: String
    var id: Int64

//    init(article_directory: String, article_directory_link: String, article_id: String, last_update_date: String, last_update_directory: String, update_status: String) {
//        self.article_directory = article_directory
//        //self.article_directory_link = article_directory_link
//        //self.article_id = article_id
//        self.last_update_date = last_update_date
//        self.last_update_directory = last_update_directory
//        //self.update_status = update_status
//    }
    
    init(article_directory: String, last_update_date: String, last_update_directory: String, id: Int64, article_id: String) {
        self.article_directory = article_directory
        self.last_update_date = last_update_date
        self.last_update_directory = last_update_directory
        self.id = id
        self.article_id = article_id
    }


}

extension ServerChapter {
    
    class func fromDict(_ dict: [String: Any]) -> ServerChapter {
        
        let article_directory = dict["article_directory"] as! String
        //let article_directory_link = dict["article_directory_link"] as! String
        let last_update_date = dict["last_update_date"] as! String
        let article_id = dict["article_id"] as! String
        let last_update_directory = dict["last_update_directory"] as! String
        //let update_status = dict["update_status"] as! String
        let id = dict["id"] as! Int64

        //let chapter = ServerChapter(article_directory: article_directory, article_directory_link: article_directory_link, article_id: article_id, last_update_date: last_update_date, last_update_directory: last_update_directory, update_status: update_status)
        let chapter = ServerChapter(article_directory: article_directory, last_update_date: last_update_date, last_update_directory: last_update_directory, id: id, article_id: article_id)
        return chapter
    }
    
    
    
    
    
}

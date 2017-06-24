//
//  HomeViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var tView: ZHNBookShelfView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = UIColor.red
        tView = ZHNBookShelfView(frame: self.view.bounds)
        tView.delegate = self
        self.view.addSubview(tView)
        
        let novles = NovelManager.getAll()
        if novles.count > 0 {
            tView.novels = novles
            NOVELLog(novles[0].title)
            
        } else {
            NovelFacade.getNovelList { (novels) in
                let novles = NovelManager.getAll()
                self.tView.novels = novles
                NOVELLog(novles[0].title)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController: ZHNBookShelfViewDelegate {
    
    func reloadOrPushReadVC(index: Int) {
        
        var params = [String: AnyObject]()
        params["article_id"] = tView.novels[index].article_id as AnyObject

        
        let chapterList = ChapterManager.getAll(tView.novels[index].article_id)
        
        if chapterList.count > 0 {
            for chapter in chapterList {
                NOVELLog(chapter.article_directory)
            }
        } else {
            
            ChapterFacade.getChapterList(params: params, completion: { (chapters) in
                for chapter in chapters {
                    NOVELLog(chapter.article_directory)
                }
            })
        }

    }
}


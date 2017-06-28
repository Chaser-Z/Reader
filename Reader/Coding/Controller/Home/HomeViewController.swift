//
//  HomeViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
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
        
        let path = "/articleInfo/getLatestArticles"
        var params = [String: AnyObject]()

        if novles.count > 0 {
            
            let semaphore : DispatchSemaphore = DispatchSemaphore(value: 1)
            let queue = DispatchGroup()
            
            
            for novel in novles {
                let record = RecordManager.getRecord(novel.article_id)
                if record.count <= 0 {
                    continue
                }
                params["article_id"] = novel.article_id as AnyObject
                params["last_update_date"] = record[0].last_update_date as AnyObject
                
                Alamofire.request("\(HOST)\(path)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                    if let json = response.result.value {
                        if json is [String: Any] {
                            let info = json as! [String: Any]
                            let data = info["data"] as! Array<Dictionary<String, Any>>
                            let _ = semaphore.wait(timeout: DispatchTime.distantFuture)

                            print(data.count)
                            semaphore.signal()

                        }
                    }

                }

            }
        }
        
        
// let t = getData()
//        print(t)
        
        
        
//        let record = RecordManager.getRecord("0_703")
//        NOVELLog(record[0].article_directory)
//        NOVELLog(record[0].article_id)
//        NOVELLog(record[0].last_update_date)
//        NOVELLog(record[0].article_directory_link)
//        NOVELLog(record[0].content)
//        NOVELLog(record[0].currentPage)
//        NOVELLog(record[0].pageCount)
//        NOVELLog(record[0].currentChapterIndex)

    }
    
    fileprivate func getData() -> Int {
        let path = "/articleInfo/getLatestArticles"
        var params = [String: AnyObject]()
var t = 10
        params["article_id"] = "0_703" as AnyObject
        params["last_update_date"] = "2017-06-14" as AnyObject
        let semaphore : DispatchSemaphore = DispatchSemaphore(value: 1)
        
        let group = DispatchGroup()
        
        
        
        group.notify(queue: DispatchQueue.main) { 
            
//        }
//        DispatchQueue.global().async {
        
        
        
        Alamofire.request("\(HOST)\(path)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            print("11")
            t = 20
            semaphore.signal()
            
        }
        
        }
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return t


    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController: ZHNBookShelfViewDelegate {
    
    func reloadOrPushReadVC(index: Int) {
        
        let vc = ZHNReadController()
        vc.novelID = tView.novels[index].article_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


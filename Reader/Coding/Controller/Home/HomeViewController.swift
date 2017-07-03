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
        
        // 获取小说目录
        let novles = NovelManager.getAll()
        // 本地
        if novles.count > 0 {
            tView.novels = novles
            NOVELLog(novles[0].title)
            
        } else { // 网络
            NovelFacade.getNovelList { (novels) in
                let novles = NovelManager.getAll()
                self.tView.novels = novles
                NOVELLog(novles[0].title)
            }
        }
        
        
        for _ in 0..<novles.count {
            tView.remindArr.append(0)
        }
        
        // 小说更新
        let path = "/articleInfo/getLatestArticles"
        var params = [String: AnyObject]()

        if novles.count > 0 {
            
            for (index,novel) in novles.enumerated() {
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
                            //NOVELLog(data)
                            print(data.count)
                            self.tView.remindArr[index] = data.count
                            //print(self.tView.remindArr)
                            //if index == novles.count - 1 {
                                self.tView.reloadData()
                            //}
                        }
                    }

                }

            }
        }
        
        
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController: ZHNBookShelfViewDelegate {
    
    func reloadOrPushReadVC(index: Int) {
        
        let vc = ZHNReadController()
        vc.novelID = tView.novels[index].article_id
        if tView.remindArr[index]  > 0{
            vc.isUpdate = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


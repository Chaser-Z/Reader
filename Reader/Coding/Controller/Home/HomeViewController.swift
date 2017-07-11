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

    fileprivate var tView: ZHNBookShelfView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let path = "/article/getArticleByType"
        var params = [String: AnyObject]()
        params["article_type"] = "玄幻" as AnyObject
        Alamofire.request("\(HOST)\(path)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            NOVELLog(response)
        }

        self.view.backgroundColor = UIColor.red
        print(self.view.frame)
        tView = ZHNBookShelfView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 49 - 64))
        tView.delegate = self
        self.view.addSubview(tView)
        
        // 获取小说目录
        let novles = NovelManager.getAll()
//        // 本地
//        if novles.count > 0 {
//            tView.novels = novles
//            NOVELLog(novles[0].title)
//            for _ in 0..<novles.count {
//                self.tView.remindArr.append(0)
//            }
//            self.tView.reloadData()
//            checkoutNovelUpdate()
//
//        } else { // 网络
        
        
        
//        let semaphore = DispatchSemaphore(value: 1)
//        DispatchQueue.global(qos: .userInitiated).sync {
//            
//            NovelFacade.getNovelList { (novels) in
//                let novles = NovelManager.getAll()
//                self.tView.novels = novles
//                NOVELLog(novles[0].title)
//                for _ in 0..<novles.count {
//                    self.tView.remindArr.append(0)
//                }
//                NOVELLog("222222222")
//                self.tView.reloadData()
//                self.checkoutNovelUpdate()
//                semaphore.signal()
//            }
//        //}
//            let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//            print("11111111")
//        }

        
//        let group = DispatchGroup()
//        
//        let queue = DispatchQueue(label: "com")
//        
//        queue.async(group: group) {
//            NovelFacade.getNovelList { (novels) in
//                let novles = NovelManager.getAll()
//                self.tView.novels = novles
//                NOVELLog(novles[0].title)
//                for _ in 0..<novles.count {
//                    self.tView.remindArr.append(0)
//                }
//                NOVELLog("222222222")
//                self.tView.reloadData()
//                self.checkoutNovelUpdate()
//            }
//
//        }

        //let semaphore = DispatchSemaphore(value: 1)
        
        //let queue = DispatchQueue.global()
        
        //queue.async {
            //let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        DispatchQueue.main.async {
            
            NovelFacade.getNovelList { (novels) in
                let novles = NovelManager.getAll()
                self.tView.novels = novles
                NOVELLog(novles[0].title)
                for _ in 0..<novles.count {
                    self.tView.remindArr.append(0)
                }
                //flag = false
                self.tView.reloadData()
                self.checkoutNovelUpdate()
            }
            //semaphore.signal()
        //}
        }

//        while flag {
//            RunLoop.current.acceptInput(forMode: .defaultRunLoopMode, before: NSDate.distantFuture)
//        }

//        let content = ContentManager.getContent("/0_703/7504946.html")
//        NOVELLog(content?.content)
//        
//        print("什么")
        
        
    }
    
    
    private func checkoutNovelUpdate() {
        
        // 小说更新
        let path = "/articleInfo/getLatestArticles"
        var params = [String: AnyObject]()
        
        if tView.novels.count > 0 {
            
            for (index,novel) in tView.novels.enumerated() {
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
                            NOVELLog(data)
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
        self.tView.remindArr[index] = 0
        self.tView.reloadData()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


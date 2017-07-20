//
//  BookShelfViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/17.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire

class BookShelfViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{

    fileprivate var tView: ZHNBookShelfView!
    private var novels = [Novel]()
    
    private var bookShelfObserver: NSObjectProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "书架"
        registerNotificationObservers()
        getNovels()
//        print(self.view.frame)
//        tView = ZHNBookShelfView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 49 - 64))
//        tView.delegate = self
//        //self.view.addSubview(tView)
//        
//        // 获取小说目录
//        let novles = NovelManager.getAll()
//        DispatchQueue.main.async {
//            
//            NovelFacade.getNovelList { (novels) in
//                let novles = NovelManager.getAll()
//                self.tView.novels = novles
//                NOVELLog(novles[0].title)
//                for _ in 0..<novles.count {
//                    self.tView.remindArr.append(0)
//                }
//                //flag = false
//                self.tView.reloadData()
//                self.checkoutNovelUpdate()
//            }
//        }

    }
    
    private func getNovels() {
        
        self.novels = [Novel]()
        let novels = NovelManager.getAll()
        self.novels = novels
        for novel in novels {
            NOVELLog(novel.title)
        }
        
        self.collectionView?.reloadData()
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
    
    private func registerNotificationObservers() {
        
        let center = NotificationCenter.default
        bookShelfObserver = center.addObserver(forName: bookShelfNotificationName, object: nil, queue: OperationQueue.main) { [weak self] notification in
            print("dsj;fjlejflewjfljwefljewlfjwlejflwekf")
            self?.getNovels()
        }
    }
    
    deinit {
        let center = NotificationCenter.default
        if let observer = bookShelfObserver {
            center.removeObserver(observer)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return novels.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookShelfCell", for: indexPath) as! BookShelfCell
        
        var novel: Novel?
        var isEditing = false
        var isPlaceholder = false
        
        if indexPath.row < novels.count {
            novel = novels[indexPath.row]
            isPlaceholder = false
        } else {
            novel = nil
            isEditing = false
            isPlaceholder = true
        }
        
        cell.setup(novel: novel, isEditing: isEditing, isPlaceholder: isPlaceholder)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if is4InchPhone() {
            return CGSize(width: 85.0, height: 160)
        } else {
            return CGSize(width: 100.0, height: 160.0)
        }
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < novels.count {
            let vc = ZHNReadController()
            vc.novel = novels[indexPath.row]
            vc.novelID = novels[indexPath.row].article_id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController")
            navigationController?.pushViewController(controller, animated: false)
        }
    }
}

extension BookShelfViewController: ZHNBookShelfViewDelegate {
    
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

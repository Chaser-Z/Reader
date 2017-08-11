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

    fileprivate var novels = [Novel]()
    fileprivate var novelTitles = [String]()
    fileprivate var isNovelEditing = false
    fileprivate var updateCounts = [Int]()
    private var bookShelfObserver: NSObjectProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "书架"
        addGesture()
        registerNotificationObservers()
        getNovels()
        checkoutNovelUpdate()
    }
    
    private func addButtonItem() {
        let cancelBar = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelBar
        
        let doneBar = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBar
    }
    
    private func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressMethod(_:)))
        self.collectionView?.addGestureRecognizer(longPress)
    }
    
    // MARK: - GestureMethod
    @objc fileprivate func longPressMethod(_ gesture: UILongPressGestureRecognizer) {
        self.isNovelEditing = true
        addButtonItem()
        self.title = "正在删除藏书..."
        print("longPressMethod")
        self.collectionView?.reloadData()
    }
    
    // MARK: - Action
    @objc private func cancel() {
        self.title = "书架"
        novelTitles = [String]()
        getNovels()
        self.isNovelEditing = false
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.collectionView?.reloadData()
    }
    
    @objc private func done() {
        self.title = "书架"
        for article_id in novelTitles {
            if article_id != "" {
                NovelManager.deleteNovel(article_id)
            }
        }
        novelTitles = [String]()
        getNovels()
        
        self.isNovelEditing = false
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.collectionView?.reloadData()
    }
    
    private func getNovels() {
        
        self.novels = [Novel]()
        let novels = NovelManager.getAll()
        self.novels = novels
        for novel in novels {
            novelTitles.append("")
            updateCounts.append(0)
            NOVELLog(novel.title)
        }
        updateCounts.append(0)
        self.collectionView?.reloadData()
    }

    private func checkoutNovelUpdate() {
        
        // 小说更新
        let path = "/articleInfo/getLatestArticles"
        var params = [String: AnyObject]()
        
        if self.novels.count > 0 {
            
            for (index,novel) in self.novels.enumerated() {
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
                            self.updateCounts[index] = data.count
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    private func registerNotificationObservers() {
        
        let center = NotificationCenter.default
        bookShelfObserver = center.addObserver(forName: bookShelfNotificationName, object: nil, queue: OperationQueue.main) { [weak self] notification in
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
            isEditing = self.isNovelEditing
        } else {
            novel = nil
            isEditing = false
            isPlaceholder = true
        }
        cell.setup(novel: novel, isEditing: isEditing, isPlaceholder: isPlaceholder, index: indexPath.row, updateCount: updateCounts[indexPath.row])
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPad() {
            return CGSize(width: 152.0, height: 242.0)
        } else {
            if is4InchPhone() {
                return CGSize(width: 85.0, height: 136.0)
            } else {
                return CGSize(width: 100.0, height: 160.0)
            }
        }
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isNovelEditing {
            
        } else {
            if indexPath.row < novels.count {
                let vc = ZHNReadController()
                vc.novel = novels[indexPath.row]
                vc.novelID = novels[indexPath.row].article_id
                if updateCounts[indexPath.row]  > 0 {
                    vc.isUpdate = true
                }
                self.updateCounts[indexPath.row] = 0
                vc.isShelfVC = true
                self.collectionView?.reloadData()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
                let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController")
                navigationController?.pushViewController(controller, animated: false)
            }
        }
    }
}

extension BookShelfViewController: BookShelfCellDelegate {
    
    func deleteNovel(_ novel: Novel?, isDelete: Bool, index: Int) {
        if isDelete {
            novelTitles[index] = (novel?.article_id)!
            NOVELLog("删除" + (novel?.title)!)
        } else {
            novelTitles[index] = ""
            NOVELLog("添加" + (novel?.title)!)
        }
    }
}

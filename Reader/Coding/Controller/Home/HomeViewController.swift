//
//  HomeViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/14.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
private let reuseIdentifier = "Cell"

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let headerViewTitles = ["热门","玄幻","修真","都市","历史","网游","科幻","恐怖","全本"]
    fileprivate var hotNovels = [Novel]()
    fileprivate var fantasyNovels = [Novel]()
    fileprivate var coatardNovels = [Novel]()
    fileprivate var cityNovels = [Novel]()
    fileprivate var historyNovels = [Novel]()
    fileprivate var onlineNovels = [Novel]()
    fileprivate var scienceNovels = [Novel]()
    fileprivate var terrorNovels = [Novel]()
    fileprivate var completeNovels = [Novel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NovelFacade.getHomeNovelList { (novels) in
            
            for novel in novels {
                switch novel.article_type {
                case "热门":
                    self.hotNovels.append(novel)
                case "玄幻":
                    self.fantasyNovels.append(novel)
                case "修真":
                    self.coatardNovels.append(novel)
                case "都市":
                    self.cityNovels.append(novel)
                case "历史":
                    self.historyNovels.append(novel)
                case "网游":
                    self.onlineNovels.append(novel)
                case "科幻":
                    self.scienceNovels.append(novel)
                case "恐怖":
                    self.terrorNovels.append(novel)
                case "全本":
                    self.completeNovels.append(novel)
                default:
                    NOVELLog("未知错误")
                }
            }
            self.collectionView?.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController {
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerViewTitles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return hotNovels.count
        case 1:
            return fantasyNovels.count
        case 2:
            return coatardNovels.count
        case 3:
            return cityNovels.count
        case 4:
            return historyNovels.count
        case 5:
            return onlineNovels.count
        case 6:
            return scienceNovels.count
        case 7:
            return terrorNovels.count
        case 8:
            return completeNovels.count
        default:
            return 0
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        switch indexPath.section {
        case 0:
            cell.setup(novel: hotNovels[indexPath.row])
        case 1:
            cell.setup(novel: fantasyNovels[indexPath.row])
        case 2:
            cell.setup(novel: coatardNovels[indexPath.row])
        case 3:
            cell.setup(novel: cityNovels[indexPath.row])
        case 4:
            cell.setup(novel: historyNovels[indexPath.row])
        case 5:
            cell.setup(novel: onlineNovels[indexPath.row])
        case 6:
            cell.setup(novel: scienceNovels[indexPath.row])
        case 7:
            cell.setup(novel: terrorNovels[indexPath.row])
        case 8:
            cell.setup(novel: completeNovels[indexPath.row])
        default:
            NOVELLog("---")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if is4InchPhone() {
            return CGSize(width: 85.0, height: 160)
        } else {
            return CGSize(width: 100.0, height: 160.0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: HomeReusableView?
        if kind == "UICollectionElementKindSectionHeader" {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderView", for: indexPath) as? HomeReusableView 
        }
        headerView?.typeLabel.text = headerViewTitles[indexPath.section]
        
        return headerView!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        var novleID = ""
        
        switch indexPath.section {
        case 0:
            novleID = hotNovels[indexPath.row].article_id
        case 1:
            novleID = fantasyNovels[indexPath.row].article_id
        case 2:
            novleID = coatardNovels[indexPath.row].article_id
        case 3:
            novleID = cityNovels[indexPath.row].article_id
        case 4:
            novleID = historyNovels[indexPath.row].article_id
        case 5:
            novleID = onlineNovels[indexPath.row].article_id
        case 6:
            novleID = scienceNovels[indexPath.row].article_id
        case 7:
            novleID = terrorNovels[indexPath.row].article_id
        case 8:
            novleID = completeNovels[indexPath.row].article_id
        default:
            print("++")
        }

        
        let vc = ZHNReadController()
        vc.novelID = novleID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//
//  HomeViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/14.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import DZNEmptyDataSet

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let headerViewTitles = ["热门","玄幻","修真","都市","历史","网游","科幻","恐怖","全本"]
    fileprivate var wholeNovels = [[Novel]]()
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
        setupSearchView()
        loadData()
    }
    
    private func setupSearchView() {
        
        if let searchView = SearchView.newInstance() {
            let contentView = UIView(frame: CGRect(x: 5, y: 0, width: ScreenWidth - 10, height: 30))
            self.navigationItem.titleView = contentView
            
            if kVersion >= 11.0 {
                searchView.frame = CGRect(x: 0, y: (44 - 30) / 2, width: contentView.width - 5, height: 30)
            } else {
                searchView.frame = CGRect(x: 0, y: 0, width: contentView.width - 5, height: 30)
            }
            contentView.addSubview(searchView)
            searchView.searchTextField.text = "搜一搜"
            searchView.delegate = self
        }
    }
    
    fileprivate func loadData() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.removeFromSuperViewOnHide = true
        hud?.mode = .indeterminate
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
            

            if self.hotNovels.count > 0 {
                self.wholeNovels.append(self.hotNovels)
            }
            
            if self.fantasyNovels.count > 0 {
                self.wholeNovels.append(self.fantasyNovels)
            }
            
            if self.coatardNovels.count > 0 {
                self.wholeNovels.append(self.coatardNovels)
            }
            
            if self.cityNovels.count > 0 {
                self.wholeNovels.append(self.cityNovels)
            }
            
            if self.historyNovels.count > 0 {
                self.wholeNovels.append(self.historyNovels)
            }
            
            if self.onlineNovels.count > 0 {
                self.wholeNovels.append(self.onlineNovels)
            }
            
            if self.scienceNovels.count > 0 {
                self.wholeNovels.append(self.scienceNovels)
            }
            
            if self.terrorNovels.count > 0 {
                self.wholeNovels.append(self.terrorNovels)
            }
            
            if self.completeNovels.count > 0 {
                self.wholeNovels.append(self.completeNovels)
            }
            
            hud?.hide(true)
            self.collectionView?.emptyDataSetSource = self
            self.collectionView?.emptyDataSetDelegate = self
            self.collectionView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController {
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return wholeNovels.count
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
        headerView?.moreButton.tag = indexPath.section
        headerView?.delegate = self
        return headerView!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        var novleID = ""
        var novel: Novel?
        switch indexPath.section {
        case 0:
            novleID = hotNovels[indexPath.row].article_id
            novel = hotNovels[indexPath.row]
        case 1:
            novleID = fantasyNovels[indexPath.row].article_id
            novel = fantasyNovels[indexPath.row]
        case 2:
            novleID = coatardNovels[indexPath.row].article_id
            novel = coatardNovels[indexPath.row]
        case 3:
            novleID = cityNovels[indexPath.row].article_id
            novel = cityNovels[indexPath.row]
        case 4:
            novleID = historyNovels[indexPath.row].article_id
            novel = historyNovels[indexPath.row]
        case 5:
            novleID = onlineNovels[indexPath.row].article_id
            novel = onlineNovels[indexPath.row]
        case 6:
            novleID = scienceNovels[indexPath.row].article_id
            novel = scienceNovels[indexPath.row]
        case 7:
            novleID = terrorNovels[indexPath.row].article_id
            novel = terrorNovels[indexPath.row]
        case 8:
            novleID = completeNovels[indexPath.row].article_id
            novel = completeNovels[indexPath.row]
        default:
            print("++")
        }
        
        let vc = ZHNReadController()
        vc.novelID = novleID
        vc.novel = novel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: SearchViewDelegate {
    
    func searchButtonPress() {
        let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController")
        navigationController?.pushViewController(controller, animated: false)
    }
    
}

extension HomeViewController: HomeReusableViewDelegate {
    
    func moreButton(btn: UIButton) {
        print(btn.tag)
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        controller.type = headerViewTitles[btn.tag]
        navigationController?.pushViewController(controller, animated: false)
        
    }
    
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "请检查网络是否正常,点击下面按钮重新加载"
        return StringUtil.attributeStringFromString(
            string: text,
            alignment: .center,
            color: .blue,
            lineSpacing: 5.0,
            fontSize: 16.0
        )
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "not_net")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        loadData()
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        return UIImage(named: "again")
    }
    
}

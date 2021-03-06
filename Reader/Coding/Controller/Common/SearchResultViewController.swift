//
//  SearchResultViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class SearchResultViewController: UITableViewController {

    let kCloseCellHeight: CGFloat = 50
    let kOpenCellHeight: CGFloat = 330
    var cellHeights = [CGFloat]()
    var cellAbstracts = [CGFloat]()

    
    var searchView = SearchDetailView.newInstance()
    fileprivate var novels = [Novel]()
    var searchContentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        
        setup()
        //inhibitPop()
        
        if let mySearchView = searchView {
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth , height: 30))
            searchContentView = contentView
            self.navigationItem.titleView = contentView
            mySearchView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 30)
            contentView.addSubview(mySearchView)
            mySearchView.searchTextField.placeholder = "请输入小说名称"
            mySearchView.delegate = self
        }
       
        //self.navigationItem.titleView = searchView!
    }
    
    fileprivate func setup() {
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    // 禁止系统滑动返回
    private func inhibitPop() {
        let target = self.navigationController?.interactivePopGestureRecognizer
        let pan = UIPanGestureRecognizer(target: target, action: nil)
        self.view.addGestureRecognizer(pan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchContentView.isHidden = false
        searchView?.searchTextField.becomeFirstResponder()
        if let mySearchView = searchView {
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth , height: 30))
            searchContentView = contentView
            self.navigationItem.titleView = contentView
            mySearchView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 30)
            contentView.addSubview(mySearchView)
            mySearchView.searchTextField.placeholder = "请输入小说名称"
            mySearchView.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        searchContentView.isHidden = true
    }
    
    fileprivate func widthForLabel(text: String, font: UIFont) -> CGFloat {
        let size = CGSize(width:1000, height:1000)
        let dic = [NSFontAttributeName : font]
        let stringSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return stringSize.height
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchView?.searchTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - TableView
extension SearchResultViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.novels.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(byIsSelected: false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(byIsSelected: true, animated: false, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath) as! DemoCell
        cell.delegate = self
        cell.setup(self.novels[indexPath.row], index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchView?.searchTextField.resignFirstResponder()
        let cell = tableView.cellForRow(at: indexPath) as! DemoCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(byIsSelected: true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(byIsSelected: false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    
}

extension SearchResultViewController: SearchDetailViewDelegate {
    
    func cancelButtonPress() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func searchTextFieldShouldReturn(_ textField: UITextField) {
        NOVELLog(textField.text)
    }
    
    func searchEditingChanged(_ textField: UITextField) {
        
        guard let keyword = textField.text else {
            return
        }
        
        NovelFacade.searchNovelByKeyword(keyword) { [weak self] list in
            DispatchQueue.main.async {
                self?.novels = []
                self?.novels += list
                
                for novel in list {
                    
                    let height = self?.widthForLabel(text: novel.article_abstract!, font: UIFont.systemFont(ofSize: 13))
                    
                    self?.cellAbstracts.append((self?.kOpenCellHeight)! + height!)
                    //Array(repeating: (self?.kOpenCellHeight)! + height!, count: (self?.novels.count)!)
                    NOVELLog(novel.title)
                }
                self?.cellHeights = Array(repeating: (self?.kCloseCellHeight)!, count: (self?.novels.count)!)

                self?.setup()
                self?.tableView.emptyDataSetSource = self
                self?.tableView.emptyDataSetDelegate = self
                self?.tableView.reloadData()
            }
        }
        
    }
}

extension SearchResultViewController: DemoCellDelegate {
    
    func readButtonClick(_ index: Int) {
        
        let vc = ZHNReadController()
        vc.novelID = novels[index].article_id
        vc.novel = novels[index]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

extension SearchResultViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "没有找到这部小说，没关系，快去意见反馈告诉程序员哥哥，让程序员哥哥为您添加吧!"
        return StringUtil.attributeStringFromString(
            string: text,
            alignment: .center,
            color: .blue,
            lineSpacing: 5.0,
            fontSize: 16.0
        )
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -150
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }


}



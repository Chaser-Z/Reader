//
//  MoreViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/8/14.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MBProgressHUD

class MoreViewController: UITableViewController {

    var type: String?
    fileprivate var novels = [Novel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 190
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    fileprivate func loadData() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.removeFromSuperViewOnHide = true
        hud?.mode = .indeterminate
        
        var params = [String: AnyObject]()
        params["article_type"] = type as AnyObject?
        
        NovelFacade.getNovelByType(params: params) { (novels) in
            self.novels = novels
            hud?.hide(true)
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.reloadData()
        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return novels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
        cell.setup(self.novels[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ZHNReadController()
        vc.novel = novels[indexPath.row]
        vc.novelID = novels[indexPath.row].article_id
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MoreViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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

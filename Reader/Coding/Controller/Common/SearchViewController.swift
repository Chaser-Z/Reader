//
//  SearchViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class SearchViewController: UISearchController {

    lazy var hasFindCancelBtn: Bool = {
        return false
    }()
    lazy var link: CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(findCancel))
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        searchBar.barTintColor = RGBA(0.94, 0.94, 0.96)
        //self.view.backgroundColor = UIColor.blue
        // 搜索框
        searchBar.barStyle = .default
        searchBar.tintColor = RGBA(0.12, 0.74, 0.13)
        // 去除上下两条横线
        searchBar.setBackgroundImage(RGBA(0.94, 0.94, 0.96).trans2Image(), for: .any, barMetrics: .default)
        // 右侧语音
        searchBar.showsBookmarkButton = true
        //searchBar.setImage(#imageLiteral(resourceName: "VoiceSearchStartBtn"), for: .bookmark, state: .normal)
        
        searchBar.delegate = self
        
    }
    
    func findCancel() {
        let btn = searchBar.value(forKey: "_cancelButton") as AnyObject
        if btn.isKind(of: NSClassFromString("UINavigationButton")!) {
            print("就是它")
            link.invalidate()
            link.remove(from: RunLoop.current, forMode: .commonModes)
            hasFindCancelBtn = true
            let cancel = btn as! UIButton
            cancel.setTitleColor(RGBA(0.12, 0.74, 0.13), for: .normal)
            //cancel.setTitleColor(UIColor.orange, for: .highlighted)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置状态栏颜色
        UIApplication.shared.statusBarStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension SearchViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("点击了语音按钮")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      
        if !hasFindCancelBtn {
            link.add(to: RunLoop.current, forMode: .commonModes)
        }
    }
}

extension UIColor {
    func trans2Image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage ?? UIImage()
    }
}

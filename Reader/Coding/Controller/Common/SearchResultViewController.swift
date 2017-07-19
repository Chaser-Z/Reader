//
//  SearchResultViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    var searchView = SearchDetailView.newInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true

        inhibitPop()
        searchView?.searchTextField.text = ""
        searchView?.delegate = self
        self.navigationItem.titleView = searchView!
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        NOVELLog(textField.text)
    }
}

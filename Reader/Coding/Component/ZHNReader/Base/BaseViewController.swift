//
//  BaseViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    /// 状态栏是否显示白色
    var isStatusBarLightContent:Bool = false
    
    /// 设置状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isStatusBarLightContent {
            return .lightContent
        } else {
            return .default
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

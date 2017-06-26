//
//  ZHNBaseViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNBaseViewController: UIViewController {

    /// 状态栏是否显示白色
    var isStatusBarLightContent:Bool = false {
        
        didSet{
            
            if isStatusBarLightContent != oldValue {
                
                setStatusBarStyle()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        // 设置状态栏颜色
        setStatusBarStyle()
    }

    /// 设置状态栏颜色
    private func setStatusBarStyle() {
        
        if isStatusBarLightContent {
            
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
            
        }else{
            
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

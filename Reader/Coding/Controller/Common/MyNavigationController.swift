//
//  MyNavigationController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = .default
        self.navigationBar.barTintColor = DefaultColor
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension UIViewController {
    
    var contentViewController: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController
        }
        
        return self
    }
    
}

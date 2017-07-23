//
//  DisclaimerViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/22.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

    @IBOutlet weak var mianLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "免责声明"

        
        self.mianLabel.text = "这款APP只用于娱乐，如果侵犯您的权益，请您联系我。邮箱: 18330570306@163.com"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

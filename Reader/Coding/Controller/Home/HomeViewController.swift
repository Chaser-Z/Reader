//
//  HomeViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = UIColor.red
        let tView = ZHNBookShelfView(frame: self.view.bounds)
        self.view.addSubview(tView)
        
        let novles = NovelManager.getAll()
        if novles.count > 0 {
            tView.novels = novles
            NOVELLog(novles[0].title)
            
        } else {
            NovelFacade.getNovelList { (novels) in
                let novles = NovelManager.getAll()
                tView.novels = novles
                NOVELLog(novles[0].title)
            }
        }
        //tView.reloadData()
        
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

//
//  ViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import SDWebImage
class ViewController: BaseViewController {

    var novelImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        novelImageView = UIImageView()
        novelImageView.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        view.addSubview(novelImageView)
        let novles = NovelManager.getAll()
        if novles.count > 0 {
            novelImageView.sd_setImage(with: URL(string: novles[0].image_link))
            NOVELLog(novles[0].title)
            
        } else {
            NovelFacade.getNovelList { (novels) in
                print(novels)
            }
        }
        
//        // 标题
//        title = "DZMeBookRead"
//        
//        // 跳转
//        let button = UIButton(type: .custom)
//        button.setTitle("点击阅读", for: .normal)
//        button.backgroundColor = UIColor.green
//        button.addTarget(self, action: #selector(read), for: .touchDown)
//        view.addSubview(button)
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)

        
    }

    // 跳转
    func read() {
        
        //MBProgressHUD.showMessage("本地文件第一次解析慢,以后就会秒进了")
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        
        ReadParser.ParserLocalURL(url: url!) {[weak self] (readModel) in
            
            //MBProgressHUD.hide()
            
            let readController = ReadController()
            
            readController.readModel = readModel
            
            self?.navigationController?.pushViewController(readController, animated: true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


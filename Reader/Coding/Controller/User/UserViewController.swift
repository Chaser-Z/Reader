//
//  UserViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
class UserViewController: UIViewController {

    var infoModels = [InfoModel]()
    var content: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple
        
        
        let path = "/articleInfo/getLatestArticles"
        
        var params = [String: AnyObject]()
        params["article_id"] = "0_703" as AnyObject
        params["last_update_date"] = "2017-06-19" as AnyObject

        NOVELLog(params)
        Alamofire.request("\(HOST)\(path)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            NOVELLog("response = \(response)")
            
            if let json = response.result.value {
                if json is [String: Any] {
                    let info = json as! [String: Any]
                    let data = info["data"] as! Array<Dictionary<String, Any>>
                    print(data.count)
                    for dict in data {
                        let info = InfoModel()
                        info.airicle_directory = dict["article_directory"] as! String
                        info.article_directory_link = dict["article_directory_link"] as! String
                        info.last_update_directory = dict["last_update_directory"] as! String
                        info.title = dict["title"] as! String
                        self.infoModels.append(info)
                    }
                    
                }
            }
            
        }

        
        
//        Alamofire.request("\(HOST)\(path1)", method: .post, parameters: params1, encoding: JSONEncoding.default).responseJSON { response in
//            if let json = response.result.value {
//                if json is [String: Any] {
//                    let info = json as! [String: Any]
//                    let data = info["data"] as! Dictionary<String, Any>
//                    self.content = data["content"] as! String
//                }
//            }
//        }
        
        // 跳转
        let button = UIButton(type: .custom)
        button.setTitle("点击阅读", for: .normal)
        button.backgroundColor = UIColor.green
        //button.addTarget(self, action: #selector(read), for: .touchDown)
        view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

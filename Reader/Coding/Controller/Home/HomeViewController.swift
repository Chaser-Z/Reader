//
//  HomeViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/14.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
private let reuseIdentifier = "Cell"

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = "/article/getHomeArticle"
        var params = [String: AnyObject]()
        params["article_type"] = "玄幻" as AnyObject
        Alamofire.request("\(HOST)\(path)", method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON { response in
            NOVELLog(response)

            if let json = response.result.value {
                if json is [String: Any] {
                    let info = json as! [String: Any]
                    let data = info["data"] as! Array<Dictionary<String, Any>>
                    NOVELLog(data)
                    print(data.count)
                    //print(self.tView.remindArr)
                    //if index == novles.count - 1 {
                    //}
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController {
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if is4InchPhone() {
            return CGSize(width: 85.0, height: 136.0)
        } else {
            return CGSize(width: 100.0, height: 160.0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: HomeReusableView?
        if kind == "UICollectionElementKindSectionHeader" {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderView", for: indexPath) as? HomeReusableView 
        }
        switch indexPath.section {
        case 0:
            headerView?.typeLabel.text = "玄幻"
        case 1:
            headerView?.typeLabel.text = "热门"
        case 2:
            headerView?.typeLabel.text = "裙摆"
        case 3:
            headerView?.typeLabel.text = "幻"
        default:
            headerView?.typeLabel.text = "空"

        }
        
        return headerView!
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    

}

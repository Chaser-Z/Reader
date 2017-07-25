//
//  LeadPageViewController.swift
//  LeadPage
//
//  Created by yeeaoo on 16/6/27.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class LeadPageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    // 存放图片数组
    var imagesArray: Array<String>!
    // 引导页后跳转的Controller
    var controller: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCollectionView()
        
        
    }
    fileprivate func addCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        // 设置cell大小
        layout.itemSize = self.view.bounds.size
        // 设置滑动方向
        layout.scrollDirection = .horizontal
        // 设置间距
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        // 隐藏滚动条
        collectionView.showsHorizontalScrollIndicator = false
        // 设置分页效果
        collectionView.isPagingEnabled = true
        // 设置弹簧效果
        collectionView.bounces = false
        self.view.addSubview(collectionView)
        
        collectionView.register(LeadPageCell.self, forCellWithReuseIdentifier: "LeadPageCell")
        
    }
    //MARK: - UICollectionViewDataSource && UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imagesArray.count
 
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeadPageCell", for: indexPath) as! LeadPageCell
        cell.bgImageView.image = UIImage(named: self.imagesArray[(indexPath as NSIndexPath).row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == self.imagesArray.count - 1 {
            
            self.present(self.controller, animated: true, completion: nil)
            //self.navigationController?.pushViewController(self.controller, animated: true)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

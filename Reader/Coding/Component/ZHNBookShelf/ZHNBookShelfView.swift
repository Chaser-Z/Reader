//
//  ZHNBookShelfView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol ZHNBookShelfViewDelegate {
    func reloadOrPushReadVC(index: Int)
}


class ZHNBookShelfView: UIView {

    private var collectionView: UICollectionView!
    var isShow = false
    var delegate: ZHNBookShelfViewDelegate!
    var remindArr = Array<Int>()
    var novels = [Novel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI() {
        addCollectionView()
    }
    
    fileprivate func addCollectionView() {
        
        let flowLayout: ZHNLayout = ZHNLayout()
        flowLayout.itemSize = CGSize(width: self.cellWidth(), height: cellHeight())
        flowLayout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        if is4InchPhone() {
            self.collectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "4Inchbookshelfback.png"))
        }
        if is4_7InchPhone() {
            self.collectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "4_7Inchbookshelfback.png"))
        }
        if is5_5InchPhone() {
            self.collectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "5_5Inchbookshelfback.png"))
        }
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UINib(nibName: "ZHNBookShelfCell", bundle: nil), forCellWithReuseIdentifier: "ZHNBookShelfCell")
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
        
    }
    
    // 卡片宽度
    fileprivate func cellWidth() -> CGFloat {
        return self.bounds.size.width / 3.0
    }
    
    // 卡片长度
    fileprivate func cellHeight() -> CGFloat {
        return (self.bounds.size.height - 64) / 3.0
    }
    
    func reloadData() {
        collectionView.reloadData()
    }

}

extension ZHNBookShelfView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return novels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let bookShelfCell: ZHNBookShelfCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZHNBookShelfCell", for: indexPath) as! ZHNBookShelfCell
        //        courseCell.backgroundColor = UIColor.purple
        //        courseCell.alpha = 0.5
        
        bookShelfCell.setup(novels[indexPath.row])
        bookShelfCell.setupRemind(remindArr[indexPath.row])
        return bookShelfCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        //reloadData()
        delegate.reloadOrPushReadVC(index: indexPath.row)
    }
    
    
    
    
    
}

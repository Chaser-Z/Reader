//
//  ZHNLayout.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNLayout: UICollectionViewFlowLayout {

    override func prepare() {
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
}

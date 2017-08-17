//
//  HomeReusableView.swift
//  Reader
//
//  Created by 张海南 on 2017/7/16.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol HomeReusableViewDelegate: class {
    func moreButton(btn: UIButton)
}


class HomeReusableView: UICollectionReusableView {
        
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    weak var delegate: HomeReusableViewDelegate?
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        let btn = sender as! UIButton
        
        if let delegate = self.delegate {
            delegate.moreButton(btn: btn)
        }
    }
    
}

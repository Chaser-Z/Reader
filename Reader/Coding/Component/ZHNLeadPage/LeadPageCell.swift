//
//  LeadPageCell.swift
//  LeadPage
//
//  Created by yeeaoo on 16/6/27.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class LeadPageCell: UICollectionViewCell {
    
    var bgImageView: UIImageView!
    
    override init(frame: CGRect) {
       
        super.init(frame: frame)
        
        self.bgImageView = UIImageView(frame: self.bounds)
        self.contentView.addSubview(self.bgImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

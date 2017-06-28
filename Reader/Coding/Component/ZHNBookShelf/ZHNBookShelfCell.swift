//
//  ZHNBookShelfCell.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNBookShelfCell: UICollectionViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var remindLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        
        infoLabel.backgroundColor = UIColor.brown
        infoLabel.alpha = 0.7
    }
    
    func setup(_ novel: Novel) {
        
        infoLabel.text = "作者:\(novel.author)"
        backImageView.sd_setImage(with: URL(string: novel.image_link))
        
    }
}

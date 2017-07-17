//
//  HomeCell.swift
//  Reader
//
//  Created by 张海南 on 2017/7/16.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(novel: Novel) {
        self.imageView.sd_setImage(with: URL(string: novel.image_link))
        self.authorLabel.text = novel.author
        self.titleLabel.text = novel.title
    }
    
}

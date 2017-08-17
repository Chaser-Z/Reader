//
//  MoreCell.swift
//  Reader
//
//  Created by 张海南 on 2017/8/14.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {

    @IBOutlet weak var novelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    //@IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(_ novel: Novel) {
        
        novelImageView.sd_setImage(with: URL(string: novel.image_link))
        titleLabel.text = novel.title
        authorLabel.text = novel.author
        abstractLabel.text = "简介: " + novel.article_abstract!
        
    }
    
    
}

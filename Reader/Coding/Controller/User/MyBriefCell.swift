//
//  MyBriefCell.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class MyBriefCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupItem(_ item: ConfigItem) {
        self.iconImageView.image = UIImage(named: item.iconName)
        self.titleLabel.text = item.title
        self.detailLabel.text = item.detail
    }
}

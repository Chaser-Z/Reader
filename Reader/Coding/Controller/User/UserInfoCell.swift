//
//  UserInfoCell.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import SDWebImage

protocol UserInfoCellDelegate: class {
    func userPhotoPressed()
}

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescLabel: UILabel!
    
    var imagePath: String?
    weak var delegate: UserInfoCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userPhotoImageView.layer.cornerRadius = 28.0
        self.userPhotoImageView.clipsToBounds = true
        
        self.userPhotoImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.userPhotoImageView.layer.borderWidth = kSeparatorViewH
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewPhoto(_:)))
        self.userPhotoImageView.isUserInteractionEnabled = true
        self.userPhotoImageView.addGestureRecognizer(tapGesture)
    }

    func setupInfo(imagePath: String?, name: String, desc: String?) {
        if let path = imagePath {
            self.imagePath = imagePath
            self.userPhotoImageView.sd_setImage(with: URL(string: path))
        } else {
            self.userPhotoImageView.image = UIImage(named: "default_user")
        }
        
        self.userNameLabel.text = name
        self.userDescLabel.text = desc ?? ""
    }
    
    func viewPhoto(_ gesture: UITapGestureRecognizer) {
        if imagePath != nil {
            delegate?.userPhotoPressed()
        }
    }
    
}

//
//  BookShelfCell.swift
//  Reader
//
//  Created by 张海南 on 2017/7/17.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import SnapKit
protocol BookShelfCellDelegate: class {
    func deleteNovel(_ novel: Novel?, isDelete: Bool, index: Int)
}

class BookShelfCell: UICollectionViewCell {
    
    weak var delegate: BookShelfCellDelegate?
    let kSeparatorViewH: CGFloat = 0.5
    private var novel: Novel?
    @IBOutlet weak var novelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var remindLabel: ViewSwift!
    private var bgView: UIButton?
    
    private func setupViews() {
        novelImageView.layer.borderWidth = kSeparatorViewH
        novelImageView.layer.borderColor = UIColor.lightGray.cgColor
        novelImageView.contentMode = .scaleToFill
        
        updateImageHeight()
        
    }
    
    private func updateImageHeight() {
        if isPad() {
            heightConstraint?.constant = 186.0
        } else {
            if is4InchPhone() {
                heightConstraint?.constant = 90.0
            } else {
                heightConstraint?.constant = 115.0
            }
        }
    }
    
    func setup(novel: Novel?, isEditing: Bool = false, isPlaceholder: Bool = false, index: Int) {
        // Clean up hud
        
        remindLabel.isHidden = true
        
        deleteButton?.isHidden = true
        deleteButton?.isEnabled = false
        novelImageView.addSubview(deleteButton)
        novelImageView.isUserInteractionEnabled = true
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(novelImageView.snp.bottom).offset(-2)
            make.right.equalTo(novelImageView.snp.right).offset(-2)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        deleteButton.setImage(#imageLiteral(resourceName: "CellGreySelected"), for: .normal)
        deleteButton.setImage(#imageLiteral(resourceName: "CellBlueSelected"), for: .selected)
        deleteButton.isSelected = false
        
        if bgView == nil {
            bgView = UIButton()
        }
        bgView?.frame = self.bounds
        bgView?.backgroundColor = UIColor.clear
        bgView?.alpha = 0.3
        bgView?.tag = index
        bgView?.isSelected = false
        bgView?.addTarget(self, action: #selector(deteleButtonAction), for: .touchUpInside)
        self.contentView.addSubview(self.bgView!)
        self.contentView.bringSubview(toFront: self.bgView!)
        self.contentView.bringSubview(toFront: deleteButton)
        self.bgView?.bringSubview(toFront: self.deleteButton)
        
        novelImageView.image = nil
        
        if isPlaceholder {
            novelImageView.image = UIImage(named: "add_placeholder")
            titleLabel.text = ""
            processLabel.text = ""
            
            bgView?.isHidden = true
            
            novelImageView.backgroundColor = .clear
            novelImageView.layer.borderWidth = kSeparatorViewH
            novelImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            novelImageView.contentMode = .scaleAspectFit
            
            updateImageHeight()
        } else {
            self.setupViews()
            self.novel = novel
            bgView?.isHidden = true
            self.novelImageView.sd_setImage(with: URL(string: (novel?.image_link)!))
            self.processLabel.text = novel?.author
            self.titleLabel.text = novel?.title
            if isEditing {
                bgView?.isHidden = false
                bgView?.backgroundColor = UIColor.white
                deleteButton?.isHidden = false
                deleteButton?.isEnabled = true
            }

        }
    }
    
    @objc private func deteleButtonAction(_ btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        deleteButton.isSelected = !deleteButton.isSelected
        if btn.isSelected == false {
            //btn.addAnimation(0.3)
            btn.backgroundColor = UIColor.white
        } else {
            btn.backgroundColor = UIColor.clear
            deleteButton.addAnimation(durationTime: 0.3)
        }
        
        if let novel = self.novel {
            delegate?.deleteNovel(novel, isDelete: btn.isSelected, index: btn.tag)
        }
    }
        
}

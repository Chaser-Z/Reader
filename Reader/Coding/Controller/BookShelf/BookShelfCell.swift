//
//  BookShelfCell.swift
//  Reader
//
//  Created by 张海南 on 2017/7/17.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol BookShelfCellDelegate {
    func deleteNovel(_ novel: Novel?)
}

class BookShelfCell: UICollectionViewCell {
    
    var delegate: BookShelfCellDelegate?
    let kSeparatorViewH: CGFloat = 0.5
    private var novel: Novel?
    @IBOutlet weak var novelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
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
    
    func setup(novel: Novel?, isEditing: Bool = false, isPlaceholder: Bool = false) {
        // Clean up hud
        deleteButton?.isHidden = true
        deleteButton?.isEnabled = false
        novelImageView.image = nil
        
        if isPlaceholder {
            novelImageView.image = UIImage(named: "add_placeholder")
            titleLabel.text = ""
            processLabel.text = ""
            
            novelImageView.backgroundColor = .clear
            novelImageView.layer.borderWidth = kSeparatorViewH
            novelImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            novelImageView.contentMode = .scaleAspectFit
            
            updateImageHeight()
        } else {
            self.setupViews()
            self.novel = novel
            
            self.novelImageView.sd_setImage(with: URL(string: (novel?.image_link)!))
            self.processLabel.text = novel?.author
            self.titleLabel.text = novel?.title
            if isEditing {
                deleteButton?.isHidden = false
                deleteButton?.isEnabled = true
            }

        }
    }
    
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        if let novel = self.novel {
            delegate?.deleteNovel(novel)
        }
    }
    
}

//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import SnapKit

protocol DemoCellDelegate {
    func readButtonClick(_ index: Int)
}


class DemoCell: CCFoldCell {

    var delegate: DemoCellDelegate?
    
    @IBOutlet weak var closeNumberLabel: UILabel!
    @IBOutlet weak var openNumberLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var abstractView: CCRotatedView!
    @IBOutlet weak var abstractLabel: UILabel!
    
    var abstractH: CGFloat = 0
    
    @IBOutlet weak var readButton: UIButton!
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    func setup(_ novel: Novel, index: Int) {
        closeNumberLabel.text = novel.title
        openNumberLabel.text = novel.title
        coverImageView.sd_setImage(with: URL(string: novel.image_link))
        stateLabel.text = "状态: 连载中"
        authorLabel.text = "作者: \(novel.author)"
        abstractLabel.text = "简介: \(novel.article_abstract!)"
        readButton.tag = index
    }
  
  
    override func animationDuration(withItemIndex itemIndex: Int, animationType type: AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        abstractView.snp.makeConstraints { (make) in
//            make.height.equalTo(self.abstractH)
//        }
//        abstractLabel.snp.makeConstraints { (make) in
//            make.height.equalTo(self.abstractH)
//        }

        
        
    }
    
    @IBAction func readButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        delegate?.readButtonClick((button?.tag)!)
    }
    
    
}

// MARK: - Actions ⚡️
extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
  }
  
}

//
//  LeftTopView.swift
//  Reader
//
//  Created by 张海南 on 2017/8/1.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol LeftTopViewDelegate: class {
    func orderButtonClick(isSelected: Bool)
}


class LeftTopView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chaptersLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    weak var delegate: LeftTopViewDelegate?

    class func newInstance() -> LeftTopView? {
        let nibViews = Bundle.main.loadNibNamed("LeftTopView", owner: nil, options: nil)
        if let view = nibViews?.first as? LeftTopView {
            view.backgroundColor = UIColor.white
            return view
        }
        return nil
    }
    
    func setupUI() {
        orderButton.setImage(UIImage(named: "倒叙排序"), for: .selected)
        orderButton.setImage(UIImage(named: "顺序排列"), for: .normal)
        orderButton.isSelected = false
    }
    
    @IBAction func orderButtonAction(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if let delegate = self.delegate {
            delegate.orderButtonClick(isSelected: btn.isSelected)
        }
    }
    
}

//
//  SearchView.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func searchButtonPress()
}


class SearchView: UIView {

    var delegate: SearchViewDelegate!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    class func newInstance() -> SearchView? {
        
        let nibViews = Bundle.main.loadNibNamed("SearchView", owner: nil, options: nil)
        if let view = nibViews?.first as? SearchView {
            view.backgroundColor = UIColor.clear
            return view
        }
        return nil
    }

    private func setupView() {
        
        let searchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchImageView.image = #imageLiteral(resourceName: "search")
        searchImageView.contentMode = .center
        self.searchTextField.isUserInteractionEnabled = false
        self.searchTextField.tintColor = RGBA(98, 97, 101)
        self.searchTextField.leftView = searchImageView
        self.searchTextField.leftViewMode = .always
        
    }
    
    @IBAction func SearchButtonClick(_ sender: Any) {
        delegate.searchButtonPress()
    }
    
    
}

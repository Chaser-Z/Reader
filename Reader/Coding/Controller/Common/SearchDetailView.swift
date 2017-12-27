//
//  SearchDetailView.swift
//  Reader
//
//  Created by 张海南 on 2017/7/18.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol SearchDetailViewDelegate {
    func cancelButtonPress()
    func searchTextFieldShouldReturn(_ textField: UITextField)
    func searchEditingChanged(_ textField: UITextField)
}

class SearchDetailView: UIView {

    var delegate: SearchDetailViewDelegate!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    class func newInstance() -> SearchDetailView? {
        
        let nibViews = Bundle.main.loadNibNamed("SearchDetailView", owner: nil, options: nil)
        if let view = nibViews?.first as? SearchDetailView {
            view.backgroundColor = UIColor.clear
            view.searchTextField.becomeFirstResponder()
            return view
        }
        return nil
    }
    
    private func setupView() {
        
        let searchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchImageView.image = #imageLiteral(resourceName: "search")
        searchImageView.contentMode = .center
        self.searchTextField.tintColor = RGBA(98, 97, 101)
        self.searchTextField.leftView = searchImageView
        self.searchTextField.leftViewMode = .always
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.searchTextField.returnKeyType = .search
        self.searchTextField.clearButtonMode = .whileEditing
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.searchTextField.resignFirstResponder()
        delegate.cancelButtonPress()
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        delegate.searchEditingChanged(textField)
    }
}

extension SearchDetailView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        delegate.searchTextFieldShouldReturn(textField)
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        //NOVELLog(textField.text)
//    }
}

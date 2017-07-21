//
//  UserUpdateViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

protocol UserUpdateViewControllerDelegate: class {
    func textSaved(_ text: String?)
}


class UserUpdateViewController: UITableViewController {
    
    var myTitle: String?
    var myPlaceHolder: String?
    var currentText: String?
    var kMaxInputCount = 30

    weak var delegate: UserUpdateViewControllerDelegate?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    fileprivate var placeHolderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = myTitle
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        setupPlaceHolder()
        setupNavigationBar()
    }

    private func setupPlaceHolder() {
        textView.delegate = self
        textView.text = currentText
        
        let current = textView?.text.characters.count ?? 0
        charCountLabel?.text = "\(kMaxInputCount - current)"
        
        placeHolderLabel = UILabel()
        placeHolderLabel.text = myPlaceHolder
        placeHolderLabel.font = UIFont.systemFont(ofSize: textView.font?.pointSize ?? 14.0)
        placeHolderLabel.sizeToFit()
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.frame.origin = CGPoint(x: 6, y: (textView.font?.pointSize)! / 2)
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    private func setupNavigationBar() {
        let saveBarButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveText))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    func saveText() {
        if let delegate = self.delegate {
            delegate.textSaved(textView.text)
        }
        
        // Pop navigation controller
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension UserUpdateViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
        
        if let text = textView.text {
            let current = text.characters.count
            
            if current <= kMaxInputCount {
                charCountLabel?.text = "\(kMaxInputCount - current)"
            } else {
                let str = (text as NSString).substring(to: kMaxInputCount)
                textView.text = str
            }
        } else {
            charCountLabel?.text = "\(kMaxInputCount)"
        }
    }
    
}


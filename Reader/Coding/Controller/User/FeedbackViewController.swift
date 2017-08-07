//
//  FeedbackViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/8/3.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import MBProgressHUD

private let kMaxInputCount = 500


class FeedbackViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    fileprivate var placeHolderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "意见反馈"
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupLangs()
        setupPlaceHolder()
        setupBarButtonItems()
    }

    deinit {
        NOVELLog("deinit FeedbackViewController")
    }

    func setupLangs() {
        nameTextField.placeholder = "姓名（可选）"
        emailTextField.placeholder = "邮箱（可选）"
    }
    
    func setupPlaceHolder() {
        feedbackTextView.delegate = self
        
        charCountLabel?.text = "\(kMaxInputCount)"
        
        placeHolderLabel = UILabel()
        placeHolderLabel.text = "请填写你的问题或者建议，我们将尽快处理。"
        placeHolderLabel.font = UIFont.systemFont(ofSize: isPhone() ? 14.0 : 16.0)
        placeHolderLabel.sizeToFit()
        feedbackTextView.addSubview(placeHolderLabel)
        placeHolderLabel.frame.origin = CGPoint(x: 4, y: (feedbackTextView.font?.pointSize)! / 2)
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.isHidden = !feedbackTextView.text.isEmpty
    }
    
    func setupBarButtonItems() {
        let buttonTitle = "提交"
        let submitBarButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem = submitBarButton
    }
    
    func submit() {
        guard let content = textOfTextView(feedbackTextView) else {
            showMessage("请填写你的问题或者建议", onView: self.view)
            return
        }
        
        let userId = UserManager.currentUser()?.userId
        let email = textOfTextField(emailTextField)
        let name = textOfTextField(nameTextField)
        
        let feedback = ServerFeedback(userId: userId, email: email, name: name, content: content)
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = .indeterminate
        hud?.removeFromSuperViewOnHide = true
        hud?.labelText = "保存中..."
        
        FeedbackFacade.add(feedback) { [weak self] _ in
            DispatchQueue.main.async {
                hud?.hide(true)
                self?.showRespect()
            }
        }
    }
    
    private func showRespect() {
        if let window = UIApplication.shared.delegate?.window {
            showMessage("感谢您的反馈", onView: window)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...1:
            return isPhone() ? 44 : 50
            
        case 2:
            return isPhone() ? 150 : 200
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedbackViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !feedbackTextView.text.isEmpty
        
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


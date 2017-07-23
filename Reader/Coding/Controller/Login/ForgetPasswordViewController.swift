//
//  ForgetPasswordViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var resetTextField: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重置密码"
    }
    @IBAction func resetBtnAction(_ sender: Any) {
        
        if !isInternetReachable() {
            showMessage("没有网络", onView: self.view)
            return
        }
        
        guard let identifier = textOfTextField(resetTextField) else {
            showMessage("请输入注册邮箱", onView: self.view)
            return
        }
        
        if !validateEmail(identifier) {
            showMessage("邮箱不合法", onView: self.view)
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.removeFromSuperViewOnHide = true
        hud?.mode = .indeterminate
        self.resetTextField.resignFirstResponder()
        
        UserFacade.resetPassword(identityType: kIdentityTypeEmail, identifier: identifier) { [weak self] success, errorCode in
            DispatchQueue.main.async {
                hud?.hide(true)
                
                if success {
                    if let window = UIApplication.shared.delegate?.window {
                        showMessage("密码已重置，请检查您的邮箱", onView: window)
                    }
                    
                    _ = self?.navigationController?.popViewController(animated: true)
                } else if errorCode == ErrorCode.UserNotExist {
                    showMessage("邮箱尚未注册，请检查输入的邮箱", onView: self?.view)
                } else {
                    showMessage("重置密码失败，请联系管理员", errorCode: errorCode, onView: self?.view)
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ForgetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resetTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        //NOVELLog(textField.text)
    }
}

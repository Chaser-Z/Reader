//
//  RegisterViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    private var currentNationalityId: Int32?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"
        self.tableView.tableFooterView = UIView()
    }

    @IBAction func register() {
        
        if !isInternetReachable() {
            showMessage("无网络连接", onView: self.view)
            return
        }
        
        guard let identifier = textOfTextField(emailTextField) else {
            showMessage("请输入注册邮箱", onView: self.view)
            return
        }
        
        if !validateEmail(identifier) {
            showMessage("邮箱不合法", onView: self.view)
            return
        }
        
        guard let nickname = textOfTextField(nickNameTextField) else {
            showMessage("请输入昵称", onView: self.view)
            return
        }
        
        guard let plain = textOfTextField(passwordTextField) else {
            showMessage("请输入密码", onView: self.view)
            return
        }
        
        guard let plain2 = textOfTextField(passwordAgainTextField) else {
            showMessage("请再次输入密码", onView: self.view)
            return
        }
        
        guard plain == plain2 else {
            showMessage("两次输入的密码不一致", onView: self.view)
            return
        }
        
        guard let city = textOfTextField(cityTextField) else {
            showMessage("请输入所在城市", onView: self.view)
            return
        }

//        currentNationalityId = 10
//        guard let nationId = currentNationalityId else {
//            showMessage("请选择国籍", onView: self.view)
//            return
//        }

        let credential = md5(plain)
        
        let serverUser = ServerUser(userId: nil, identityType: kIdentityTypeEmail, identifier: identifier, credential: credential)
        serverUser.email = identifier
        serverUser.nickname = nickname
        serverUser.city = city
        //serverUser.nationalityId = nationId
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.removeFromSuperViewOnHide = true
        hud?.mode = .indeterminate
        
        UserFacade.register(serverUser: serverUser) { [weak self] (user, errorCode) in
            DispatchQueue.main.async {
                hud?.hide(true)
                
                if errorCode == ErrorCode.Success {
                    // Post login notification
                    let notification = Notification(name: kUserLoginNotificationName)
                    NotificationCenter.default.post(notification)
                    self?.dismiss(animated: true, completion: nil)
                } else if errorCode == ErrorCode.UserIdentityExisting {
                    showMessage("注册邮箱已存在", onView: self?.view)
                } else {
                    showMessage("注册失败", errorCode: errorCode, onView: self?.view)
                }
            }
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return isPhone() ? 0 : 90
            
        case 1...6:
            return isPhone() ? 44 : 50
            
        case 7:
            return isPhone() ? 90 : 100
            
        default:
            return 0
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//
//  LoginViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UITableViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var wechatImageView: UIImageView!
    @IBOutlet weak var qqImageView: UIImageView!
    @IBOutlet weak var weiboImageView: UIImageView!
    
    @IBOutlet weak var otherLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = DefaultColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        
        self.title = "登录"
        
        setupTapGesture()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        iconImageView.alpha = 0
        forgetPasswordBtn.alpha = 0
        registerBtn.alpha = 0
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        loginBtn.alpha = 0
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        emailTextField.rightX -= self.view.bounds.width
        passwordTextField.rightX -= self.view.bounds.width
        loginBtn.rightX -= self.view.bounds.width
        
        let cancelBar = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelBar

        
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            self.emailTextField.rightX += self.view.bounds.width
            self.passwordTextField.rightX += self.view.bounds.width
            self.loginBtn.rightX += self.view.bounds.width
            
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.iconImageView.alpha = 1
            self.forgetPasswordBtn.alpha = 1
            self.registerBtn.alpha = 1
            self.emailTextField.alpha = 1
            self.passwordTextField.alpha = 1
            self.loginBtn.alpha = 1
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        if !isInternetReachable() {
            showMessage("无网络连接", onView: self.view)
            return
        }
        
        guard let email = textOfTextField(emailTextField) else {
            showMessage("请输入注册邮箱", onView: self.view)
            return
        }
        
        guard let plain = textOfTextField(passwordTextField) else {
            showMessage("请输入密码", onView: self.view)
            return
        }
        
        let credential = md5(plain)
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.removeFromSuperViewOnHide = true
        hud?.mode = .indeterminate
        
        UserFacade.login(identityType: kIdentityTypeEmail, identifier: email, credential: credential) { [weak self] user, errorCode in
            DispatchQueue.main.async {
                hud?.hide(true)
                
                if errorCode == ErrorCode.Success {
                    //self?.postLoginNotification()
                    showMessage("登录成功", onView: self?.view)
                    //self?.dismiss(animated: true, completion: nil)
                } else if errorCode == ErrorCode.UserNotExist {
                    showMessage("登录失败，邮箱不存在", onView: self?.view)
                } else if errorCode == ErrorCode.UserCredentialIncorrect {
                    showMessage("登录失败，密码错误", onView: self?.view)
                } else {
                    showMessage("登录失败", onView: self?.view)
                }
            }
        }

    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        let wechatTap = UITapGestureRecognizer(target: self, action: #selector(wechatLogin))
        wechatImageView?.isUserInteractionEnabled = true
        wechatImageView?.addGestureRecognizer(wechatTap)
        
        let qqTap = UITapGestureRecognizer(target: self, action: #selector(qqLogin))
        qqImageView?.isUserInteractionEnabled = true
        qqImageView?.addGestureRecognizer(qqTap)
        
        let weiboTap = UITapGestureRecognizer(target: self, action: #selector(weiboLogin))
        weiboImageView?.isUserInteractionEnabled = true
        weiboImageView?.addGestureRecognizer(weiboTap)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    func wechatLogin(gesture: UITapGestureRecognizer) {
        LoginHelper.wechatLogin { [weak self] (success, user) in
            DispatchQueue.main.async {
                if success {
                    self?.thirdPartyLogin(user)
                } else {
                    showMessage("登录失败", onView: self?.view)
                }
            }
        }
    }
    
    func qqLogin(gesture: UITapGestureRecognizer) {
    }
    
    func weiboLogin(gesture: UITapGestureRecognizer) {
    }
    
    private func thirdPartyLogin(_ user: ServerUser?) {
        if let user = user {
            UserFacade.login(user) { [weak self] user, errorCode in
                if errorCode == ErrorCode.Success {
                    //self?.postLoginNotification()
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    showMessage("登录失败", onView: self?.view)
                }
            }
        }
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return isPhone() ? 0 : 90
            
        case 1:
            return isPhone() ? 120 : 150
            
        case 2,3:
            return isPhone() ? 44 : 50
            
        case 4:
            return isPhone() ? 90 : 100
            
        case 5:
            return 150
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

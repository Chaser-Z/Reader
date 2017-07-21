//
//  UserInfoViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import MWPhotoBrowser

class UserInfoViewController: UITableViewController {

    
    fileprivate var userHasChanged = false
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 退出登录
    private func logout() {
        let alertController = UIAlertController(title: "您要退出当前账号么", message: nil, preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "退出登录", style: .destructive) { [weak self] action in
            self?.confirmLogout()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func confirmLogout() {
        guard let user = UserManager.currentUser() else {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        // Clear the wechat, qq, weibo status
        switch user.identityType {
//        case kIdentityTypeWechat:
//            ShareSDK.cancelAuthorize(.typeWechat)
//            break
//            
//        case kIdentityTypeQQ:
//            ShareSDK.cancelAuthorize(.typeQQ)
//            break
            
        case kIdentityTypeWeibo:
            ShareSDK.cancelAuthorize(.typeSinaWeibo)
            break
            
        default:
            break
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.removeFromSuperViewOnHide = true
        hud?.mode = .indeterminate
        
        // Update user info if changed
        if userHasChanged {
            saveUserInfoToServer(showError: false)
        }
        
        UserFacade.logout(userId: user.userId, sessionId: user.sessionId!) { [weak self] (success, errorCode) in
            DispatchQueue.main.async {
                hud?.hide(true)
                
                UserManager.deleteUser()
                RecordManager.deleteAll()
                self?.postLogoutNotification()
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func postLogoutNotification() {
        let notification = Notification(name: kUserLogoutNotificationName)
        NotificationCenter.default.post(notification)
    }
    
    private func saveUserInfoToServer(showError: Bool = true) {
        if let user = UserManager.currentUser() {
            let serverUser = UserManager.serverUserFromUser(user)
            UserFacade.update(serverUser: serverUser) { [weak self] (user, errorCode) in
                DispatchQueue.main.async {
                    if errorCode != ErrorCode.Success {
                        if showError {
                            showMessage("更新用户信息失败", errorCode: errorCode, onView: self?.view)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 更改用户信息
    fileprivate func updateUserInfo() {
        self.userHasChanged = true
        self.showUserInfo()
    }
    
    private func showUserInfo() {
        if let user = UserManager.currentUser() {
            if let path = user.avatarFullPath {
                userImageView.sd_setImage(with: URL(string: path))
            } else {
                userImageView.image = UIImage(named: "default_user")
            }
            
            userImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewPhoto(_:)))
            userImageView.addGestureRecognizer(tapGesture)
            
            nickNameLabel.text = user.nickname ?? ""
            phoneLabel.text = user.desc ?? ""
            emailLabel.text = user.email ?? "未设置"
            sexLabel.text = ""
            nationLabel.text = ""
            areaLabel.text = ""
            
            userInfoLabel.text = ""
            
        }
    }

    func viewPhoto(_ gesture: UITapGestureRecognizer) {
        if let browser = MWPhotoBrowser(delegate: self) {
            browser.displayActionButton = true
            browser.displayNavArrows = false
            browser.displaySelectionButtons = false
            browser.alwaysShowControls = true
            browser.zoomPhotosToFill = true
            browser.enableGrid = false
            browser.startOnGrid = false
            browser.enableSwipeToDismiss = false
            browser.setCurrentPhotoIndex(0)
            
            navigationController?.pushViewController(browser, animated: true)
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "User", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserUpdateViewController") as! UserUpdateViewController

            if indexPath.row == 0 {
                controller.myTitle = "修改昵称"
                controller.myPlaceHolder = "修改昵称"
            } else if indexPath.row == 1 {
                controller.myTitle = "修改手机号"
                controller.myPlaceHolder = "修改手机号"
            } else if indexPath.row == 2 {
                controller.myTitle = "修改邮箱"
                controller.myPlaceHolder = "修改邮箱"
            } else if indexPath.row == 3 {
                controller.myTitle = "修改性别"
                controller.myPlaceHolder = "修改性别"
            } else if indexPath.row == 4 {
                controller.myTitle = "修改国家"
                controller.myPlaceHolder = "修改国家"
            } else if indexPath.row == 5 {
                controller.myTitle = "修改地区"
                controller.myPlaceHolder = "修改地区"
            } else if indexPath.row == 6 {
                controller.myTitle = "修改个人简介"
                controller.myPlaceHolder = "介绍介绍自己吧"
            }
            self.navigationController?.pushViewController(controller, animated: true)

        }
        
        if indexPath.section == 2 {
            //controller.delegate = self
            //controller.currentText = UserManager.currentUser()?.desc
            //self.navigationController?.pushViewController(controller, animated: true)
        }
        
        // 退出登录
        if indexPath.section == 3 {
            self.logout()
        }
        
    }
}

extension UserInfoViewController: MWPhotoBrowserDelegate {
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return 1
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index == 0 {
            if let user = UserManager.currentUser(), let fullPath = user.avatarFullPath {
                return MWPhoto(url: URL(string: fullPath))
            }
        }
        
        return nil
    }
    
}

extension UserInfoViewController: UserUpdateViewControllerDelegate {
    
    func textSaved(_ text: String?) {
        if let text = text {
            //descLabel.text = text
            
            UserManager.currentUser()?.desc = ""
            UserManager.saveCurrent()
            
            self.updateUserInfo()
            
            self.userHasChanged = true
        }
    }
    
}

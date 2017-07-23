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
import MobileCoreServices
import QBImagePickerController

class UserInfoViewController: UITableViewController {

    
    fileprivate var userHasChanged = false
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
//    @IBOutlet weak var sexLabel: UILabel!
//    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!

    
    let myTitles = ["修改昵称","修改手机号","修改邮箱","修改地区","修改个人简介"]
    let myPlaceHolders = ["填写昵称","填写手机号","填写邮箱","填写地区","填写个人简介"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        showUserInfo()
        
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
    
    func postAvatarUpdateNotification() {
        let center = NotificationCenter.default
        let notification = Notification(name: kUserAvatarUpdateNotificationName, object: nil)
        center.post(notification)
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
    
    private func updatePhoto() {
        let style: UIAlertControllerStyle = isPhone() ? .actionSheet : .alert
        let alertController = UIAlertController(title: "更新头像", message: nil, preferredStyle: style)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { [weak self] action in
            self?.takePhoto()
        }
        
        let albumAction = UIAlertAction(title: "从相册选择", style: .default) { [weak self] action in
            self?.pickAlbum()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    private func takePhoto() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if cameraAuthStatus == .denied {
            showMessage("您没有授权应用访问相机", onView: self.view)
        } else if cameraAuthStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.showPickerController(mediaType: kUTTypeImage as String)
                    } else {
                        showMessage("您没有授权应用访问相机", onView: self?.view)
                    }
                }
            }
        } else {
            self.showPickerController(mediaType: kUTTypeImage as String)
        }
    }
    
    private func pickAlbum() {
        let albumAuthStatus = PHPhotoLibrary.authorizationStatus()
        if albumAuthStatus == .denied {
            showMessage("您没有授权应用访问相册", onView: self.view)
            return
        }
        
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaType = .image
        imagePickerController.allowsMultipleSelection = false
        imagePickerController.maximumNumberOfSelection = 1
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func showPickerController(mediaType: String) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [mediaType]
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func updateAvatar(image: UIImage) {
        if let user = UserManager.currentUser() {
            let userId = user.userId
            let sessionId = user.sessionId!
            
            let data = UIImageJPEGRepresentation(image, 0.9)!
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.removeFromSuperViewOnHide = true
            hud?.mode = .annularDeterminate
            hud?.labelText = "头像上传中..."
            
            UserFacade.updateAvatar(userId: userId, sessionId: sessionId, avatar: data, progress: { percent in
                DispatchQueue.main.async {
                    hud?.progress = Float(percent)
                }
            }, completion: { [weak self] (path, errorCode) in
                DispatchQueue.main.async {
                    if let path = path {
                        // Post notification
                        self?.postAvatarUpdateNotification()
                        
                        // Update user avatar
                        UserManager.updateAvatar(path)
                        showMessage("上传成功", onView: self?.view)
                        // Update UI
                        self?.userImageView.sd_setImage(with: URL(string: "\(HOST)\(path)"))
                    }
                    
                    hud?.hide(true)
                }
            })
        }
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
            userImageView.layer.masksToBounds = true
            userImageView.layer.cornerRadius = self.userImageView.width / 2.0
            userImageView.addGestureRecognizer(tapGesture)
            
            nickNameLabel.text = user.nickname ?? ""
            phoneLabel.text = user.phone ?? ""
            emailLabel.text = user.email ?? "未设置"
            //sexLabel.text = ""
            //nationLabel.text = ""
            areaLabel.text = user.city ?? ""
            
            userInfoLabel.text = user.desc ?? "这个人很懒，什么也没写"
            
            saveUserInfoToServer()
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
    
    private func changePassword() {
        if !isInternetReachable() {
            showMessage("没有网络", onView: self.view)
            return
        }
        
        guard let user = UserManager.currentUser(), user.identityType == kIdentityTypeEmail else {
            showMessage("使用邮箱注册的用户才可以修改密码", onView: self.view)
            return
        }
        
        let alertController = UIAlertController(title: "修改账号密码", message: nil, preferredStyle: .alert)
        
        // Current password
        alertController.addTextField { textField in
            textField.placeholder = "请输入当前密码"
            textField.isSecureTextEntry = true
        }
        
        // New password
        alertController.addTextField { textField in
            textField.placeholder = "请输入新密码"
            textField.isSecureTextEntry = true
        }
        
        // New password repeat
        alertController.addTextField { textField in
            textField.placeholder = "请再次输入新密码"
            textField.isSecureTextEntry = true
        }
        
        let okAction = UIAlertAction(title: "确定", style: .default) { [weak self] action in
            if let textField1 = alertController.textFields?[0], let currentPassword = textField1.text,
                let textField2 = alertController.textFields?[1], let newPassword1 = textField2.text,
                let textField3 = alertController.textFields?[2], let newPassword2 = textField3.text {
                
                if newPassword1 != newPassword2 {
                    showMessage("两次输入的密码不一致", onView: self?.view)
                    return
                }
                
                let oldCredential = md5(currentPassword)
                let newCredential = md5(newPassword1)
                
                let hud = MBProgressHUD.showAdded(to: self?.view, animated: true)
                hud?.removeFromSuperViewOnHide = true
                hud?.mode = .indeterminate
                
                UserFacade.changePassword(userId: user.userId, sessionId: user.sessionId!, identityType: user.identityType, identifier: user.identifier, credentialOld: oldCredential, credential: newCredential) { [weak self] (success, errorCode) in
                    DispatchQueue.main.async {
                        hud?.hide(true)
                        
                        if success {
                            showMessage("修改密码成功", onView: self?.view)
                        } else if errorCode == ErrorCode.UserOldCredentialInvalid {
                            showMessage("当前密码错误", onView: self?.view)
                        } else {
                            showMessage("修改密码失败", errorCode: errorCode, onView: self?.view)
                        }
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            updatePhoto()
        }

        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "User", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserUpdateViewController") as! UserUpdateViewController
            controller.delegate = self
            controller.myTitle = myTitles[indexPath.row]
            controller.myPlaceHolder = myPlaceHolders[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        // 退出登录
        if indexPath.section == 2 {
            changePassword()
        }
        
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
    
    func textSaved(_ text: String?, type: String) {
        
        if let text = text {
            
            switch type {
            case myTitles[0]:
                nickNameLabel.text = text
                UserManager.currentUser()?.nickname = text
            case myTitles[1]:
                phoneLabel.text = text
                UserManager.currentUser()?.phone = text
            case myTitles[2]:
                emailLabel.text = text
                UserManager.currentUser()?.email = text
            case myTitles[3]:
                areaLabel.text = text
                UserManager.currentUser()?.city = text
            case myTitles[4]:
                userInfoLabel.text = text
                UserManager.currentUser()?.desc = text
            default:
                print("````")
            }
            UserManager.saveCurrent()
            self.updateUserInfo()
            let center = NotificationCenter.default
            let notification = Notification(name: kUserInfoUpdateNotificationName)
            center.post(notification)
            self.userHasChanged = true
        }
    }
    
}

// MARK: - QBImagePickerControllerDelegate
extension UserInfoViewController: QBImagePickerControllerDelegate {
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        self.dismiss(animated: true, completion: nil)
        
        if imagePickerController.mediaType == .image {
            for asset in assets as! [PHAsset] {
                let imageManager = PHImageManager()
                imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil) { [weak self] (image, info) in
                    if let image = image {
                        self?.updateAvatar(image: image)
                    }
                }
            }
        }
    }
    
}

extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == (kUTTypeImage as String) {
            var image = info[UIImagePickerControllerEditedImage] as? UIImage
            if image == nil {
                image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            if let image = image {
                self.updateAvatar(image: image)
            }
        }
    }
    
}


//
//  UserViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/23.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import Alamofire
import MWPhotoBrowser

class ConfigItem {
    var titleCn: String
    var detailCn: String
    var iconName: String
    
    init(titleCn: String, iconName: String, detailCn: String = "") {
        self.titleCn = titleCn
        self.iconName = iconName
        self.detailCn = detailCn
    }
    
    var title: String {
        return titleCn
    }
    
    var detail: String {
        return detailCn
    }
    
}

class UserViewController: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idNameLabel: UILabel!
    
    private let userInfoCellIdentifier = "UserInfoCell"
    private let myBriefCellIdentifier = "MyBriefCell"

    
    fileprivate let kSectionLogin   = 0
    fileprivate let kSectionUser    = 1
    fileprivate let kSectionSetting = 2
    
    // User related
//    private let myItems = [
//        ConfigItem(titleCn: "免责声明", iconName: "免责声明_icon"),
//        ConfigItem(titleCn: "意见反馈", iconName: "意见反馈"),
//        ConfigItem(titleCn: "当前版本", iconName: "version")
//    ]

    private let myItems = [
        ConfigItem(titleCn: "免责声明", iconName: "免责声明_icon"),
        ConfigItem(titleCn: "当前版本", iconName: "version"),
        ConfigItem(titleCn: "清理缓存", iconName: "clear_cache"),
        ConfigItem(titleCn: "意见反馈", iconName: "feedback"),
        ConfigItem(titleCn: "去评分", iconName: "rating"),
        ConfigItem(titleCn: "推荐给好友", iconName: "share-alt")
    ]
    private let commonItems = [
        ConfigItem(titleCn: "通用", iconName: "tongyong")
    ]
    
    
    private var loginObserver: NSObjectProtocol?
    private var logoutObserver: NSObjectProtocol?
    private var updateObserver: NSObjectProtocol?
    private var avatarObserver: NSObjectProtocol?

    private var user: User!

    private let loginItem = ConfigItem(titleCn: "登录", iconName: "login")

    
    var infoModels = [InfoModel]()
    var content: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"

        registerTableViewCells()
        registerNotificationObservers()
        showUser()

        //let cancelBar = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        //self.navigationItem.leftBarButtonItem = cancelBar
        
        
//        let path = "/articleInfo/getLatestArticles"
//        
//        var params = [String: AnyObject]()
//        params["article_id"] = "0_703" as AnyObject
//        params["last_update_date"] = "2017-06-19" as AnyObject
//
//        NOVELLog(params)
//        Alamofire.request("\(HOST)\(path)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
//            
//            NOVELLog("response = \(response)")
//            
//            if let json = response.result.value {
//                if json is [String: Any] {
//                    let info = json as! [String: Any]
//                    let data = info["data"] as! Array<Dictionary<String, Any>>
//                    print(data.count)
//                    for dict in data {
//                        let info = InfoModel()
//                        info.airicle_directory = dict["article_directory"] as! String
//                        info.article_directory_link = dict["article_directory_link"] as! String
//                        info.last_update_directory = dict["last_update_directory"] as! String
//                        info.title = dict["title"] as! String
//                        self.infoModels.append(info)
//                    }
//                    
//                }
//            }
//            
//        }

        
        
//        Alamofire.request("\(HOST)\(path1)", method: .post, parameters: params1, encoding: JSONEncoding.default).responseJSON { response in
//            if let json = response.result.value {
//                if json is [String: Any] {
//                    let info = json as! [String: Any]
//                    let data = info["data"] as! Dictionary<String, Any>
//                    self.content = data["content"] as! String
//                }
//            }
//        }
                
    }
    
    private func registerTableViewCells() {
        self.tableView.register(UserInfoCell.self, forCellReuseIdentifier: userInfoCellIdentifier)
        self.tableView.register(MyBriefCell.self, forCellReuseIdentifier: myBriefCellIdentifier)
        
        let bundle = Bundle.main
        self.tableView.register(UINib(nibName: "UserInfoCell", bundle: bundle), forCellReuseIdentifier: userInfoCellIdentifier)
        self.tableView.register(UINib(nibName: "MyBriefCell", bundle: bundle), forCellReuseIdentifier: myBriefCellIdentifier)
    }
    
    // 去评分
    private func goToRating() {
        let appId = "1255400240"
        let link = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        if let url = URL(string: link) {
            UIApplication.shared.openURL(url)
        }
    }

    // 分享给好友
    private func goToRecommend(_ sender: UITableViewCell) {
        let shareView = ShareView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 49 - 64))
        //shareView.setShareModel(UMENG_INVITE_SHARE_TEXT, image: UIImage(named: "share_logo")!, url: ABOUT_US_URL, title: UMENG_SHARE_TEXT)
        shareView.showInViewController(self)
    }
    
    // 获取用户信息
    private func showUser() {
        self.user = UserManager.currentUser()
        
        if self.user != nil {
            self.title = "我的"
        } else {
            self.title = "用户"
        }
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // 当前版本
    private func getVersion() -> String {
        // Current version
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if HOST.contains("192.168") {
                // TODO: Show info for local test server
                return "\(version) - \(HOST)"
            } else  {
                // Normal Server
                return version
            }
        } else {
            return ""
        }
    }
    
    // 当前缓存
    private func calculateCacheSize() -> String {
        let text = "当前缓存"
        var sizeString = "\(text) 0Mb"
        
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let sizeInMB = fileSizeAtPath(cachePath)
            sizeString = String(format: "\(text) %.2fMb", sizeInMB)
        }
        
        return sizeString
    }
    
    private func fileSizeAtPath(_ filePath: String) -> Float {
        var fileSize: Int64 = 0
        
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            let files = manager.subpaths(atPath: filePath) ?? []
            for file in files {
                let path = filePath.appendingPathComponent(path: "\(file)")
                let attribs = try? manager.attributesOfItem(atPath: path)
                let currentSize = attribs?[FileAttributeKey.size] as? Int
                fileSize += Int64(currentSize ?? 0)
            }
        }
        
        NOVELLog("file size: \(fileSize)")
        
        let sizeInMB = Float(fileSize) / 1024.0 / 1024.0
        return sizeInMB
    }
    
    // 清理缓存
    private func promptToCleanCache() {
        let alertController = UIAlertController(title: "您要清理缓存吗", message: "将删除缓存的图片和历史小说", preferredStyle: .alert)
        
        let cleanAction = UIAlertAction(title: "清理", style: .destructive) { [weak self] action in
            self?.cleanCache()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(cleanAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func cleanCache() {
        let manager = FileManager.default
        
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let files = manager.subpaths(atPath: cachePath) ?? []
            for file in files {
                let path = cachePath.appendingPathComponent(path: "\(file)")
                if manager.fileExists(atPath: path) {
                    try? manager.removeItem(atPath: path)
                }
            }
        }
        showMessage("缓存清理完毕", onView: self.view)
        self.tableView.reloadData()
    }
    
    // 注册通知
    private func registerNotificationObservers() {
        
        let center = NotificationCenter.default
        loginObserver = center.addObserver(forName: kUserLoginNotificationName, object: nil, queue: OperationQueue.main) { [weak self] notification in
            self?.user = UserManager.currentUser()
            self?.tableView.reloadData()
            NOVELLog("-------")
        }
        
        logoutObserver = center.addObserver(forName: kUserLogoutNotificationName, object: nil, queue: OperationQueue.main) { [weak self] notification in
            self?.user = nil
            self?.tableView.reloadData()
        }
        
        updateObserver = center.addObserver(forName: kUserInfoUpdateNotificationName, object: nil, queue: OperationQueue.main) { [weak self] notification in
            self?.user = UserManager.currentUser()
            self?.tableView.reloadData()
        }
        
        avatarObserver = center.addObserver(forName: kUserAvatarUpdateNotificationName, object: nil, queue: OperationQueue.main) { [weak self] notification in
            self?.user = UserManager.currentUser()
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        let center = NotificationCenter.default
        if let observer = loginObserver {
            center.removeObserver(observer)
        }
        
        if let observer = logoutObserver {
            center.removeObserver(observer)
        }
        
        if let observer = updateObserver {
            center.removeObserver(observer)
        }
        
        if let observer = avatarObserver {
            center.removeObserver(observer)
        }
    }
    
    func register() {
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        let navC = UINavigationController(rootViewController: loginVC)
        self.present(navC, animated: true, completion: nil)
    }
    
    private func showLoginController() {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        present(controller, animated: true, completion: nil)
    }
    
    private func showUserInfoController() {
        let storyboard = UIStoryboard(name: "User", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserInfoViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showUserSettingController() {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserSettingViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showDisclaimerViewController() {
        let storyboard = UIStoryboard(name: "User", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "DisclaimerViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func goToFeedbackController() {
        let storyboard = UIStoryboard(name: "User", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == kSectionLogin { // Section 0: login or user info
            return 1
        } else if section == kSectionUser {
            return myItems.count
        } else if section == kSectionSetting {
            return commonItems.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == kSectionLogin {
            if self.user != nil {
                let userInfoCell = tableView.dequeueReusableCell(withIdentifier: userInfoCellIdentifier, for: indexPath) as! UserInfoCell
                
                userInfoCell.setupInfo(imagePath: self.user.avatarFullPath, name: self.user.nickname ?? "", desc: self.user.desc)
                userInfoCell.accessoryType = .disclosureIndicator
                userInfoCell.selectionStyle = .none
                userInfoCell.delegate = self
                
                cell = userInfoCell
            } else {
                let loginCell = tableView.dequeueReusableCell(withIdentifier: myBriefCellIdentifier, for: indexPath) as! MyBriefCell
                loginCell.setupItem(loginItem)
                cell = loginCell
            }
        } else if indexPath.section == kSectionUser {
            let myBriefCell = tableView.dequeueReusableCell(withIdentifier: myBriefCellIdentifier, for: indexPath) as! MyBriefCell
            let item = myItems[indexPath.row]

            if indexPath.row == 0 {        // 免责声明
               
            } else if indexPath.row == 1 { // 版本
                item.detailCn = getVersion()
            } else if indexPath.row == 2 { // 版本
                // TODO:
                item.detailCn = calculateCacheSize()
            }
            myBriefCell.setupItem(item)
            cell = myBriefCell
        } else if indexPath.section == kSectionSetting {
            
            let myBriefCell = tableView.dequeueReusableCell(withIdentifier: myBriefCellIdentifier, for: indexPath) as! MyBriefCell
            let item = commonItems[indexPath.row]
            myBriefCell.setupItem(item)
            cell = myBriefCell
        } else {
            cell = UITableViewCell()
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if user != nil {
                return 80.0
            } else {
                return 50.0
            }
        } else if indexPath.section == 1 {
            return 50.0
        } else {
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if user != nil {
                return CGFloat.leastNormalMagnitude
            } else {
                return 24.0
            }
        } else {
            return 12.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if UserManager.hasUser() {
                showUserInfoController()
            } else {
                showLoginController()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 { // 免责声明
                showDisclaimerViewController()
            } else if indexPath.row == 1 { // 当前版本
                
            } else if indexPath.row == 2 { // 清理缓存
                promptToCleanCache()
            } else if indexPath.row == 3 { // 意见反馈
                goToFeedbackController()
            } else if indexPath.row == 4 { // 去评分
                goToRating()
            } else if indexPath.row == 5 { // 分享
                if let cell = tableView.cellForRow(at: indexPath) {
                    goToRecommend(cell)
                }
            }
        } else if indexPath.section == 2 { 
            switch indexPath.row {
            case 0:
                print("0")
            case 1:
                print("1")
            case 2:
                print("2")
            case 3:
                print("3")
            default:
                print("111111")
            }
            
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension UserViewController: UserInfoCellDelegate, MWPhotoBrowserDelegate {
    
    func userPhotoPressed() {
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

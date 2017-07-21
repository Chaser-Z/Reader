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
    private let myItems = [
        ConfigItem(titleCn: "免责声明", iconName: "免责声明_icon"),
        ConfigItem(titleCn: "反馈意见", iconName: "意见反馈"),
        ConfigItem(titleCn: "当前版本", iconName: "version")
    ]
    
    private let commonItems = [
        ConfigItem(titleCn: "通用", iconName: "tongyong")
    ]
    
    
    private var loginObserver: NSObjectProtocol?
    private var logoutObserver: NSObjectProtocol?

    private var user: User!

    private let loginItem = ConfigItem(titleCn: "登录", iconName: "login")

    
    var infoModels = [InfoModel]()
    var content: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"

        registerTableViewCells()
        registerNotificationObservers()
        
        let cancelBar = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        self.navigationItem.leftBarButtonItem = cancelBar
        
        
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
    
    // 当前版本
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
    }
    
    deinit {
        let center = NotificationCenter.default
        if let observer = loginObserver {
            center.removeObserver(observer)
        }
        
        if let observer = logoutObserver {
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

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
               
            } else if indexPath.row == 1 { // 意见反馈
                
            } else if indexPath.row == 2 { // 版本
                // TODO:
                item.detailCn = getVersion()
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
            let sender = tableView.cellForRow(at: indexPath)
            if indexPath.row == 0 { // My Bookmarks
                
            } else if indexPath.row == 1 { // My Favorites
                
            } else if indexPath.row == 2 { // My Messages
            }
        } else if indexPath.section == 2 { // Change Default Language
            
            let sender = tableView.cellForRow(at: indexPath)
            
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

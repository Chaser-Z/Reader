//
//  ZHNLeftView.swift
//  Reader
//
//  Created by 张海南 on 2017/6/26.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNLeftView: ZHNBaseView ,DZMSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource{

    /// topView
    //private(set) var topView:DZMSegmentedControl!
    private(set) var topView: LeftTopView! = LeftTopView.newInstance()
    /// UITableView
    fileprivate(set) var tableView:UITableView!
    
    fileprivate(set) var chapters = [Chapter]()
    /// 是否倒顺
    fileprivate var isOrder = false
    
    /// contentView
    private(set) var contentView:UIView!
    
    /// 类型 0: 章节 1: 书签
    private var type:NSInteger = 0

    override func addSubviews() {
        
        super.addSubviews()
        
        // contentView
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = GetReadTableViewFrame()
        contentView.addSubview(tableView)
        
        // topView
        topView.setupUI()
        topView.delegate = self
        contentView.addSubview(topView)
        
//        topView = DZMSegmentedControl()
//        topView.delegate = self
//        topView.normalTitles = ["章节","逆序"]
//        topView.selectTitles = ["章节", "正序"]
//        topView.horizontalShowTB = false
//        topView.backgroundColor = UIColor.clear
//        topView.normalTitleColor = Color_6
//        topView.selectTitleColor = Color_2
//        topView.setup()
//        //contentView.addSubview(topView)
    }
    
    func reloadData(_ title: String, chapterCount: Int) {
        topView.titleLabel.text = title
        topView.chaptersLabel.text = "共\(chapterCount)章"
        chapters = ZHNReadParser.shared.chapters
        tableView.reloadData()
    }
    
    // MARK: -- DZMSegmentedControlDelegate
    func segmentedControl(segmentedControl: DZMSegmentedControl, clickButton button: UIButton, index: NSInteger) {
        print(index)
        //type = index
        
        //tableView.reloadData()
    }
    
    /// 布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // contentView
        let contentViewW:CGFloat = width * 0.8
        contentView.frame = CGRect(x: -contentViewW, y: 0, width: contentViewW, height: height)
        
        // topView
        let topViewH:CGFloat = 55
        topView.frame = CGRect(x: 0, y: 0, width: contentViewW, height: topViewH)
        
        // tableView
        tableView.frame = CGRect(x: 0, y: topViewH, width: contentView.width, height: height - topViewH)
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 { // 章节
            
           return chapters.count
            
        }else{ // 书签
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNLeftViewCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ZHNLeftViewCell")
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor.clear
        }
        
        if type == 0 { // 章节
            cell?.textLabel?.text = chapters[indexPath.row].article_directory
            cell?.textLabel?.numberOfLines = 1
            cell?.textLabel?.font = Font_14
        }else{ // 书签
            
            //cell?.textLabel?.text = "\n\(readMarkModel.name!)\n\(GetTimerString(dateFormat: "YYYY-MM-dd HH:mm:ss", date: readMarkModel.time!))\n\(readMarkModel.content!))"
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = Font_12
        }
        
        cell?.textLabel?.textColor = Color_6
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == 0 { // 章节
            return 44
        }else{ // 书签
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == 0 { // 章节
            // 倒叙
            if isOrder {
                readMenu.delegate?.readMenuClickChapterList?(readMenu: readMenu, index: ZHNReadParser.shared.chapters.count - 1 - indexPath.row)
            } else {
                readMenu.delegate?.readMenuClickChapterList?(readMenu: readMenu, index: indexPath.row)
            }
        }else{ // 书签
            //readMenu.delegate?.readMenuClickMarkList?(readMenu: readMenu, readMarkModel: readMenu.vc.readModel.readMarkModels[indexPath.row])
        }
        // 隐藏
        readMenu.leftView(isShow: false, complete: nil)
    }
    
    // MARK: -- 删除操作
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if type == 0 { // 章节
            return false
        }else{ // 书签
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //let _ = readMenu.vc.readModel.removeMark(readMarkModel: nil, index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    
}

extension ZHNLeftView: LeftTopViewDelegate {
    
    func orderButtonClick(isSelected: Bool) {
        isOrder = isSelected
        // 倒顺
        if isSelected {
            chapters.sort{$0.id > $1.id}
        } else {
            chapters.sort{$0.id < $1.id}
        }
        tableView.reloadData()
    }
}

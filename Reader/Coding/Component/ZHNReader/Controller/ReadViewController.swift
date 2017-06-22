//
//  ReadViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    /// 临时阅读记录
    var readRecordModel:ReadRecordModel!
    
    /// 阅读控制器
    weak var readController:ReadController!
    
    /// 顶部状态栏
    private(set) var topStatusView:UILabel!
    
    /// 底部状态栏
    private(set) var bottomStatusView:RMStatusView!
    
    /// TableView
    private(set) var tableView:UITableView!
    
    /// 往上滚(true)还是往下滚(false)
    private var isScrollTop:Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 添加子控件
        addSubviews()
        
        // 配置背景颜色
        configureBGColor()
        
        // 配置阅读模式
        configureReadEffect()
        
        // 配置阅读记录
        configureReadRecordModel()
    }
    
    /// 创建UI
    func addSubviews() {
        
        // TopStatusView
        topStatusView = UILabel()
        topStatusView.text = readRecordModel.readChapterModel?.name
        topStatusView.lineBreakMode = .byTruncatingMiddle
        topStatusView.textColor = Color_4
        topStatusView.font = Font_12
        topStatusView.frame = CGRect(x: Space_1, y: 0, width: view.width - 2 * Space_1, height: Space_2)
        view.addSubview(topStatusView)
        
        // BottomStatusView
        bottomStatusView = RMStatusView(frame:CGRect(x: Space_1, y: view.frame.height - Space_2, width: view.width - 2 * Space_1, height: Space_2))
        bottomStatusView.backgroundColor = UIColor.clear
        bottomStatusView.titleLabel.text = "\(readRecordModel.page.intValue + 1)/\(readRecordModel.readChapterModel!.pageCount.intValue)"
        view.addSubview(bottomStatusView)
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = GetReadTableViewFrame()
        view.addSubview(tableView)
        
        // 清理
        for readChapterListModel in readController.readModel.readChapterListModels {
            
            readChapterListModel.clearPageCount(readRecordModel: readRecordModel)
        }
    }
    
    // MARK: -- 配置背景颜色
    
    /// 配置背景颜色
    func configureBGColor() {
        
        view.backgroundColor = ReadConfigure.shared().readColor()
    }
    
    // MARK: -- 阅读模式
    
    /// 配置阅读效果
    func configureReadEffect() {
        
        if ReadConfigure.shared().effectType != RMEffectType.upAndDown.rawValue { // 非上下滚动
            
            tableView.isScrollEnabled = false
            
        }else{ // 上下滚动
            
            tableView.isScrollEnabled = true
        }
    }
    
    // MARK: -- 滚动到阅读记录
    
    /// 配置阅读记录
    func configureReadRecordModel() {
        
        if ReadConfigure.shared().effectType == RMEffectType.upAndDown.rawValue { // 上下滚动
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: CGFloat(readRecordModel.readChapterModel!.priority.intValue + readRecordModel.page.intValue) * GetReadTableViewFrame().height)
        }
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ReadConfigure.shared().effectType != RMEffectType.upAndDown.rawValue { // 非上下滚动
            
            return 1
            
        }else{ // 上下滚动
            
            return readController.readModel.readChapterListModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ReadConfigure.shared().effectType != RMEffectType.upAndDown.rawValue { // 非上下滚动
            
            let cell = ReadViewCell.cellWithTableView(tableView)
            
            cell.content = readRecordModel.readChapterModel!.string(page: readRecordModel.page.intValue)
            
            return cell
            
        }else{ // 上下滚动
            
            let cell = ReadViewUDCell.cellWithTableView(tableView)
            
            // 章节列表模型
            let readChapterListModel = readController.readModel.readChapterListModels[indexPath.row]
            
            // 章节内容模型
            if ReadChapterModel.IsExistReadChapterModel(bookID: readChapterListModel.bookID, chapterID: readChapterListModel.id) { // 存在
                
                cell.readChapterModel = readChapterListModel.readChapterModel(readRecordModel: readRecordModel)
                
            }else{ // 不存在(一般是网络小说才会不存在)
                
                // 停止滚动
                tableView.stopScroll()
                
                // 添加阻挡获取网络小说数据 请求成功之后进行刷新当前Cell
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ReadConfigure.shared().effectType != RMEffectType.upAndDown.rawValue { // 非上下滚动
            
            return GetReadTableViewFrame().height
            
        }else{ // 上下滚动
            
            let readChapterListModel = readController.readModel.readChapterListModels[indexPath.row]
            
            let height = CGFloat(readChapterListModel.pageCount.intValue) * GetReadTableViewFrame().height
            
            if isScrollTop && readChapterListModel.changePageCount.intValue != 0 {
                
                tableView.contentOffset = CGPoint(x:tableView.contentOffset.x, y:tableView.contentOffset.y + CGFloat(readChapterListModel.changePageCount.intValue) * GetReadTableViewFrame().height)
                
                readChapterListModel.changePageCount = NSNumber(value: 0)
            }
            
            return height
        }
    }
    
    /// Cell消失则清空数据
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if ReadConfigure.shared().effectType == RMEffectType.upAndDown.rawValue { // 上下滚动
            
            let cell = tableView.cellForRow(at: indexPath) as? ReadViewUDCell
            
            cell?.readChapterModel = nil
        }
    }
    
    // MARK: -- 更新阅读记录
    
    /// 正在拖动
    private var isDragging:Bool = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {isDragging = true}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {isDragging = false}
    
    /// 滚动中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 判断是滚上还是滚下
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        
        if translation.y > 0 {
            
            isScrollTop = true
            
        }else if translation.y < 0 {
            
            isScrollTop = false
        }
        
        // 刷新记录
        if isDragging {updateReadRecordModel()}
    }
    
    /// 刷新阅读记录
    func updateReadRecordModel() {
        
        if (ReadConfigure.shared().effectType == RMEffectType.upAndDown.rawValue) { // 上下滚动
            
            if tableView.indexPathsForVisibleRows != nil && !tableView.indexPathsForVisibleRows!.isEmpty { // 有Cell
                
                // 章节ID
                var chapterID:String!
                
                // 页码
                var toPage:NSInteger!
                
                // 范围
                var rect = GetReadTableViewFrame()
                
                // 显示章节Cell IndexPath
                var indexPath = tableView.indexPathsForRows(in: CGRect(x: 0, y: tableView.contentOffset.y, width: rect.width, height: rect.height))!.first!
                
                // 记录
                chapterID = "\(indexPath.row + 1)"
                
                // 显示章节Cell Frame
                rect = tableView.rectForRow(at: indexPath)
                
                // 显示章节Cell
                let cell = tableView.cellForRow(at: indexPath) as! ReadViewUDCell
                
                DispatchQueue.global().async { [weak self] ()->Void in
                    
                    // 显示章节内容 Frame
                    rect = CGRect(x: self!.tableView.contentOffset.x, y: self!.tableView.contentOffset.y - rect.origin.y, width: rect.width, height: rect.height)
                    
                    // 显示章节内容 IndexPath
                    indexPath =  cell.tableView.indexPathsForRows(in: rect)!.first!
                    
                    // 记录
                    toPage = indexPath.row
                    
                    if self!.readRecordModel.readChapterModel!.id == chapterID {
                        
                        // 修改页码
                        self!.readRecordModel.page = NSNumber(value: toPage)
                        
                    }else{
                        
                        // 修改章节
                        self!.readRecordModel.modify(chapterID: chapterID, toPage: toPage)
                    }
                    
                    // 保存
                    self!.readController.readOperation.readRecordUpdate(readRecordModel: self!.readRecordModel)
                    
                    // 更新UI
                    DispatchQueue.main.async { [weak self] ()->Void in
                        
                        // 修改顶部显示
                        self!.topStatusView.text = self!.readRecordModel.readChapterModel!.name
                        
                        // 修改底部显示
                        self!.bottomStatusView.titleLabel.text = "\(self!.readRecordModel.page.intValue + 1)/\(self!.readRecordModel.readChapterModel!.pageCount.intValue)"
                    }
                }
            }
            
            /// 主线程更新 滚动会有点卡顿
            //            if tableView.indexPathsForVisibleRows != nil && !tableView.indexPathsForVisibleRows!.isEmpty { // 有Cell
            //
            //                // 章节ID
            //                var chapterID:String!
            //
            //                // 页码
            //                var toPage:NSInteger!
            //
            //                // 范围
            //                var rect = GetReadTableViewFrame()
            //
            //                // 显示章节Cell IndexPath
            //                var indexPath = tableView.indexPathsForRows(in: CGRect(x: tableView.contentOffset.x, y: tableView.contentOffset.y, width: rect.width, height: rect.height))!.first!
            //
            //                // 记录
            //                chapterID = "\(indexPath.row + 1)"
            //
            //                // 显示章节Cell Frame
            //                rect = tableView.rectForRow(at: indexPath)
            //
            //                // 显示章节Cell
            //                let cell = tableView.cellForRow(at: indexPath) as! ReadViewUDCell
            //
            //                // 显示章节内容 Frame
            //                rect = CGRect(x: tableView.contentOffset.x, y: tableView.contentOffset.y - rect.origin.y, width: rect.width, height: rect.height)
            //
            //                // 显示章节内容 IndexPath
            //                indexPath =  cell.tableView.indexPathsForRows(in: rect)!.first!
            //
            //                // 记录
            //                toPage = indexPath.row
            //
            //                if readRecordModel.readChapterModel!.id == chapterID {
            //
            //                    // 修改页码
            //                    readRecordModel.page = NSNumber(value: toPage)
            //
            //                }else{
            //
            //                    // 修改章节
            //                    readRecordModel.modify(chapterID: chapterID, toPage: toPage)
            //                }
            //
            //                // 修改顶部显示
            //                topStatusView.text = readRecordModel.readChapterModel!.name
            //
            //                // 修改底部显示
            //                bottomStatusView.titleLabel.text = "\(readRecordModel.page.intValue + 1)/\(readRecordModel.readChapterModel!.pageCount.intValue)"
            //                
            //                // 保存
            //                readController.readOperation.readRecordUpdate(readRecordModel: readRecordModel)
            //            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        // 释放该临时模型
        readRecordModel = nil
        
        // 移除定时器
        bottomStatusView?.removeTimer()
    }
}

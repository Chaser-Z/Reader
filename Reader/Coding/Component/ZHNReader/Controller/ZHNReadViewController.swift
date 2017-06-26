//
//  ZHNReadViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNReadViewController: UIViewController {

    var content: String!
    
    /// 阅读控制器
    weak var readController: ZHNReadController!
    
    /// TableView
    private(set) var tableView:UITableView!
    
    
    /// 往上滚(true)还是往下滚(false)
    fileprivate var isScrollTop:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ZHNReadParser.shared.content = readController.content?.content
        // 添加子控件
        addSubviews()
        
        // 配置背景颜色
        configureBGColor()
        
        // 配置阅读模式
        configureReadEffect()

    }

    private func addSubviews() {
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = GetReadTableViewFrame()
        view.addSubview(tableView)

        
    }
    
    // MARK: - 配置背景颜色
    /// 配置背景颜色
    func configureBGColor() {
        
        view.backgroundColor = ZHNReadConfigure.shared().readColor()
    }

    // MARK: - 阅读模式
    /// 配置阅读效果
    func configureReadEffect() {
        
        if ZHNReadConfigure.shared().effectType != ZHNEffectType.upAndDown.rawValue { // 非上下滚动
            
            tableView.isScrollEnabled = false
            
        }else{ // 上下滚动
            
            tableView.isScrollEnabled = true
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ZHNReadViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ZHNReadConfigure.shared().effectType != ZHNEffectType.upAndDown.rawValue { // 非上下滚动
            
            return 1
            
        }else{ // 上下滚动
            
            return readController.chapters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ZHNReadConfigure.shared().effectType != ZHNEffectType.upAndDown.rawValue { // 非上下滚动
            
            let cell = ZHNReadViewCell.cellWithTableView(tableView)
            NOVELLog(ZHNReadParser.shared.pageCount)
            NOVELLog(readController.currentPage)
            cell.content = ZHNReadParser.shared.string(page: readController.currentPage)
            
            return cell
            
        }else{ // 上下滚动
            
            let cell = ZHNReadViewUDCell.cellWithTableView(tableView)
            
            // 章节列表模型
//            let readChapterListModel = readController.readModel.readChapterListModels[indexPath.row]
//            
//            // 章节内容模型
//            if DZMReadChapterModel.IsExistReadChapterModel(bookID: readChapterListModel.bookID, chapterID: readChapterListModel.id) { // 存在
//                
//                cell.readChapterModel = readChapterListModel.readChapterModel(readRecordModel: readRecordModel)
            
//            }else{ // 不存在(一般是网络小说才会不存在)
//                
//                // 停止滚动
//                tableView.stopScroll()
//                
//                // 添加阻挡获取网络小说数据 请求成功之后进行刷新当前Cell
//            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ZHNReadConfigure.shared().effectType != ZHNEffectType.upAndDown.rawValue { // 非上下滚动
            
            return GetReadTableViewFrame().height
            
        }else{ // 上下滚动
            
//            let readChapterListModel = readController.readModel.readChapterListModels[indexPath.row]
//            
//            let height = CGFloat(readChapterListModel.pageCount.intValue) * GetReadTableViewFrame().height
//            
//            if isScrollTop && readChapterListModel.changePageCount.intValue != 0 {
//                
//                tableView.contentOffset = CGPoint(x:tableView.contentOffset.x, y:tableView.contentOffset.y + CGFloat(readChapterListModel.changePageCount.intValue) * GetReadTableViewFrame().height)
//                
//                readChapterListModel.changePageCount = NSNumber(value: 0)
            //}
            
            return 10
        }
    }
    
    /// Cell消失则清空数据
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if ZHNReadConfigure.shared().effectType == ZHNEffectType.upAndDown.rawValue { // 上下滚动
            
            let cell = tableView.cellForRow(at: indexPath) as? ZHNReadViewUDCell
            
            cell?.readChapterModel = nil
        }
    }

}

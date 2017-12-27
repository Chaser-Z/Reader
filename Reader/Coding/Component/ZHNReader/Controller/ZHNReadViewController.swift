//
//  ZHNReadViewController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol ZHNReadViewControllerDelegate: class {
    func emptyDataSetDidButton()
}


class ZHNReadViewController: UIViewController {
    
    weak var delegate: ZHNReadViewControllerDelegate?
    
    /// 阅读控制器
    weak var readController: ZHNReadController!
    
    var currentPage: Int = ZHNReadParser.shared.currentPage
    var currentChapter: Int = ZHNReadParser.shared.currentChapter
    
    /// TableView
    private(set) var tableView:UITableView!
    
    /// 顶部状态栏 - 文章章节标题
    private(set) var topStatusView:UILabel!
    
    /// 底部状态栏
    private(set) var bottomStatusView: ZHNStatusView!

    /// 当前阅读View(上下滚动不能使用)
    fileprivate weak var readView: ZHNReadView?
    
    /// 往上滚(true)还是往下滚(false)
    fileprivate var isScrollTop:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加子控件
        addSubviews()
                
        // 配置背景颜色
        configureBGColor()
        
        // 配置阅读模式
        configureReadEffect()
        
        // 配置上下滚动阅读记录
        configureReadRecordModel()


    }
    
    
    /// 创建UI
    private func addSubviews() {
        // TopStatusView
        topStatusView = UILabel()
        topStatusView.text = ZHNReadParser.shared.chapters[ZHNReadParser.shared.currentChapter].article_directory
        topStatusView.lineBreakMode = .byTruncatingMiddle
        topStatusView.textColor = Color_4
        topStatusView.font = Font_12
        topStatusView.frame = CGRect(x: Space_1, y: (isX ? TopLiuHeight : 0), width: view.width - 2 * Space_1, height: Space_2)
        view.addSubview(topStatusView)
        
        // BottomStatusView
        bottomStatusView = ZHNStatusView(frame:CGRect(x: Space_1, y: view.frame.height - Space_2, width: view.width - 2 * Space_1, height: Space_2))
        bottomStatusView.backgroundColor = UIColor.clear
        bottomStatusView.titleLabel.text = "\(ZHNReadParser.shared.currentPage + 1)/\(ZHNReadParser.shared.pageCount)"
        view.addSubview(bottomStatusView)

        
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.bounces = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
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
    private func configureReadEffect() {
        
        if ZHNReadConfigure.shared().effectType != ZHNEffectType.upAndDown.rawValue { // 非上下滚动
            
            tableView.isScrollEnabled = false
            tableView.clipsToBounds = false

        }else{ // 上下滚动
            tableView.isScrollEnabled = true
            tableView.clipsToBounds = true
        }
    }

    // MARK: - 滚动到阅读记录
    private func configureReadRecordModel() {
        // 上下滚动
        if ZHNReadConfigure.shared().effectType == ZHNEffectType.upAndDown.rawValue {
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: CGFloat(ZHNReadParser.shared.chapters.count + ZHNReadParser.shared.currentPage) * GetReadTableViewFrame().height)
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
            
            if ZHNReadParser.shared.content == "" {
                NOVELLog("内容是空的")
                return 0
            }
            return 1
            
        }else{ // 上下滚动
            
            return ZHNReadParser.shared.chapters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ZHNReadConfigure.shared().effectType != ZHNEffectType.upAndDown.rawValue { // 非上下滚动
            
            let cell = ZHNReadViewCell.cellWithTableView(tableView)
            NOVELLog(ZHNReadParser.shared.pageCount)
            NOVELLog(ZHNReadParser.shared.currentPage)
            cell.content = ZHNReadParser.shared.string(page: ZHNReadParser.shared.currentPage)
            readView = cell.readView
            readView?.openLongMenu = readController.openLongMenu
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
    
    // MARK: 光标拖拽手势
    
    /// 触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .begin)
    }
    
    /// 触摸移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .changed)
    }
    
    /// 触摸结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .end)
    }
    
    /// 触摸取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .end)
    }
    
    /// 解析触摸事件
    private func drag(touches: Set<UITouch>, status: ZHNPanStatus) {
        
        if readView?.isOpenDrag ?? false {
            
            let point = ((touches as NSSet).anyObject() as? UITouch)?.location(in: view)
            
            if point != nil {
                
                readView?.drag(status: status, point: view.convert(point!, to: readView), windowPoint: point!)
            }
        }
    }
    

}

extension ZHNReadViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "网络不给力，请点击下面按钮重试哦~"
        return StringUtil.attributeStringFromString(
            string: text,
            alignment: .center,
            color: .darkGray,
            lineSpacing: 5.0,
            fontSize: 16.0
        )
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        return UIImage(named: "点击重试")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if let delegate = self.delegate {
            delegate.emptyDataSetDidButton()
        }
    }
    
    func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        self.tableView.contentOffset = .zero
    }
    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "not_net")
//    }
    
}


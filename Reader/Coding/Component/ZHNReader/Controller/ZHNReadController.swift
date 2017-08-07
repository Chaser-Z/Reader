//
//  ZHNReadController.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit
import MBProgressHUD
class ZHNReadController: ZHNBaseViewController {
    
    /// 指示bug
    /*
     调用 func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {  方法会偶尔调用viewControllerBefore 这个方法
     isType 会提示有无bug，如果有就处理一下，否则小说加载顺序不对。
     目前还没有更好的解决办法 -----   待修复
     */
    fileprivate var isType = 0
    fileprivate var isPreType = 0
    /// 翻页成功或者失败
    fileprivate var turnPage = true
    /// 是否存在更新
    var isUpdate = false
    /// 现在内容
    fileprivate var currentContent: Content?
    /// 文章记录
    var novelRecord: ServerRecord? = ServerRecord()
    /// 阅读菜单UI
    private(set) var readMenu: ZHNReadMenu!
    /// 左边还是右边
    fileprivate var currentLeft: Bool = false
    /// 是否创建了页面
    private var isCreatePage = false
    // 用于区分正反面的值(固定)
    fileprivate var TempNumber:NSInteger = 1
    /// 章节
    var chapters = [Chapter]()
    /// 是否跳章节
    fileprivate var isJumpChapter: Bool = false
    /// 当前已经缓存的章节数组
    var loadContents = [Content]()
    /// 小说模型
    var novel: Novel?
    /// 小说id
    var novelID: String!
    /// 翻页控制器 (仿真)
    private(set) var pageViewController: UIPageViewController?
    /// 翻页控制器 (无效果,覆盖,上下)
    private(set) var coverController:DZMCoverController?
    /// 当前显示的阅读View控制器
    fileprivate(set) var currentReadViewController:ZHNReadViewController?
    var readVC = ZHNReadViewController()
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        // 设置白色状态栏
        isStatusBarLightContent = true
        // 加载提醒视图
        self.showHUD()
        // 初始化阅读UI控制对象
        readMenu = ZHNReadMenu.readMenu(vc: self, delegate: self)
        readVC.readController = self
        readVC.delegate = self
        // 获取阅读记录
        let record = RecordManager.getRecord(novelID)
        if record.count > 0 {
            ZHNReadParser.shared.currentPage = Int(record[0].currentPage)
            ZHNReadParser.shared.currentChapter = Int(record[0].currentChapterIndex)
        } else {
            ZHNReadParser.shared.currentChapter = 0
            ZHNReadParser.shared.currentPage = 0
        }

        // 获取已经缓存的内容
        loadContents = ContentManager.getAll(novelID)
        // 加载小说章节
        loadNovelChaptersData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - 加载小说章节
    fileprivate func loadNovelChaptersData() {
        var params = [String: AnyObject]()
        params["article_id"] = novelID as AnyObject
        let chapterList = ChapterManager.getAll(novelID)
        
        if chapterList.count > 0 {
            chapters = chapterList
            // 无更新情况
            if isUpdate == false {
                ZHNReadParser.shared.chapters = chapters
                readMenu.leftView.reloadData((novel?.title)!, chapterCount: chapters.count)
                // 加载内容
                loadContentData()
            } else { // 有更新
                let record = RecordManager.getRecord(novelID)
                params["last_update_date"] = record[0].last_update_date as AnyObject
               ChapterFacade.getUpdated(params: params, completion: { (chapters) in
                for chapter in chapters {
                    self.chapters.append(chapter)
                }
                ZHNReadParser.shared.chapters = self.chapters
                self.readMenu.leftView.reloadData((self.novel?.title)!, chapterCount: self.chapters.count)
                // 加载内容
                self.loadContentData()
               })
            }
        } else {
            ChapterFacade.getChapterList(params: params, completion: { (chapters) in
                self.chapters = chapters
                ZHNReadParser.shared.chapters = chapters
                self.readMenu.leftView.reloadData((self.novel?.title)!, chapterCount: self.chapters.count)
                for chapter in chapters {
                    NOVELLog(chapter.article_directory)
                }
                // 加载内容
                self.loadContentData()
            })
        }
    }
    
    // MARK: - 加载小说内容
    fileprivate func loadContentData() {
        
        if isCreatePage == false || isJumpChapter == true {
            for i in (ZHNReadParser.shared.currentChapter - 1)...(ZHNReadParser.shared.currentChapter + 1) {
                if i < 0 || i >= chapters.count {
                    continue
                }
                
                // 是否有缓存
                let getContent = ContentManager.getContent(chapters[i].id, article_id: novelID)
                // 有缓存
                if getContent != nil {
                    if self.isCreatePage == false {
                        self.isCreatePage = true
                    }
                    if i == ZHNReadParser.shared.currentChapter - 1 {
                        continue
                    } else if i == ZHNReadParser.shared.currentChapter {
                        guard let currentContent = getContent?.content else {
                            return
                        }
                        ZHNReadParser.shared.content = currentContent
                        self.currentContent = getContent
                        let vc = ZHNReadViewController()
                        vc.currentPage = ZHNReadParser.shared.currentPage
                        vc.readController = self
                        self.readVC.delegate = self
                        self.readVC = vc
                        self.creatPageController(self.readVC)
                        if i == chapters.count - 1 {
                            self.hud?.hide(true)
                        }
                        // 添加缓存
                        self.saveNovel()
                        continue
                    } else {
                        self.hud?.hide(true)
                        self.isJumpChapter = false
                        continue
                    }
                }
                
                NOVELLog("下面有未加载的内容")
                NOVELLog("第\(i+1)个")
                var params = [String: AnyObject]()
                params["id"] = chapters[i].id as AnyObject
                
                ContentFacade.getContent(params: params) { (content) in
                    if self.isCreatePage == false {
                        self.isCreatePage = true
                    }
                    if i == ZHNReadParser.shared.currentChapter - 1 {
                    } else if i == ZHNReadParser.shared.currentChapter {
                        guard let currentContent = content?.content else {
                            return
                        }
                        ZHNReadParser.shared.content = currentContent
                        self.currentContent = content
                        let vc = ZHNReadViewController()
                        vc.currentPage = ZHNReadParser.shared.currentPage
                        vc.readController = self
                        self.readVC = vc
                        self.readVC.delegate = self
                        self.creatPageController(self.readVC)
                        if i == self.chapters.count - 1 {
                            self.hud?.hide(true)
                        }
                        // 添加缓存
                        self.saveNovel()
                    } else {
                        self.hud?.hide(true)
                        self.isJumpChapter = false
                    }
                }
            }

        } else {
            // 左边章节
            if currentLeft {
                self.currentContent = ContentManager.getContent(chapters[Int((self.novelRecord?.currentChapterIndex)!) - 1].id, article_id: novelID)
                if self.currentContent == nil {
                    ZHNReadParser.shared.content = ""
                    NOVELLog("控制")
                    return
                }
                ZHNReadParser.shared.content = self.currentContent?.content

                if ZHNReadParser.shared.currentChapter - 1 >= 0  {
                    // 是否有缓存
                    let getContent = ContentManager.getContent(chapters[ZHNReadParser.shared.currentChapter - 1].id, article_id: novelID)
                    // 有缓存
                    if getContent != nil {
                        self.hud?.hide(true)
                        NOVELLog("有缓存")
                    } else { // 无缓存
                        var params = [String: AnyObject]()
                        params["id"] = chapters[ZHNReadParser.shared.currentChapter - 1].id as AnyObject
                        ContentFacade.getContent(params: params) { (content) in
                            NOVELLog("没有缓存，下载完毕\(ZHNReadParser.shared.currentChapter - 1)章")
                            self.hud?.hide(true)
                        }
                    }
                } else {
                    self.hud?.hide(true)
                }
            } else { // 右边章节
                self.currentContent = ContentManager.getContent(chapters[Int((self.novelRecord?.currentChapterIndex)!) + 1].id, article_id: novelID)
                if self.currentContent == nil {
                    ZHNReadParser.shared.content = ""
                    NOVELLog("控制")
                    return
                }
                
                ZHNReadParser.shared.content = self.currentContent?.content
                if ZHNReadParser.shared.currentChapter + 1 < ZHNReadParser.shared.chapters.count {
                    // 是否有缓存
                    let getContent = ContentManager.getContent(chapters[ZHNReadParser.shared.currentChapter + 1].id, article_id: novelID)
                    // 有缓存
                    if getContent != nil {
                        self.hud?.hide(true)
                        NOVELLog("有缓存")
                    } else { // 无缓存
                        var params = [String: AnyObject]()
                        params["id"] = chapters[ZHNReadParser.shared.currentChapter + 1].id as AnyObject
                        ContentFacade.getContent(params: params) { (content) in
                            NOVELLog(content?.content)
                            NOVELLog("没有缓存，下载完毕\(ZHNReadParser.shared.currentChapter + 1)章")
                            self.hud?.hide(true)
                        }
                    }
                } else {
                    self.hud?.hide(true)
                }
            }
        }        
    }

    // MARK: - 创建 PageController
    /// 创建效果控制器 传入初始化显示控制器
    fileprivate func creatPageController(_ displayController:UIViewController?) {
        // 清理
        if pageViewController != nil {
            pageViewController?.view.removeFromSuperview()
            pageViewController?.removeFromParentViewController()
            pageViewController = nil
        }
        
        if coverController != nil {
            coverController?.view.removeFromSuperview()
            coverController?.removeFromParentViewController()
            coverController = nil
        }
        
        // 创建
        if ZHNReadConfigure.shared().effectType == ZHNEffectType.simulation.rawValue { // 仿真
            let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(value: UIPageViewControllerSpineLocation.min.rawValue as Int)]
            pageViewController = UIPageViewController(transitionStyle:UIPageViewControllerTransitionStyle.pageCurl,navigationOrientation:UIPageViewControllerNavigationOrientation.horizontal,options: options)
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
            // 为了翻页背面的颜色使用
            //pageViewController?.isDoubleSided = true
            view.insertSubview(pageViewController!.view, at: 0)
            addChildViewController(pageViewController!)
            pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        } else { // 无效果 覆盖 上下
            coverController = DZMCoverController()
            coverController?.delegate = self
            view.insertSubview(coverController!.view, at: 0)
            addChildViewController(coverController!)
            coverController?.setController(displayController)
            
            if ZHNReadConfigure.shared().effectType == ZHNEffectType.none.rawValue {
                coverController?.openAnimate = false
            } else if ZHNReadConfigure.shared().effectType == ZHNEffectType.upAndDown.rawValue {
                coverController?.openAnimate = false
                coverController?.gestureRecognizerEnabled = false
            }
        }
        // 记录
        currentReadViewController = displayController as? ZHNReadViewController
    }
    
    // MARK: - 刷新字体相关
    /// 刷新字体
    fileprivate func updateFont(isSave:Bool = false) {
        let location = ZHNReadParser.shared.rangeArray[ZHNReadParser.shared.currentPage].location
        ZHNReadParser.shared.content = currentContent?.content
        ZHNReadParser.shared.currentPage = page(location: location)
    }
    
    /// 通过 Location 获得 Page
    fileprivate func page(location:NSInteger) ->NSInteger {
        let count = ZHNReadParser.shared.rangeArray.count
        for i in 0..<count {
            let range = ZHNReadParser.shared.rangeArray[i]
            if location < (range.location + range.length) {
                return i
            }
        }
        return 0
    }
    
    // MARK: - 缓存记录相关
    fileprivate func saveNovel() {
        NOVELLog("记录缓存")
        // 添加缓存
        self.novelRecord?.last_update_date = self.chapters[self.chapters.count - 1].last_update_date
        self.novelRecord?.article_id = self.novelID
        self.novelRecord?.article_directory_link = currentContent?.article_directory_link
        self.novelRecord?.content = currentContent?.content
        self.novelRecord?.article_directory = currentContent?.article_directory
        self.novelRecord?.pageCount = Int32(ZHNReadParser.shared.pageCount)
        self.novelRecord?.currentPage = Int32(ZHNReadParser.shared.currentPage)
        self.novelRecord?.currentChapterIndex = Int32(ZHNReadParser.shared.currentChapter)
        if currentContent?.content != nil {
            let _ = RecordManager.add(self.novelRecord!)
        }
    }
    
    // MARK: - 展示加载提醒试图
    fileprivate func showHUD() {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = .indeterminate
        hud?.labelText = "正在加载中..."
        hud?.removeFromSuperViewOnHide = true
    }
    
    // MARK: - 获取阅读上下页
    // 上页
    fileprivate func getReadAboveController(currentController: UIViewController?) -> UIViewController? {
        let beforeLookVC: ZHNReadViewController = currentController as! ZHNReadViewController
        let beforeindex = beforeLookVC.currentPage - 1
        let beforeChapterIndex = beforeLookVC.currentChapter
        currentLeft = true
        return GetAboveReadViewController(beforeindex, chapterIndex: beforeChapterIndex)
    }
    
    // 下页
    fileprivate func getReadBelowController(currentController: UIViewController?) -> UIViewController? {
        let afterLookVC: ZHNReadViewController = currentController as! ZHNReadViewController
        let afterindex = afterLookVC.currentPage + 1
        let afterChapterIndex = afterLookVC.currentChapter
        currentLeft = false
        return GetBelowReadViewController(afterindex, chapterIndex: afterChapterIndex)
    }
    
    /// 获取上一页控制器
    fileprivate func GetAboveReadViewController(_ index: Int = 0, chapterIndex: Int = 0) -> ZHNReadViewController?{
        NOVELLog("GetAboveReadViewController")
        
        // 修复bug
        isPreType += 1
        if isPreType != 1 && turnPage && ZHNReadConfigure.shared().effectType == ZHNEffectType.simulation.rawValue {
            NOVELLog("buGGGGGGGGGGG")
            ZHNReadParser.shared.currentChapter += 1
        }
        
        // 页码
        let page = Int((self.novelRecord?.currentPage)!)
        // 小说到开始的最头了
        if page == 0 && self.novelRecord?.currentChapterIndex == 0{
            return nil
        }
        NOVELLog("page = \(page)")
        if page == 0 { // 这一章到头了
            NOVELLog("这一章到头了")
            NOVELLog("index = \(index)")
            isType = 2
            turnPage = true
            ZHNReadParser.shared.currentChapter -= 1
            self.loadContentData()
            ZHNReadParser.shared.currentPage = ZHNReadParser.shared.currentPage != -1 ? ZHNReadParser.shared.pageCount - 1 : 0
            return GetReadViewController(ZHNReadParser.shared.currentPage, chapterIndex: chapterIndex - 1)
        } else { // 没到头
            NOVELLog("index = \(index)")
            turnPage = false
            var aboveIndex = 0
            if index == -1 {
                aboveIndex = ZHNReadParser.shared.pageCount - 1
            } else {
                aboveIndex = index
            }
            ZHNReadParser.shared.currentPage = aboveIndex
            NOVELLog("ZHNReadParser.shared.currentChapter = \(ZHNReadParser.shared.currentChapter)")
            
            return GetReadViewController(aboveIndex, chapterIndex: ZHNReadParser.shared.currentChapter)
        }
    }
    
    /// 获得下一页控制器
    fileprivate func GetBelowReadViewController(_ index: Int = 0, chapterIndex: Int = 0) -> ZHNReadViewController?{
        
        // 修复bug
        if isType == 2 && turnPage && ZHNReadConfigure.shared().effectType == ZHNEffectType.simulation.rawValue{
            ZHNReadParser.shared.currentChapter += 1
            self.currentContent = ContentManager.getContent(chapters[ZHNReadParser.shared.currentChapter].id, article_id: novelID)
            ZHNReadParser.shared.content = self.currentContent?.content
            NOVELLog("BUGBBBBBBBBBB")
        }
        
        isType = 1
        // 页码
        let page = Int((self.novelRecord?.currentPage)!)
        // 最后一页
        let lastPage = ZHNReadParser.shared.pageCount - 1
        NOVELLog("page = \(page) lastpage = \(lastPage)")
        // 小说到最后了
        if page == lastPage && ZHNReadParser.shared.currentChapter >= ZHNReadParser.shared.chapters.count - 1{
            return nil
        }
        
        if page == lastPage{ // 这一章到头了
            NOVELLog("这一章到头了")
            turnPage = true
            ZHNReadParser.shared.currentChapter += 1
            ZHNReadParser.shared.currentPage = 0
            self.loadContentData()
            return GetReadViewController(0, chapterIndex: chapterIndex + 1)
        } else { // 没到头
            NOVELLog("index = \(index)")
            turnPage = false
            var belowIndex = 0
            if index == ZHNReadParser.shared.pageCount {
                belowIndex = ZHNReadParser.shared.pageCount - 1
            } else {
                belowIndex = index
            }
            ZHNReadParser.shared.currentPage = belowIndex
            NOVELLog("ZHNReadParser.shared.currentChapter = \(ZHNReadParser.shared.currentChapter)")
            
            return GetReadViewController(belowIndex, chapterIndex: ZHNReadParser.shared.currentChapter)
        }
    }
    
    /// 获取阅读View控制器
    fileprivate func GetReadViewController(_ index: Int = 0, chapterIndex: Int = 0) ->ZHNReadViewController? {
        self.hud?.hide(true)
        let readViewController = ZHNReadViewController()
        readViewController.readController = self
        readViewController.currentPage = index
        readViewController.delegate = self
        readViewController.currentChapter = chapterIndex
        return readViewController
    }
    
    /// 处理切换失败
    fileprivate func dealCutPageLose() {
        NOVELLog("dealCutPageLose")
        if turnPage == true {
            if currentLeft == true {
                ZHNReadParser.shared.currentChapter += 1
                self.currentContent = ContentManager.getContent(chapters[ZHNReadParser.shared.currentChapter].id, article_id: novelID)
                ZHNReadParser.shared.content = self.currentContent?.content
            } else {
                ZHNReadParser.shared.currentChapter -= 1
                self.currentContent = ContentManager.getContent(chapters[ZHNReadParser.shared.currentChapter].id, article_id: novelID)
                ZHNReadParser.shared.content = self.currentContent?.content
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ZHNReadController: DZMCoverControllerDelegate {
    
    // 切换结果
    func coverController(_ coverController: DZMCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        if !isFinish {
            dealCutPageLose()
        } else {
            currentReadViewController = currentController as? ZHNReadViewController
            saveNovel()
        }
    }
    
    // 将要显示的控制器
    func coverController(_ coverController: DZMCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        readMenu.menuSH(isShow: false)
    }
    
    // 获取上一个控制器
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return getReadAboveController(currentController: currentController)
    }
    
    // 获取下一个控制器
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return getReadBelowController(currentController: currentController)
    }
}

extension ZHNReadController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        NOVELLog("transitionCompleted")
        isType = 0
        isPreType = 0
        if !completed {
            dealCutPageLose()
        } else {
            // 记录
            currentReadViewController = pageViewController.viewControllers?.first as? ZHNReadViewController
            saveNovel()
        }
        pageViewController.view.isUserInteractionEnabled = true
    }
    
    // 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        NOVELLog("willTransitionTo")
        if turnPage {
            pageViewController.view.isUserInteractionEnabled = false
        }
        readMenu.menuSH(isShow: false)
    }
        
    // 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        NOVELLog("viewControllerBefore")
        return getReadAboveController(currentController: viewController)
    }
    
    // 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        NOVELLog("viewControllerAfter")
        return getReadBelowController(currentController: viewController)
    }
}

extension ZHNReadController: ZHNReadMenuDelegate {
    
    /// 背景颜色
    func readMenuClickSetuptColor(readMenu: ZHNReadMenu, index: NSInteger, color: UIColor) {
        ZHNReadConfigure.shared().colorIndex = index
        currentReadViewController?.configureBGColor()
    }
    
    // 翻书动画
    func readMenuClickSetuptEffect(readMenu: ZHNReadMenu, index: NSInteger) {
        ZHNReadConfigure.shared().effectType = index
        self.readVC = GetReadViewController(ZHNReadParser.shared.currentPage, chapterIndex: ZHNReadParser.shared.currentChapter)!
        self.creatPageController(self.readVC)
    }
    
    /// 字体
    func readMenuClickSetuptFont(readMenu: ZHNReadMenu, index: NSInteger) {
        ZHNReadConfigure.shared().fontType = index
        self.readVC = GetReadViewController(ZHNReadParser.shared.currentPage, chapterIndex: ZHNReadParser.shared.currentChapter)!
        updateFont()
        self.creatPageController(self.readVC)
    }
    
    /// 字体大小
    func readMenuClickSetuptFontSize(readMenu: ZHNReadMenu, fontSize: CGFloat) {
        self.readVC = GetReadViewController(ZHNReadParser.shared.currentPage, chapterIndex: ZHNReadParser.shared.currentChapter)!
        updateFont()
        self.creatPageController(self.readVC)
    }
    
    /// 下载
    func readMenuClickDownload(readMenu: ZHNReadMenu) {
        print("点击了下载")
        
        // 已经缓存的内容
        let addContent = ContentManager.getAll(self.novelID)
        if addContent.count == self.chapters.count {
            self.view.toast("已经下载完成了", postion: .middle)
            return
        }
        NOVELLog("已经缓存的章节数\(addContent.count)")
        NOVELLog("没有缓存的章节数\(self.chapters.count - addContent.count)")
        self.view.toast("开始下载", postion: .middle)
        DispatchQueue.global(qos: .userInitiated).async {
            
            var params = [String: AnyObject]()
            params["article_id"] = self.novelID as AnyObject

            ContentFacade.getAllContent(params: params, completion: { (contents) in
                NOVELLog("下载完成")
                self.view.toast("下载完成", postion: .middle)

            })
            
            
            
//            for chapter in self.chapters {
//                var params = [String: AnyObject]()
//                params["id"] = chapter.id as AnyObject
//                
//                // 查看本章是否已经缓存
//                let getContent = ContentManager.getContent(chapter.id, article_id: self.novelID)
//                if getContent != nil {
//                    NOVELLog("已经缓存了\(String(describing: getContent?.article_directory))")
//                    continue
//                }
//                
//                NOVELLog("正在缓存\(chapter.article_directory)")
//                
//                // 缓存没有缓存的内容
//                ContentFacade.getContent(params: params, completion: { (content) in
//                    let totalContent = ContentManager.getAll(self.novelID)
//                    
//                    let process = Float(totalContent.count) / Float(self.chapters.count)
//                    let processStr = String(format:"%.2f",process)
//                    NOVELLog("缓存进度\(processStr.floatValue() * 100)%")
//
//                    if processStr.floatValue()  == 1 {
//                        NOVELLog("下载完成")
//                        self.view.toast("下载完成", postion: .middle)
//                        //hud?.labelText = "下载完成"
//                        //hud?.hide(true, afterDelay: 0.3)
//                    }
//                    
//                })
//            }
        }
    }
    
    /// 拖拽进度条
    func readMenuSliderEndScroll(readMenu: ZHNReadMenu, slider: ASValueTrackingSlider) {
        
    }
    
    /// 上一章
    func readMenuClickPreviousChapter(readMenu: ZHNReadMenu) {
        self.currentLeft = true
        if ZHNReadParser.shared.currentChapter - 1 >= 0 {
            self.showHUD()
            ZHNReadParser.shared.currentChapter -= 1
            ZHNReadParser.shared.currentPage = 0
            self.loadContentData()
            self.saveNovel()
        }
        self.readVC = GetReadViewController()!
        self.readVC.delegate = self
        self.creatPageController(self.readVC)
    }
    
    /// 下一章
    func readMenuClickNextChapter(readMenu: ZHNReadMenu) {
        self.currentLeft = false
        if ZHNReadParser.shared.currentChapter + 1 < ZHNReadParser.shared.chapters.count {
            self.showHUD()
            ZHNReadParser.shared.currentChapter += 1
            ZHNReadParser.shared.currentPage = 0
            self.loadContentData()
            self.saveNovel()
            self.readVC = GetReadViewController()!
            self.readVC.delegate = self
            self.creatPageController(self.readVC)

        }
    }
    
    /// 点击章节列表
    func readMenuClickChapterList(readMenu: ZHNReadMenu, index: Int) {
        self.isJumpChapter = true
        self.showHUD()
        ZHNReadParser.shared.currentPage = 0
        if ZHNReadParser.shared.currentChapter > index {
            self.currentLeft = true
            ZHNReadParser.shared.currentChapter = index
            self.loadContentData()
        } else if ZHNReadParser.shared.currentChapter < index {
            self.currentLeft = false
            ZHNReadParser.shared.currentChapter = index
            self.loadContentData()
        } else {
            ZHNReadParser.shared.currentChapter = index
            self.hud.hide(true)
            self.isJumpChapter = false
        }
    }
    
    /// 返回按钮
    func readMenuBackClick() {
        let novel = NovelManager.getNovel(novelID)
        if novel == nil {
            let alertController = UIAlertController(title: "", message: "喜欢这本书就添加到书架吧", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (al) in
                self.navigationController?.popViewController(animated: true)
            }
            let okAction = UIAlertAction(title: "添加到书架", style: UIAlertActionStyle.destructive){ (al) in
                let _ =  NovelManager.add(self.novel!)
                let notification = Notification(name: bookShelfNotificationName)
                NotificationCenter.default.post(notification)
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ZHNReadController: ZHNReadViewControllerDelegate {
    
    func emptyDataSetDidButton() {
        NOVELLog("重新加载")
        self.isJumpChapter = true
        self.loadContentData()
    }
}


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

    
    /// 
    var pageScrollView: UIScrollView!
    
    /// 
    fileprivate var pageAnimationFinished = false
    
    /// 翻页成功或者失败
    fileprivate var turnPage = true
    
    /// 是否存在更新
    var isUpdate = false
    
    /// 下一章内容
    fileprivate var nextContent: Content?
    
    /// 现在内容
    fileprivate var currentContent: Content?
    
    /// 上一章内容
    fileprivate var preContent: Content?
    
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

    // currentPage
    var currentPage = 0
    
    /// 章节
    var chapters = [Chapter]()
    
    /// 是否跳章节
    fileprivate var isJumpChapter: Bool = false
    
    /// 当前章节
    var currentChapterIndex = 0
    
    /// 当前加载完成的内容数组
    var contents = [Content]()
    
    /// 当前已经缓存的章节数组
    var loadContents = [Content]()
    
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
        //self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        // 设置白色状态栏
        isStatusBarLightContent = true
    
        // 加载提醒视图
        self.showHUD()
        
        // 初始化阅读UI控制对象
        readMenu = ZHNReadMenu.readMenu(vc: self, delegate: self)
        
        readVC.readController = self
        
        // 获取阅读记录
        let record = RecordManager.getRecord(novelID)
        if record.count > 0 {
            currentChapterIndex = Int(record[0].currentChapterIndex)
            currentPage = Int(record[0].currentPage)
        }

        // 获取已经缓存的内容
        loadContents = ContentManager.getAll(novelID)
        
        // 加载小说章节
        loadNovelChaptersData()
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
                readMenu.leftView.reloadData()
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
                self.readMenu.leftView.reloadData()
                // 加载内容
                self.loadContentData()
               })
            }

        } else {
            
            ChapterFacade.getChapterList(params: params, completion: { (chapters) in
                self.chapters = chapters
                ZHNReadParser.shared.chapters = chapters
                self.readMenu.leftView.reloadData()
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
            
            for i in (currentChapterIndex - 1)...(currentChapterIndex + 1) {
                
                if i < 0 || i >= chapters.count {
                    continue
                }
                
                // 是否有缓存
                let getContent = ContentManager.getContent(chapters[i].article_directory_link)
                // 有缓存
                if getContent != nil {
                    if self.isCreatePage == false {
                        self.isCreatePage = true
                    }
                    if i == self.currentChapterIndex - 1 {
                        self.preContent = getContent
                        continue
                    } else if i == self.currentChapterIndex {
                        guard let currentContent = getContent?.content else {
                            return
                        }
                        ZHNReadParser.shared.content = currentContent
                        self.currentContent = getContent
                        self.readVC = self.GetReadViewController()!
                        self.creatPageController(self.readVC)
                        // 添加缓存
                        self.saveNovel()
                        continue
                    } else {
                        self.hud?.hide(true)
                        self.nextContent = getContent
                        self.isJumpChapter = false
                        continue
                    }
                }
                
                NOVELLog("下面有未加载的内容")
                NOVELLog("第\(i)个")
                
                var params = [String: AnyObject]()
                params["article_directory_link"] = chapters[i].article_directory_link as AnyObject
                
                ContentFacade.getContent(params: params) { (content) in
                    
                    
                    if self.isCreatePage == false {
                        self.isCreatePage = true
                    }
                    if i == self.currentChapterIndex - 1 {
                        self.preContent = content
                    } else if i == self.currentChapterIndex {
                        guard let currentContent = content?.content else {
                            return
                        }
                        ZHNReadParser.shared.content = currentContent
                        self.currentContent = content
                        self.readVC = self.GetReadViewController()!
                        self.creatPageController(self.readVC)
                        
                        // 添加缓存
                        self.saveNovel()
                        
                    } else {
                        self.hud?.hide(true)

                        self.nextContent = content
                        self.isJumpChapter = false
                    }
                    if content != nil {
                        self.contents.append(content!)
                    }
                }

            }

        } else {
            // 左边章节
            if currentLeft {
                
                //self.nextContent = self.currentContent
                self.currentContent = ContentManager.getContent(chapters[Int((self.novelRecord?.currentChapterIndex)!) - 1].article_directory_link)
                ZHNReadParser.shared.content = self.currentContent?.content
                
                if currentChapterIndex - 1 >= 0  {
                    // 是否有缓存
                    let getContent = ContentManager.getContent(chapters[currentChapterIndex - 1].article_directory_link)
                    // 有缓存
                    if getContent != nil {
                        self.hud?.hide(true)
                        NOVELLog("有缓存")
                        self.preContent = getContent
                        self.contents.append(getContent!)
                    } else { // 无缓存
                        var params = [String: AnyObject]()
                        params["article_directory_link"] = chapters[currentChapterIndex - 1].article_directory_link as AnyObject
                        ContentFacade.getContent(params: params) { (content) in
                            self.hud?.hide(true)
                            //self.preContent = content
                            //self.contents.append(content!)
                        }
                    }
                } else {
                    self.hud?.hide(true)
                }
                
            } else { // 右边章节
                //self.preContent = ContentManager.getContent(chapters[Int((self.novelRecord?.currentChapterIndex)!) + 1].article_directory_link)
                NOVELLog("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc")

                self.currentContent = ContentManager.getContent(chapters[Int((self.novelRecord?.currentChapterIndex)!) + 1].article_directory_link)
                ZHNReadParser.shared.content = self.currentContent?.content
                
                if currentChapterIndex + 1 < ZHNReadParser.shared.chapters.count {
                    NOVELLog("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD")
                    // 是否有缓存
                    let getContent = ContentManager.getContent(chapters[currentChapterIndex + 1].article_directory_link)
                    // 有缓存
                    if getContent != nil {
                        self.hud?.hide(true)
                        NOVELLog("有缓存")
                        self.nextContent = getContent
                        self.contents.append(getContent!)
                    } else { // 无缓存
                        var params = [String: AnyObject]()
                        params["article_directory_link"] = chapters[currentChapterIndex + 1].article_directory_link as AnyObject
                        ContentFacade.getContent(params: params) { (content) in
                            self.hud?.hide(true)
                            //self.nextContent = content
                            //self.contents.append(content!)
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
        
        //ZHNReadConfigure.shared().effectType = ZHNEffectType.upAndDown.rawValue
        
        // 创建
        if ZHNReadConfigure.shared().effectType == ZHNEffectType.simulation.rawValue { // 仿真
            
            let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(value: UIPageViewControllerSpineLocation.min.rawValue as Int)]
            pageViewController = UIPageViewController(transitionStyle:UIPageViewControllerTransitionStyle.pageCurl,navigationOrientation:UIPageViewControllerNavigationOrientation.horizontal,options: options)
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
            // 为了翻页背面的颜色使用
            pageViewController?.isDoubleSided = true
            
            view.insertSubview(pageViewController!.view, at: 0)
            addChildViewController(pageViewController!)
            
            pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
            for gr in (pageViewController?.gestureRecognizers)! {
                //gr.delegate = self
            }
            
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
        
        let location = ZHNReadParser.shared.rangeArray[currentPage].location
        ZHNReadParser.shared.content = currentContent?.content
        currentPage = page(location: location)
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
        self.novelRecord?.currentPage = Int32(self.currentPage)
        self.novelRecord?.currentChapterIndex = Int32(self.currentChapterIndex)
        let _ = RecordManager.add(self.novelRecord!)
    }
    
    // MARK: - 展示加载提醒试图
    fileprivate func showHUD() {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = .indeterminate
        hud?.labelText = "正在加载中..."
        hud?.removeFromSuperViewOnHide = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ZHNReadController: DZMCoverControllerDelegate {
    
    // 切换结果
    func coverController(_ coverController: DZMCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        
        // 记录
        currentReadViewController = currentController as? ZHNReadViewController

        if !isFinish {
            dealCutPageLose()
        } else {
        }
        saveNovel()
    }
    
    // 将要显示的控制器
    func coverController(_ coverController: DZMCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        readMenu.menuSH(isShow: false)

    }
    
    // 获取上一个控制器
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        currentLeft = true
        return GetAboveReadViewController()
    }
    
    // 获取下一个控制器
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        currentLeft = false
        return GetBelowReadViewController()
    }
}

extension ZHNReadController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            dealCutPageLose()
            currentReadViewController = previousViewControllers.first as? ZHNReadViewController
        } else {
            // 记录
            currentReadViewController = pageViewController.viewControllers?.first as? ZHNReadViewController
        }
        pageAnimationFinished = false
        saveNovel()
    }
    
    // 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        NOVELLog("准备切换")
        pageAnimationFinished = true
        readMenu.menuSH(isShow: false)
    }
        
    // 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        NOVELLog("viewControllerBefore")
        if pageAnimationFinished {
            //return nil
        }
        TempNumber -= 1
    
        if abs(TempNumber) % 2 == 0 { // 背面
            let vc = UIViewController()
            vc.view.backgroundColor = ZHNReadConfigure.shared().readColor().withAlphaComponent(0.95)
            return vc
        } else { // 内容
            currentLeft = true
            return GetAboveReadViewController()
        }
    }
    
    // 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        NOVELLog("viewControllerAfter")
        
        if pageAnimationFinished {
            //return nil
        }
        
        TempNumber += 1
        
        if abs(TempNumber) % 2 == 0 { // 背面
            
            let vc = UIViewController()
            vc.view.backgroundColor =  ZHNReadConfigure.shared().readColor().withAlphaComponent(0.95)
            return vc
            
        }else{ // 内容
            currentLeft = false
            return GetBelowReadViewController()
        }
    }
    
    /// 获取上一页控制器
    fileprivate func GetAboveReadViewController() -> ZHNReadViewController?{
        NOVELLog("GetAboveReadViewController")
        // 页码
        let page = Int((self.novelRecord?.currentPage)!)
        
        // 小说到开始的最头了
        if page == 0 && self.novelRecord?.currentChapterIndex == 0{
            return nil
        }
        if page == 0 { // 这一章到头了
            NOVELLog("这一章到头了")
            turnPage = true
            self.showHUD()
            currentChapterIndex = Int((self.novelRecord?.currentChapterIndex)!) - 1
            self.loadContentData()
            currentPage = currentPage != -1 ? ZHNReadParser.shared.pageCount - 1 : 0
        } else { // 没到头
            NOVELLog("-----")
            turnPage = false
            currentPage = page - 1 >= 0 ? page - 1 : 0
        }
        NOVELLog(currentChapterIndex)
        return GetReadViewController()
    }
    
    /// 获得下一页控制器
    fileprivate func GetBelowReadViewController() -> ZHNReadViewController?{
        
        // 页码
        let page = Int((self.novelRecord?.currentPage)!)
        // 最后一页
        let lastPage = ZHNReadParser.shared.pageCount - 1
        NOVELLog("page = \(page) lastpage = \(lastPage)")
        // 小说到最后了
        if page == lastPage && currentChapterIndex >= ZHNReadParser.shared.chapters.count - 1{
            return nil
        }
        
        if page == lastPage{ // 这一章到头了
            NOVELLog("这一章到头了")
            turnPage = true
            self.showHUD()
            currentChapterIndex = Int((self.novelRecord?.currentChapterIndex)!) + 1
            self.loadContentData()
            currentPage = currentPage == -1 ? ZHNReadParser.shared.pageCount - 1 : 0
        } else { // 没到头
            NOVELLog("-----")
            turnPage = false
            NOVELLog("--\(currentChapterIndex)  --\(Int((self.novelRecord?.currentChapterIndex)!) + 1)")
            // 如果调用下一页控制器的时候，bug调用上一页方法
            if Int((self.novelRecord?.currentChapterIndex)!) + 1 - currentChapterIndex  == 2 && lastPage - page != 1 {
                NOVELLog("$$$$$$$$$$$$$$$$$$$")
                currentChapterIndex += 1
                self.loadContentData()
            }
            currentPage = page + 1 <= lastPage ? page + 1 : lastPage
        }
        NOVELLog(currentChapterIndex)
        return GetReadViewController()
    }
    
    /// 获取阅读View控制器
    fileprivate func GetReadViewController() ->ZHNReadViewController? {
        
        self.hud?.hide(true)
        let readViewController = ZHNReadViewController()
        readViewController.readController = self
        return readViewController
    }
    
    /// 处理切换失败
    fileprivate func dealCutPageLose() {
        NOVELLog("dealCutPageLose")
        // 记录
        if currentLeft {
            currentPage += 1
            
            if turnPage == true {
                NOVELLog("切换失败")
                currentChapterIndex += 1
                currentPage = 0
                self.currentContent = ContentManager.getContent(chapters[currentChapterIndex].article_directory_link)
                ZHNReadParser.shared.content = self.currentContent?.content
            }
        } else {
            
            currentPage -= 1
            
            if turnPage == true {
                NOVELLog("切换失败")
                currentChapterIndex -= 1
                self.currentContent = ContentManager.getContent(chapters[currentChapterIndex].article_directory_link)
                ZHNReadParser.shared.content = self.currentContent?.content
                currentPage =  ZHNReadParser.shared.pageCount - 1
                
            }
        }

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
        self.readVC = GetReadViewController()!
        self.creatPageController(self.readVC)
    }
    
    /// 字体
    func readMenuClickSetuptFont(readMenu: ZHNReadMenu, index: NSInteger) {
        ZHNReadConfigure.shared().fontType = index
        self.readVC = GetReadViewController()!
        updateFont()
        self.creatPageController(self.readVC)
    }
    
    /// 字体大小
    func readMenuClickSetuptFontSize(readMenu: ZHNReadMenu, fontSize: CGFloat) {
        self.readVC = GetReadViewController()!
        updateFont()
        self.creatPageController(self.readVC)
    }
    
    // TODO: -- 书签
    /// 点击书签列表
//    func readMenuClickMarkList(readMenu: DZMReadMenu, readMarkModel: DZMReadMarkModel) {
//        
//        readModel.modifyReadRecordModel(readMarkModel: readMarkModel, isUpdateFont: true, isSave: false)
//        
//        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: false, isSave: true))
//    }

    /// 下载
    func readMenuClickDownload(readMenu: ZHNReadMenu) {
        print("点击了下载")
        
        // 已经缓存的内容
        let addContent = ContentManager.getAll(self.novelID)
        if addContent.count == self.chapters.count {
            return
        }
        NOVELLog("已经缓存的章节数\(addContent.count)")
        NOVELLog("没有缓存的章节数\(self.chapters.count - addContent.count)")

//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud?.mode = .text
//        hud?.labelText = "开始下载"
//        hud?.removeFromSuperViewOnHide = true
//        hud?.xOffset = 0.0
//        hud?.yOffset = 40.0
//        hud?.hide(true, afterDelay: 0.5)
        self.view.toast("开始下载", postion: .middle)
        DispatchQueue.global(qos: .userInitiated).async {
            
            for chapter in self.chapters {
                
                var params = [String: AnyObject]()
                params["article_directory_link"] = chapter.article_directory_link as AnyObject
                
                // 查看本章是否已经缓存
                let getContent = ContentManager.getContent(chapter.article_directory_link)
                if getContent != nil {
                    NOVELLog("已经缓存了\(String(describing: getContent?.article_directory))")
                    continue
                }
                
                NOVELLog("正在缓存\(chapter.article_directory)")
                
                // 缓存没有缓存的内容
                ContentFacade.getContent(params: params, completion: { (content) in
                    let totalContent = ContentManager.getAll(self.novelID)
                    
                    let process = Float(totalContent.count) / Float(self.chapters.count)
                    let processStr = String(format:"%.2f",process)
                    NOVELLog("缓存进度\(processStr.floatValue() * 100)%")

                    if processStr.floatValue()  == 1 {
                        NOVELLog("下载完成")
                        self.view.toast("下载完成", postion: .middle)
                        //hud?.labelText = "下载完成"
                        //hud?.hide(true, afterDelay: 0.3)
                    }
                    
                })
            }
            
        }

    }
    
    /// 拖拽进度条
    func readMenuSliderEndScroll(readMenu: ZHNReadMenu, slider: ASValueTrackingSlider) {
        
    }
    
    /// 上一章
    func readMenuClickPreviousChapter(readMenu: ZHNReadMenu) {
        self.currentLeft = true
        if currentChapterIndex - 1 >= 0 {
            self.showHUD()
            currentChapterIndex -= 1
            currentPage = 0
            self.loadContentData()
            self.saveNovel()
        }
        self.readVC = GetReadViewController()!
        self.creatPageController(self.readVC)
    }
    
    /// 下一章
    func readMenuClickNextChapter(readMenu: ZHNReadMenu) {
        self.currentLeft = false
        if currentChapterIndex + 1 < ZHNReadParser.shared.chapters.count {
            self.showHUD()
            currentChapterIndex += 1
            currentPage = 0
            self.loadContentData()
            self.saveNovel()
        }
        self.readVC = GetReadViewController()!
        self.creatPageController(self.readVC)
    }
    
    /// 点击章节列表
    func readMenuClickChapterList(readMenu: ZHNReadMenu, index: Int) {
        self.isJumpChapter = true
        self.showHUD()
        currentPage = 0
        if currentChapterIndex > index {
            self.currentLeft = true
            currentChapterIndex = index
            self.loadContentData()
        } else if currentChapterIndex < index {
            self.currentLeft = false
            currentChapterIndex = index
            self.loadContentData()
        }
    }
    
    /// 切换日夜间模式
    func readMenuClickLightButton(readMenu: ZHNReadMenu, isDay: Bool) {
        
    }
    
    /// 状态栏 将要 - 隐藏以及显示状态改变
    func readMenuWillShowOrHidden(readMenu: ZHNReadMenu, isShow: Bool) {
        
    }
    
    /// 点击书签按钮
    func readMenuClickMarkButton(readMenu: ZHNReadMenu, button: UIButton) {
        
    }
    
}


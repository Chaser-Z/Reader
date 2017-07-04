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

    /// 是否存在更新
    var isUpdate = false
    
    /// 下一章内容
    fileprivate var nextContent: Content?
    
    /// 现在内容
    fileprivate var currentContent: Content?
    
    /// 上一章内容
    fileprivate var preContent: Content?
    
    /// 文章记录
    fileprivate var novelRecord: ServerRecord? = ServerRecord()
    
    
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
    
    /// 小说id
    var novelID: String!
    
    /// 翻页控制器 (仿真)
    private(set) var pageViewController: UIPageViewController?
    
    /// 翻页控制器 (无效果,覆盖,上下)
    private(set) var coverController:DZMCoverController?

    /// 当前显示的阅读View控制器
    fileprivate(set) var currentReadViewController:ZHNReadViewController?
    
    var readVC = ZHNReadViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        // 设置白色状态栏
        isStatusBarLightContent = true
        
        // 初始化阅读UI控制对象
        readMenu = ZHNReadMenu.readMenu(vc: self, delegate: self)
        
        readVC.readController = self
        
        // 获取阅读记录
        let record = RecordManager.getRecord(novelID)
        if record.count > 0 {
            currentChapterIndex = Int(record[0].currentChapterIndex)
            currentPage = Int(record[0].currentPage)
        }

        
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
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
            hud?.labelText = "正在加载中..."
            hud?.removeFromSuperViewOnHide = true
            
            ChapterFacade.getChapterList(params: params, completion: { (chapters) in
                hud?.hide(true)
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
        
        
        let novle_content = ContentManager.getAll("")
        
//        if novle_content.count > 0 {
//            
//            self.content = novle_content[0]
//            readVC.content = novle_content[0].content
//            if isCreatePage == false {
//                self.creatPageController(readVC)
//                isCreatePage = true
//            }
//            
//        } else {
        
        
        if isCreatePage == false || isJumpChapter == true {
            
            for i in (currentChapterIndex - 1)...(currentChapterIndex + 1) {
                
                if i < 0 || i >= chapters.count {
                    continue
                }
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
                        self.nextContent = content
                        self.isJumpChapter = false
                    }
                    if content != nil {
                        self.contents.append(content!)
                    }
                }

            }

        } else {
            
            if currentLeft {
                

                self.nextContent = self.currentContent
                self.currentContent = self.preContent
                ZHNReadParser.shared.content = self.currentContent?.content
                if currentChapterIndex - 1 >= 0  {
                    
                    var params = [String: AnyObject]()
                    params["article_directory_link"] = chapters[currentChapterIndex - 1].article_directory_link as AnyObject
                    ContentFacade.getContent(params: params) { (content) in
                        self.preContent = content
                        self.contents.append(content!)
                    }

                }
                
                
            } else {
                
                self.preContent = self.currentContent
                self.currentContent = self.nextContent
                ZHNReadParser.shared.content = self.currentContent?.content

                if currentChapterIndex + 1 < ZHNReadParser.shared.chapters.count {
                    var params = [String: AnyObject]()
                    params["article_directory_link"] = chapters[currentChapterIndex + 1].article_directory_link as AnyObject
                    ContentFacade.getContent(params: params) { (content) in
                        self.nextContent = content
                        self.contents.append(content!)
                    }
                } else{
                    
                    print("超了啊")
                }
 
            }

        }
        //}
        
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
            // 记录
            if currentLeft {
                currentPage += 1
                
            } else {
                currentPage -= 1
            }
        } else {
            
            saveNovel()
        }
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
            // 记录
            if currentLeft {
                currentPage += 1

            } else {
                currentPage -= 1
            }
            currentReadViewController = previousViewControllers.first as? ZHNReadViewController
        } else {
         
            // 记录
            currentReadViewController = pageViewController.viewControllers?.first as? ZHNReadViewController
            saveNovel()
        }
    }
    
    // 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        readMenu.menuSH(isShow: false)
    }
    
    // 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
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
        
        // 小说到开始的最头了
        if currentPage == 0 && currentChapterIndex == 0{
            return nil
        }
        if currentPage == 0 { // 这一章到头了
            currentChapterIndex -= 1
            self.loadContentData()
            currentPage = ZHNReadParser.shared.pageCount - 1
        } else { // 没到头
            currentPage -= 1
        }
        return GetReadViewController()
    }
    
    /// 获得下一页控制器
    fileprivate func GetBelowReadViewController() -> ZHNReadViewController?{
        
        // 小说到最后了
        if currentPage == ZHNReadParser.shared.pageCount - 1 && currentChapterIndex >= ZHNReadParser.shared.chapters.count - 1{
            return nil
        }
        // 页码
        //let page = currentPage
        // 最后一页
        let lastPage = ZHNReadParser.shared.pageCount - 1
        
        if currentPage == lastPage{ // 这一章到头了
            currentChapterIndex += 1
            self.loadContentData()
            currentPage = 0
        } else { // 没到头
            currentPage += 1
        }
        return GetReadViewController()
    }
    
    /// 获取阅读View控制器
    fileprivate func GetReadViewController() ->ZHNReadViewController? {
        
        let readViewController = ZHNReadViewController()
        readViewController.readController = self
        return readViewController
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
    }
    
    /// 拖拽进度条
    func readMenuSliderEndScroll(readMenu: ZHNReadMenu, slider: ASValueTrackingSlider) {
        
    }
    
    /// 上一章
    func readMenuClickPreviousChapter(readMenu: ZHNReadMenu) {
        self.currentLeft = true
        if currentChapterIndex - 1 >= 0 {
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


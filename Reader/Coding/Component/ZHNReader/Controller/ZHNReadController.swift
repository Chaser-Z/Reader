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
    
    /// 是否加载完成本章节
    fileprivate var isLoad: Bool = false
    
    /// 当前章节
    var currentChapterIndex = 0
    
    /// 内容
    var content: Content?
    
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
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        readVC.readController = self
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
            // 加载内容
            loadContentData()

        } else {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
            hud?.labelText = "正在加载中..."
            hud?.removeFromSuperViewOnHide = true
            
            ChapterFacade.getChapterList(params: params, completion: { (chapters) in
                hud?.hide(true)
                self.chapters = chapters
                // 加载内容
                self.loadContentData()
                for chapter in chapters {
                    NOVELLog(chapter.article_directory)
                }
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
        
        if isCreatePage == false {
            
            for i in 0...2 {
                var params = [String: AnyObject]()
                params["article_directory_link"] = chapters[i].article_directory_link as AnyObject
                
                ContentFacade.getContent(params: params) { (content) in
                    if self.isCreatePage == false {
                        self.isLoad = true
                        self.content = content
                        ZHNReadParser.shared.content = content.content
                        self.readVC.content = content.content
                        self.creatPageController(self.readVC)
                        self.isCreatePage = true
                    }
                    self.contents.append(content)
                }

            }

        } else {
            
            if currentLeft {
                
                ZHNReadParser.shared.content = self.contents[currentChapterIndex].content
                
            } else {
                
                ZHNReadParser.shared.content = self.contents[currentChapterIndex].content

                var params = [String: AnyObject]()
                params["article_directory_link"] = chapters[currentChapterIndex + 2].article_directory_link as AnyObject
                ContentFacade.getContent(params: params) { (content) in
                    self.isLoad = true
                    self.content = self.contents[self.currentChapterIndex]
                    self.contents.append(content)
                    self.readVC.content = self.content?.content
                }

            }

        }
        //}
        
    }

    // MARK: -- 创建 PageController
    /// 创建效果控制器 传入初始化显示控制器
    private func creatPageController(_ displayController:UIViewController?) {
        
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
    }
    
    // 将要显示的控制器
    func coverController(_ coverController: DZMCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        
    }
    
    // 获取上一个控制器
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return getReadViewController(isLeft: true)
    }
    
    // 获取下一个控制器
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {

        return getReadViewController(isLeft: false)
    }
}

extension ZHNReadController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            // 记录
            currentReadViewController = previousViewControllers.first as? ZHNReadViewController
        } else {
         
            // 记录
            currentReadViewController = pageViewController.viewControllers?.first as? ZHNReadViewController
        }
    }
    
    // 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    // 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        TempNumber -= 1
    
        if abs(TempNumber) % 2 == 0 { // 背面
            let vc = UIViewController()
            vc.view.backgroundColor = ZHNReadConfigure.shared().readColor().withAlphaComponent(0.95)
            return vc
        } else { // 内容
            
            return getReadViewController(isLeft: true)
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
            
            return getReadViewController(isLeft: false)
        }
    }
    
    /// 获取书页
    fileprivate func getReadViewController(isLeft: Bool) -> UIViewController?{
        let readVC = ZHNReadViewController()
        readVC.readController = self
        //ZHNReadParser.shared.content = self.contents[currentChapterIndex].content
        readVC.readController.currentPage = getCurrentPage(isLeft: isLeft)
        readVC.content = self.contents[currentChapterIndex].content
        currentReadViewController = readVC
        return currentReadViewController
    }
    
    /// getcurrentPage
    fileprivate func getCurrentPage(isLeft: Bool) -> Int {
        
        if isLeft {
            self.currentLeft = true
            if currentPage <= 0 {
                if currentChapterIndex > 0 {
                    currentChapterIndex -= 1
                    self.loadContentData()
                    return ZHNReadParser.shared.pageCount - 1
                }
                return 0
            }
            currentPage -= 1
        } else {
            self.currentLeft = false
            if currentPage >= (ZHNReadParser.shared.pageCount - 1) {
                if currentChapterIndex < chapters.count {
                    currentChapterIndex += 1
                    self.loadContentData()
                    return 0
                }
                return currentPage
            }
            
            currentPage += 1
        }
        return currentPage
    }
}

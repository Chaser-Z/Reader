//
//  ReadOperation.swift
//  Reader
//
//  Created by 张海南 on 2017/6/19.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ReadOperation: NSObject {
    
    /// 阅读控制器
    weak var vc:ReadController!
    
    // MARK: -- init
    
    init(vc:ReadController) {
        
        super.init()
        
        self.vc = vc
    }
    
    // MARK: -- 获取阅读控制器 ReadViewController
    
    /// 获取阅读View控制器
    func GetReadViewController(readRecordModel:ReadRecordModel?) ->ReadViewController? {
        
        if readRecordModel != nil {
            
            let readViewController = ReadViewController()
            
            readViewController.readRecordModel = readRecordModel
            
            readViewController.readController = vc
            
            return readViewController
        }
        
        return nil
    }
    
    /// 获取当前阅读记录的阅读View控制器
    func GetCurrentReadViewController(isUpdateFont:Bool = false, isSave:Bool = false) ->ReadViewController? {
        
        if isUpdateFont {
            
            vc.readModel.readRecordModel.updateFont(isSave: true)
        }
        
        if isSave {
            
            readRecordUpdate(readRecordModel: vc.readModel.readRecordModel)
        }
        
        return GetReadViewController(readRecordModel: vc.readModel.readRecordModel.copySelf())
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->ReadViewController? {
        
        // 没有阅读模型
        if vc.readModel == nil || !vc.readModel.readRecordModel.isRecord {return nil}
        
        // 阅读记录
        var readRecordModel:ReadRecordModel?
        
        // 判断
        if vc.readModel.isLocalBook.boolValue { // 本地小说
            
            // 获得阅读记录
            readRecordModel = vc.readModel.readRecordModel.copySelf()
            
            // 章节ID
            let id = vc.readModel.readRecordModel.readChapterModel!.id.integerValue()
            
            // 页码
            let page = vc.readModel.readRecordModel.page.intValue
            
            // 到头了
            if id == 1 && page == 0 {return nil}
            
            if page == 0 { // 这一章到头了
                
                readRecordModel?.modify(chapterID: "\(id - 1)", toPage: ReadLastPageValue, isUpdateFont:true, isSave: false)
                
            }else{ // 没到头
                
                readRecordModel?.page = NSNumber(value: (page - 1))
            }
            
        }else{ // 网络小说
            
            // 这里进行网络数据请求以及一些判断 当请求成功之后 使用(确保请求之后修改阅读记录模型)
            // vc.creatPageController(GetCurrentReadViewController())
            
            readRecordModel = nil
        }
        
        return GetReadViewController(readRecordModel: readRecordModel)
    }
    
    
    /// 获得下一页控制器
    func GetBelowReadViewController() ->ReadViewController? {
        
        // 没有阅读模型
        if vc.readModel == nil || !vc.readModel.readRecordModel.isRecord {return nil}
        
        // 阅读记录
        var readRecordModel:ReadRecordModel?
        
        // 判断
        if vc.readModel.isLocalBook.boolValue { // 本地小说
            
            // 获得阅读记录
            readRecordModel = vc.readModel.readRecordModel.copySelf()
            
            // 章节ID
            let id = vc.readModel.readRecordModel.readChapterModel!.id.integerValue()
            
            // 页码
            let page = vc.readModel.readRecordModel.page.intValue
            
            // 最后一页
            let lastPage = vc.readModel.readRecordModel.readChapterModel!.pageCount.intValue - 1
            
            // 到头了
            if id == vc.readModel.readChapterListModels.count && page == lastPage {return nil}
            
            if page == lastPage { // 这一章到头了
                
                readRecordModel?.modify(chapterID: "\(id + 1)", isUpdateFont: true)
                
            }else{ // 没到头
                
                readRecordModel?.page = NSNumber(value: (page + 1))
            }
            
        }else{ // 网络小说
            
            // 这里进行网络数据请求以及一些判断 当请求成功之后 使用(确保请求之后修改阅读记录模型)
            // vc.creatPageController(GetCurrentReadViewController())
            
            readRecordModel = nil
        }
        
        return GetReadViewController(readRecordModel: readRecordModel)
    }
    
    /// 跳转指定章节 指定页码 (toPage: -1 为最后一页 也可以使用 ReadLastPageValue)
    func GoToChapter(chapterID:String, toPage:NSInteger = 0) ->Bool {
        
        if vc.readModel != nil { // 有阅读模型
            
            if ReadChapterModel.IsExistReadChapterModel(bookID: vc.readModel.bookID, chapterID: chapterID) { //  存在
                
                vc.readModel.modifyReadRecordModel(chapterID: chapterID, page: toPage, isSave: false)
                
                vc.creatPageController(GetCurrentReadViewController(isUpdateFont: true, isSave: true))
                
                return true
                
            }else{ // 不存在
                
                return false
            }
        }
        
        return false
    }
    
    // MARK: -- 同步记录
    
    /// 更新记录
    func readRecordUpdate(readViewController:ReadViewController?, isSave:Bool = true) {
        
        readRecordUpdate(readRecordModel: readViewController?.readRecordModel, isSave: isSave)
    }
    
    /// 更新记录
    func readRecordUpdate(readRecordModel:ReadRecordModel?, isSave:Bool = true) {
        
        if readRecordModel != nil {
            
            vc.readModel.readRecordModel = readRecordModel
            
            if isSave {
                
                // 保存
                vc.readModel.readRecordModel.save()
                
                // 更新UI
                DispatchQueue.main.async { [weak self] ()->Void in
                    
                    // 进度条数据初始化
                    self?.vc.readMenu.bottomView.sliderUpdate()
                }
            }
        }
    }
}

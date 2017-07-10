//
//  UIView+Loading.swift
//  FileDownLoadDemo
//
//  Created by yeeaoo on 15/9/16.
//  Copyright (c) 2015年 ZHN. All rights reserved.
//

import Foundation
import UIKit


let LOADING_VIEW_SIZE: CGFloat = 50.0
let FONT_SIZE = 15.0
let LOADING_VIEW_SIZE_TXT = 100.0
let LOADING_LABLE_HEIGHT: CGFloat = 15.0
let LOADING_VIEW_CORNER: CGFloat = 10.0
let LOADING_VIEW_ALPHA: CGFloat = 1.0
let LOADING_VIEW_TAG = 10000000
let LOADING_PAD: CGFloat = 15.0
let LOADING_TXT = "请稍等。。。"

extension UIView {
    
    
    func createLoadingViewWithIsTxt(_ isTxt: Bool, customTitle: String?) -> UIView
    {
        
        var title = customTitle

        let screenSize = UIScreen.main.bounds.size
        let backViewSize: CGFloat = LOADING_VIEW_SIZE
        
        if isTxt == true
        {
            if customTitle == ""
            {
                title  = LOADING_TXT
            }
            if (title!).characters.count == 0
            {
                title  = LOADING_TXT
            }
        }
        
        let backView: UIView = UIView(frame: CGRect(x: (screenSize.width - backViewSize) / 2.0 , y: screenSize.height / 2.0, width: backViewSize, height: backViewSize))
        backView.layer.cornerRadius = LOADING_VIEW_CORNER
        backView.backgroundColor = UIColor.black
        backView.alpha = LOADING_VIEW_ALPHA
        backView.clipsToBounds = true
        backView.tag = LOADING_VIEW_TAG
        
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        if isTxt == true
        {
            indicatorView.center = CGPoint(x: backView.frame.width / 2.0, y: (backView.frame.height - LOADING_LABLE_HEIGHT) / 2.0)
        }
        else
        {
            indicatorView.center = CGPoint(x: backView.frame.width / 2.0, y: backView.frame.height / 2.0)
            
        }
        indicatorView.startAnimating()
        backView.addSubview(indicatorView)
        
        if isTxt == true
        {
            let labTxt = UILabel(frame: CGRect(x: LOADING_PAD, y: indicatorView.frame.height + indicatorView.frame.origin.y + 5.0, width: backView.frame.width - LOADING_PAD * 2.0, height: LOADING_LABLE_HEIGHT))
            labTxt.backgroundColor = UIColor.clear
            labTxt.minimumScaleFactor = 0.2
            labTxt.adjustsFontSizeToFitWidth = true
            labTxt.text = customTitle
            labTxt.textAlignment = NSTextAlignment.center
            labTxt.textColor = UIColor.white
            backView.addSubview(labTxt)
        }
        return backView
        
        
    }
    
    func baseStartLoadingWithUser(_ isUser: Bool, isTxt: Bool, customTitle: String?)
    {
        let loadingView: UIView? = self.viewWithTag(LOADING_VIEW_TAG)
        if loadingView == nil
        {
            self.alpha = 1.0
            self.isUserInteractionEnabled = isUser
            self.addSubview(self.createLoadingViewWithIsTxt(isTxt, customTitle: customTitle))
        }
        
    }
    func baseStopLoadingWithUser(_ isUser: Bool)
    {
        var clearView: UIView? = self.viewWithTag(LOADING_VIEW_TAG)
        if clearView != nil
        {
            self.alpha = 1.0
            self.isUserInteractionEnabled = isUser
            clearView?.removeFromSuperview()
            clearView = nil
        }

    }
    
    
    
    func startLoading()
    {
        self.baseStartLoadingWithUser(false, isTxt: false, customTitle: nil)
    }
    func stopLoading()
    {
        self.baseStopLoadingWithUser(true)
    }
    func startLoadingWithTxt(_ customTitle: String)
    {
        self.baseStartLoadingWithUser(false, isTxt: true, customTitle: customTitle)
    }
    func stopLoadingWithTxt()
    {
        self.startLoading()
    }
    func startLoadingWithTxtUser(_ customTitle: String)
    {
        self.baseStartLoadingWithUser(true, isTxt: true, customTitle: customTitle)
    }
    func stopLoadingWithTxtUser()
    {
        self.stopLoading()
    }
    func startLoadingWithUser()
    {
        self.baseStartLoadingWithUser(true, isTxt: false, customTitle: nil)
    }
    func stopLoadingWithUser()
    {
        self.stopLoading()
    }
    
}

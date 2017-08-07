//
//  ShareView.swift
//  Reader
//
//  Created by 张海南 on 2017/8/4.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ShareView: UIView , UIScrollViewDelegate {
    
    fileprivate var shareContent:String!
    fileprivate var shareImage:UIImage!
    fileprivate var shareUrl:String!
    fileprivate var shareTitle:String!
    fileprivate var contentHeight:CGFloat = 220
    
    fileprivate var bgView:UIView!
    fileprivate var contentView:UIView!
    fileprivate var rootVC:UIViewController!
    fileprivate var scrollView:UIScrollView!
    fileprivate var pageControl:UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bgView = UIView.init(frame: self.bounds)
        self.bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0.0
        self.addSubview(self.bgView)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.bgViewTapped))
        self.bgView.addGestureRecognizer(tapGesture)
        
        self.contentView = UIView.init(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(self.contentView)
        
        let sharePaltformArray = [
            [ "share_weixin", "share_friend", "share_sina" , "share_qq", "share_zone"],
            [ "微信","朋友圈", "微博", "QQ", "QQ空间"]
        ]
        
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 130))
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.contentSize = CGSize(width: frame.width * CGFloat(self.pageNum(sharePaltformArray[0].count)), height: 0)
        self.contentView.addSubview(self.scrollView)
        
        
        self.pageControl = UIPageControl.init(frame: CGRect(x: 0, y: self.scrollView.frame.height, width: frame.width, height: 35))
        self.pageControl.backgroundColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = pageNum(sharePaltformArray[0].count)
        self.contentView.addSubview(self.pageControl)
        
        
        
        let buttonWidth:CGFloat = 55.0
        let buttonGap = ( frame.width - buttonWidth * 4 ) / 5
        
        for i in 0 ..< 5 {
            
            let shareButton = UIButton(type:.custom)
            
            let btnRect = CGRect(x: buttonGap * ( CGFloat(i) + 1) + buttonWidth * CGFloat(i) + (i % 4 == 0 && i != 0 ? 20 : 0), y: 40, width: buttonWidth, height: buttonWidth)
            
            shareButton.frame = btnRect
            shareButton.tag = 100 + i
            shareButton.addTarget(self, action: #selector(self.shareButtonClicked(_:)), for: .touchUpInside)
            shareButton.setBackgroundImage(UIImage(named: sharePaltformArray[0][i]), for: UIControlState())
            shareButton.setBackgroundImage(UIImage(named: sharePaltformArray[0][i] + "_hover"), for: .highlighted)
            shareButton.layer.cornerRadius = buttonWidth / 2
            shareButton.layer.masksToBounds = true
            self.scrollView.addSubview(shareButton)
            
            let shareLabel = UILabel.init(frame: CGRect(x: shareButton.frame.minX, y: shareButton.frame.maxY + 10 , width: shareButton.frame.width, height: 15))
            shareLabel.font = UIFont.systemFont(ofSize: 13)
            shareLabel.textColor = UIColor.init(red: 0.24, green: 0.24, blue: 0.25, alpha: 1.0)
            shareLabel.textAlignment = .center
            shareLabel.text = sharePaltformArray[1][i]
            self.scrollView.addSubview(shareLabel)
        }
        
        let cancelBtn = UIButton(type:.custom)
        cancelBtn.frame = CGRect(x: 0, y: self.contentView.frame.height - 44, width: self.contentView.frame.width, height: 44)
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.setTitleColor(UIColor.black, for: UIControlState())
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnClicked), for: .touchUpInside)
        self.contentView.addSubview(cancelBtn)
    }
    
    
    func setShareModel(_ content:String , image:UIImage , url:String , title:String) {
        
        self.shareContent = content
        self.shareImage = image
        self.shareUrl = url
        self.shareTitle = title
        
    }
    
    /**
     遮罩背景响应事件
     */
    func bgViewTapped() {
        
        self.dismiss()
        
    }
    
    /**
     取消按钮响应事件
     */
    func cancelBtnClicked() {
        
        self.dismiss()
        
    }
    
    /**
     分享按钮响应事件
     */
    func shareButtonClicked(_ sender:UIButton) {
        
        let snsTypes:Array<AnyObject>!
        var currentShareType:String!
        if sender.tag == 100 {
            // 1.创建分享参数
            let shareParames = NSMutableDictionary()
            
            
            
            
            shareParames.ssdkSetupShareParams(byText: "分享内容",
                                              images : #imageLiteral(resourceName: "logo1"),
                                              url : NSURL(string:"https://itunes.apple.com/us/app/免阅/id1255400240?l=zh&ls=1&mt=8") as URL!,
                                              title : "一款不错的app,免费阅读小说",
                                              type : SSDKContentType.image)
            
            //2.进行分享
            ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
                
                switch state{
                    
                case SSDKResponseState.success: print("分享成功")
                case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                case SSDKResponseState.cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            }
        }else if sender.tag == 100 + 1 {
            // 1.创建分享参数
            let shareParames = NSMutableDictionary()
            shareParames.ssdkSetupShareParams(byText: "分享内容",
                                              images : #imageLiteral(resourceName: "logo1"),
                                              url : NSURL(string:"https://itunes.apple.com/us/app/免阅/id1255400240?l=zh&ls=1&mt=8") as URL!,
                                              title : "分享标题",
                                              type : SSDKContentType.webPage)
            
            //2.进行分享
            ShareSDK.share(SSDKPlatformType.subTypeQQFriend, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
                
                switch state{
                    
                case SSDKResponseState.success: print("分享成功")
                case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                case SSDKResponseState.cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            }
        }else if sender.tag == 100 + 2 {
            //            snsTypes = [UMShareToSina]
            currentShareType = "2"
            
            self.shareContent = self.shareUrl + self.shareContent
            
            guard self.shareTitle.characters.count > 0 else{
                //                UMSocialData.defaultData().extConfig.qzoneData.title = "  "
                return
            }
            //            UMSocialData.defaultData().extConfig.qzoneData.title = self.shareTitle
            //            UMSocialData.defaultData().extConfig.qzoneData.url = self.shareUrl
        }else if sender.tag == 100 + 3 {
            //            snsTypes = [UMShareToQQ]
            currentShareType = "4"
            guard self.shareTitle.characters.count > 0 else{
                //                UMSocialData.defaultData().extConfig.qqData.title = "  "
                return
            }
            //            UMSocialData.defaultData().extConfig.qqData.title = self.shareTitle
            //            UMSocialData.defaultData().extConfig.qqData.url = self.shareUrl
        }else if sender.tag == 100 + 4 {
            //            snsTypes = [UMShareToQzone]
            currentShareType = "3"
            guard self.shareTitle.characters.count > 0 else{
                //                UMSocialData.defaultData().extConfig.qzoneData.title = "  "
                return
            }
            //            UMSocialData.defaultData().extConfig.qzoneData.title = self.shareTitle
            //            UMSocialData.defaultData().extConfig.qzoneData.url = self.shareUrl
        }else{
            snsTypes = []
            currentShareType = " "
        }
        
        
    }
    
    func showInViewController(_ viewController:UIViewController){
        self.rootVC = viewController
        self.showInView(viewController.view)
    }
    
    fileprivate func dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentHeight)
            
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
        
        
    }
    
    fileprivate func pageNum(_ num:Int) -> Int {
        return (num % 4 == 0 ? 0 : 1) + num / 4
    }
    
    fileprivate func showInView(_ parentView:UIView) {
        
        parentView.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.4
            self.contentView.frame = CGRect(x: 0, y: self.frame.height - self.contentHeight, width: self.frame.width, height: self.contentHeight)
        })
        
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.bounds.width
        let pageFraction = self.scrollView.contentOffset.x / pageWidth
        self.pageControl.currentPage = Int(pageFraction)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

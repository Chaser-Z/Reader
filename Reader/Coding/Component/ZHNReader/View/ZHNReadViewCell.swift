//
//  ZHNReadViewCell.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNReadViewCell: UITableViewCell {

    /// 阅读View 显示使用
    private(set) var readView: ZHNReadView!

    /// 当前的显示的内容
    var content:String! {
        
        didSet{
            
            if !content.isEmpty { // 有值
                
                readView.content = content
            }
        }
    }

    class func cellWithTableView(_ tableView:UITableView) ->ZHNReadViewCell {
        
        let ID = "ZHNReadViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? ZHNReadViewCell
        
        if (cell == nil) {
            
            cell = ZHNReadViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubViews()
    }
    
    func addSubViews() {
        
        // 阅读View
        readView = ZHNReadView()
        
        readView.backgroundColor = UIColor.clear
        
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 布局
        readView.frame = GetReadViewFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

}

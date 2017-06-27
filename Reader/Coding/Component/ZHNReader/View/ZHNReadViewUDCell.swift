//
//  ZHNReadViewUDCell.swift
//  Reader
//
//  Created by 张海南 on 2017/6/24.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ZHNReadViewUDCell: UITableViewCell {

    /// UITableView
    var tableView:UITableView!
    

    /// ReadChapterModel
    var readChapterModel:Content? {
        
        didSet{
            
            tableView.reloadData()
            
            setNeedsLayout()
        }
    }

    class func cellWithTableView(_ tableView:UITableView) -> ZHNReadViewUDCell {
        
        let ID = "ZHNReadViewUDCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? ZHNReadViewUDCell
        
        if (cell == nil) {
            
            cell = ZHNReadViewUDCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        ZHNReadParser.shared.content = readChapterModel?.content
        backgroundColor = UIColor.clear
        addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
    }

    
}

extension ZHNReadViewUDCell: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readChapterModel != nil ? ZHNReadParser.shared.pageCount : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ZHNReadViewCell.cellWithTableView(tableView)
        
        cell.content = ZHNReadParser.shared.string(page: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return GetReadTableViewFrame().height
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }

    
    
}

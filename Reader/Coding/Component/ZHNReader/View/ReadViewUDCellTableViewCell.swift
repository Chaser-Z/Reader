//
//  ReadViewUDCellTableViewCell.swift
//  Reader
//
//  Created by 张海南 on 2017/6/20.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class ReadViewUDCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    /// UITableView
    var tableView:UITableView!
    
    /// ReadChapterModel
    var readChapterModel:ReadChapterModel? {
        
        didSet{
            
            tableView.reloadData()
            
            setNeedsLayout()
        }
    }
    
    class func cellWithTableView(_ tableView:UITableView) ->ReadViewUDCell {
        
        let ID = "ReadViewUDCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? ReadViewUDCell
        
        if (cell == nil) {
            
            cell = ReadViewUDCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID)
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
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return readChapterModel != nil ? readChapterModel!.pageCount.intValue : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ReadViewCell.cellWithTableView(tableView)
        
        cell.content = readChapterModel!.string(page: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return GetReadTableViewFrame().height
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}

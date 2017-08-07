//
//  EmptyDataSetView.swift
//  Reader
//
//  Created by 张海南 on 2017/8/7.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import UIKit

class EmptyDataSetView: UIView {

    class func newInstance() -> EmptyDataSetView? {
        let nibViews = Bundle.main.loadNibNamed("EmptyDataSetView", owner: nil, options: nil)
        if let view = nibViews?.first as? EmptyDataSetView {
            view.backgroundColor = UIColor.white
            return view
        }
        return nil
    }
    
    @IBAction func btnAction(_ sender: Any) {
        NOVELLog("btnAction")
    }
}

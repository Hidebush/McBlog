//
//  YHRefreshConrol.swift
//  McBlog
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

private let 
class YHRefreshConrol: UIRefreshControl {
    override init() {
        super.init()
        setUpUI()
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(change)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    private func setUpUI() {
        tintColor = UIColor.clearColor() 
        addSubview(refreshView)
        refreshView.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - 160.0) * 0.5, 0, 160, 60)
    }
    
    
    private lazy var refreshView: YHRefreshView = YHRefreshView.refreshView()
}

class YHRefreshView: UIView {
    class func refreshView() -> YHRefreshView {
        return NSBundle.mainBundle().loadNibNamed("YHRefreshView", owner: nil, options: nil).last as! YHRefreshView
    }
}
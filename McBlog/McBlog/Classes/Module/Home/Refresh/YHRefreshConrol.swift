//
//  YHRefreshConrol.swift
//  McBlog
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

private let refreshViewOffset: CGFloat = -60
class YHRefreshConrol: UIRefreshControl {
    override init() {
        super.init()
        setUpUI()
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoading()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y > 0 {
            return
        }
        
        if refreshing {
            refreshView.startLoading()
        }
        
        if frame.origin.y < refreshViewOffset && !refreshView.rotateFlag {
            refreshView.rotateFlag = true
        } else if frame.origin.y > refreshViewOffset && refreshView.rotateFlag {
            refreshView.rotateFlag = false
        }
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
        refreshView.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - 160.0) * 0.5-15, 0, 160, 60)
    }
    
    
    private lazy var refreshView: YHRefreshView = YHRefreshView.refreshView()
}

class YHRefreshView: UIView {
    
    private var rotateFlag: Bool = false {
        didSet {
            rotateIconAnim()
        }
    }
    @IBOutlet weak var rotateIcon: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var loadingIcon: UIImageView!
    
    class func refreshView() -> YHRefreshView {
        return NSBundle.mainBundle().loadNibNamed("YHRefreshView", owner: nil, options: nil).last as! YHRefreshView
    }
    
    private func rotateIconAnim() {
        let angel = rotateFlag ? CGFloat(M_PI - 0.01) : CGFloat(M_PI + 0.01)
        UIView.animateWithDuration(0.25) {
            self.rotateIcon.transform = CGAffineTransformRotate(self.rotateIcon.transform, angel)
        }
    }
    
    private func startLoading() {
        tipView.hidden = true
        if layer.animationForKey("loadingAnim") != nil {
            return
        }
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2*M_PI
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        anim.duration = 1
        loadingIcon.layer.addAnimation(anim, forKey: "loadingAnim")
    }
    
    private func stopLoading() {
        tipView.hidden = false
        loadingIcon.layer.removeAllAnimations()
    }
    
}
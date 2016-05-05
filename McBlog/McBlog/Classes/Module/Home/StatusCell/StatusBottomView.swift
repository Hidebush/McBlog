//
//  StatusBottomView.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class StatusBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        forwardButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(commentButton.snp_width)
        }
        
        commentButton.snp_makeConstraints { (make) in
            make.left.equalTo(forwardButton.snp_right)
            make.width.equalTo(likeButton.snp_width)
            make.top.bottom.equalTo(self)
        }
        
        likeButton.snp_makeConstraints { (make) in
            make.left.equalTo(commentButton.snp_right)
            make.top.bottom.right.equalTo(self)
        }
    }
    
    private lazy var forwardButton: UIButton = UIButton(title: "转发", imageName: "timeline_icon_retweet")
    private lazy var commentButton: UIButton = UIButton(title: "评论", imageName: "timeline_icon_comment")
    private lazy var likeButton: UIButton = UIButton(title: "赞", imageName: "timeline_icon_unlike")
    
    
    

}

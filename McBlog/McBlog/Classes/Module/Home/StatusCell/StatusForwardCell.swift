//
//  StatusForwardCell.swift
//  McBlog
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class StatusForwardCell: StatusCell {
    
    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = "@" + name + ":" + text
            
            let pictureViewTopMargin = status?.picURLs?.count == 0 ? 0 : statusCellMarginEight
            pictureView.snp_remakeConstraints { (make) in
                make.top.equalTo(forwardLabel.snp_bottom).offset(pictureViewTopMargin)
                make.left.equalTo(forwardLabel)
                make.width.equalTo(pictureView.bounds.size.width)
                make.height.equalTo(pictureView.bounds.size.height)
            }
        }
    }
    

    override func setUpUI() {
        super.setUpUI()
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: backButton)
        
        backButton.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(statusCellMarginEight)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(bottomView.snp_top)
        }
        
        forwardLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(backButton).offset(statusCellMarginEight)
            make.right.equalTo(backButton).offset(-statusCellMarginEight)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.top.equalTo(forwardLabel.snp_bottom).offset(statusCellMarginEight)
            make.left.equalTo(forwardLabel)
            make.width.equalTo(forwardLabel.snp_width)
            make.height.equalTo(290)
        }
    }
    
    private lazy var forwardLabel: UILabel = {
       let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 2.0 * statusCellMarginEight
        return label
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        return button
    }()
}

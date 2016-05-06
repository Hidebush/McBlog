//
//  StatusNormalCell.swift
//  McBlog
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {

    override var status: Status? {
        didSet {
            let pictureViewTopMargin = status?.picURLs?.count == 0 ? 0 : statusCellMarginEight
            pictureView.snp_remakeConstraints { (make) in
                make.top.equalTo(contentLabel.snp_bottom).offset(pictureViewTopMargin)
                make.left.equalTo(contentLabel)
                make.width.equalTo(pictureView.bounds.size.width)
                make.height.equalTo(pictureView.bounds.size.height)
            }
        }
    }
    override func setUpUI() {
        super.setUpUI()
        pictureView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(statusCellMarginEight)
            make.left.equalTo(contentLabel)
            make.width.equalTo(contentLabel.snp_width)
            make.height.equalTo(290)
        }
    }

}

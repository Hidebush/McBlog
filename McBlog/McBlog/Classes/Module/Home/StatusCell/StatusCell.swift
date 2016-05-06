//
//  StatusCell.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SnapKit

let statusCellMarginEight: CGFloat = 8
private let statusCellMarginTen = 10
private let topViewHeight = 43
private let bottomViewHeight = 44
class StatusCell: UITableViewCell {

    var status: Status? {
        didSet {
            topView.status = status
            contentLabel.text = status?.text
            pictureView.status = status
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    func rowHeight(status: Status) -> CGFloat {
        self.status = status
        layoutIfNeeded()
        let height = CGRectGetMaxY(bottomView.frame)
        return height
    }
    
    func setUpUI() {
        let sepView = UIView()
        sepView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        contentView.addSubview(sepView)
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        sepView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(statusCellMarginTen)
        }
        
        topView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(sepView.snp_bottom).offset(statusCellMarginTen)
            make.height.equalTo(topViewHeight)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom).offset(statusCellMarginEight)
            make.left.equalTo(topView.snp_left).offset(statusCellMarginEight)
            make.right.equalTo(topView.snp_right).offset(-statusCellMarginEight)
        }
        
//        pictureView.snp_makeConstraints { (make) in
//            make.top.equalTo(contentLabel.snp_bottom).offset(statusCellMarginEight)
//            make.left.equalTo(contentLabel)
//            make.width.equalTo(contentLabel.snp_width)
//            make.height.equalTo(290)
//        }
        
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(pictureView.snp_bottom).offset(statusCellMarginEight)
            make.left.right.equalTo(contentView)
            make.height.equalTo(bottomViewHeight)
        }
        
    }
    
    
    private lazy var topView: StatusTopView = StatusTopView()
    lazy var contentLabel: UILabel = {
       let contentLabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 2.0 * CGFloat(statusCellMarginEight)
        return contentLabel
    }()
    lazy var pictureView: StatusPictureView = StatusPictureView()
    lazy var bottomView: StatusBottomView = StatusBottomView()
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




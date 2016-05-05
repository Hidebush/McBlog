//
//  StatusTopView.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

private let topViewMarginEight = 8
private let topViewMarginTW = 12
private let iconViewWH = 35
class StatusTopView: UIView {
    var status: Status? {
        didSet {
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            nameLabel.text = status?.user?.name ?? ""
            vipIconView.image = status?.user?.vipImage
            memberIconView.image = status?.user?.memberImage
            timeLabel.text = "刚刚"
            sourceLabel.text = "来自星星的你"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(memberIconView)
        addSubview(vipIconView)
        
        iconView.snp_makeConstraints { (make) in
            make.top.left.equalTo(self).offset(topViewMarginEight)
            make.width.height.equalTo(iconViewWH)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_top)
            make.left.equalTo(iconView.snp_right).offset(topViewMarginTW)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(topViewMarginTW)
            make.bottom.equalTo(iconView.snp_bottom)
        }
        
        sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp_right).offset(topViewMarginTW)
            make.bottom.equalTo(timeLabel.snp_bottom)
        }
        
        memberIconView.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_top)
            make.left.equalTo(nameLabel.snp_right).offset(topViewMarginTW)
        }
        
        vipIconView.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp_bottom).offset(topViewMarginEight)
            make.left.equalTo(iconView.snp_right).offset(-topViewMarginEight)
        }
    }
    
    
    private lazy var iconView: UIImageView = UIImageView()
    private lazy var nameLabel: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
    private lazy var timeLabel: UILabel = UILabel(color: UIColor.orangeColor(), fontSize: 9)
    private lazy var sourceLabel: UILabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 9)
    private lazy var memberIconView: UIImageView = UIImageView()
    private lazy var vipIconView: UIImageView = UIImageView()
    
}

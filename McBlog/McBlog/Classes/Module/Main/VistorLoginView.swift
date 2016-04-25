//
//  VistorLoginView.swift
//  McBlog
//
//  Created by admin on 16/4/15.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

protocol VistorLoginViewDelegate: NSObjectProtocol {
    func visitorLoginViewWillLogin()
    func visitorLoginViewWillRegister()
}

class VistorLoginView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var delegate: VistorLoginViewDelegate?
    
    /**
     注册
     */
    func loginBtnClick() {
        delegate?.visitorLoginViewWillLogin()
    }
    
    /**
     登陆
     */
    func registerBtnClick() {
        delegate?.visitorLoginViewWillRegister()
    }
    
    
    func setUpVisitView(isHome: Bool, imageName:String, message:String) {
        iconView.image = UIImage(named: imageName)
        bottomL.text = message
        homeIconView.hidden = !isHome
        
        isHome ? startAnimation() : sendSubviewToBack(maskIconView)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //不允许xib 或者 storyboard 创建
//        fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1.0)
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(homeIconView)
        addSubview(bottomL)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        homeIconView.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: homeIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeIconView, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))

        bottomL.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: bottomL, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: bottomL, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: bottomL, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: bottomL, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: bottomL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: bottomL, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: bottomL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        
        maskIconView.translatesAutoresizingMaskIntoConstraints = false
        //        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        //        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView": maskIconView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subView]-(-65)-[regBtn]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView": maskIconView,"regBtn": registerBtn]))
        
        
    }
    
    
    private func startAnimation() {
        let anim = CABasicAnimation()
        anim.keyPath = "transform.rotation"
        anim.toValue = 2 * M_PI
        anim.duration = 20.0
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    /**
     *  LAZY
     */

    private lazy var iconView: UIImageView = {
        let iv: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    
    private lazy var maskIconView: UIImageView = {
        let mv : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return mv
    }()
    
    private lazy var homeIconView: UIImageView = {
        let hiV: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return hiV
    }()
    
    private lazy var bottomL: UILabel = {
        let lb = UILabel()
        lb.text = "关注一些人，回这里看看有什么惊喜"
        lb.numberOfLines = 0
        lb.textAlignment = NSTextAlignment.Center
        lb.textColor = UIColor.darkGrayColor()
        lb.font = UIFont.systemFontOfSize(14)
        lb.sizeToFit()
        return lb
    }()
    
    private lazy var loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("登录", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
}

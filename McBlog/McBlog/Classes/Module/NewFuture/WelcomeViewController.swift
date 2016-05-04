//
//  WelcomeViewController.swift
//  McBlog
//
//  Created by admin on 16/4/29.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class WelcomeViewController: UIViewController {

    private var iconViewBottomCons: Constraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        iconViewAnimation()
    }
    
    private func prepareUI() {
        view.addSubview(backImageView)
        view.addSubview(iconView)
        view.addSubview(messageLb)
        
        backImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        iconView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.width.height.equalTo(90)
            self.iconViewBottomCons = make.bottom.equalTo(view).offset(-160).constraint
//            make.bottom.equalTo(view).offset(-160)
        }
        messageLb.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(16)
            make.centerX.equalTo(iconView.snp_centerX)
        }
        
        if let url = UserAccount.loadAccount()?.avatar_large {
            iconView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "avatar_default_big"), options: SDWebImageOptions.RetryFailed)
        }
    }
    
    private func iconViewAnimation() {
        
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
            self.iconViewBottomCons?.updateOffset(160 - UIScreen.mainScreen().bounds.size.height)
            self.view.layoutIfNeeded()
            }) { (_) in
                NSNotificationCenter.defaultCenter().postNotificationName(YHRootViewControllerSwitchNotification, object: true)
        }

    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var messageLb: UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        return label
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

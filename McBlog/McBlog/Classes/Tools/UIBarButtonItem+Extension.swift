//
//  UIBarButtonItem+Extension.swift
//  McBlog
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, target: AnyObject?, action: String?) {
        let button = UIButton(type: UIButtonType.Custom)
        
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        if let actionName = action {
            button.addTarget(target, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        }
        self.init(customView: button)

    }
    
}

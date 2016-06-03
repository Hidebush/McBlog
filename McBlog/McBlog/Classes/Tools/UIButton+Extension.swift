//
//  UIButton+Extension.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(title: String, imageName: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGrayColor()) {
        self.init()
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        
    }
    
    convenience init(imageNamed: String) {
        self.init()
        setUpImage(imageNamed)
    }
    
    func setUpImage(imageNamed: String) {
        setImage(UIImage(named: imageNamed), forState: UIControlState.Normal)
        setImage(UIImage(named: imageNamed + "_highlighted"), forState: UIControlState.Highlighted)
    }
    
    
    
}
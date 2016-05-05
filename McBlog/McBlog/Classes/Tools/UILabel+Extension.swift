//
//  UILabel+Extension.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(color: UIColor, fontSize: CGFloat) {
        self.init()
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
    }
}
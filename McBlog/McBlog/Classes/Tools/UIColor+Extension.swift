//
//  UIColor+Extension.swift
//  McBlog
//
//  Created by admin on 16/6/3.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1.0)
    }
    
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256))/255.0
    }
    
}

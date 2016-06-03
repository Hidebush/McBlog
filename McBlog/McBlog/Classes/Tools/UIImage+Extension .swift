//
//  UIImage+Extension .swift
//  YHImagePicker
//
//  Created by admin on 16/6/2.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleImage(width: CGFloat) -> UIImage {
        if size.width < width {
            return self
        } else {
            let height = size.height * width / size.width
            let newSize = CGSizeMake(width, height)
            
            UIGraphicsBeginImageContext(newSize)
            drawInRect(CGRect(origin: CGPointZero, size: newSize))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
    }
}

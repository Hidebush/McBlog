//
//  UITextView+Emoticon.swift
//  Emoticon
//
//  Created by admin on 16/5/19.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

extension UITextView {
    
    func insertEmoticon(emoticon: Emoticon) {
        if emoticon.emoji != nil {
            replaceRange(selectedTextRange!, withText: emoticon.emoji!)
            return
        }
        
        if emoticon.chs != nil {
            let attachment = EmoticonAttachment()
            attachment.chs = emoticon.chs!
            attachment.image = UIImage(contentsOfFile: emoticon.imagePath)
            let w = font?.lineHeight
            attachment.bounds = CGRectMake(0, -4, w!, w!)
            let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            imageText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, 1))
            let textViewAttText = NSMutableAttributedString(attributedString: attributedText)
            textViewAttText.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
            let range = selectedRange
            attributedText = textViewAttText
            selectedRange = NSMakeRange(range.location + 1, 0)
        }
        
        
    }
    
    
    var emoticonStr: String {
        let attString = attributedText
        var strM = String()
        
        attString.enumerateAttributesInRange(NSMakeRange(0, attString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                strM += attachment.chs!
            } else {
                let str = (attString.string as NSString).substringWithRange(range)
                strM += str
            }
        }
        return strM
    }
}

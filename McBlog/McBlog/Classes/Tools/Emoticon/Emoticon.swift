//
//  Emoticon.swift
//  Emoticon
//
//  Created by admin on 16/5/11.
//  Copyright © 2016年 Theshy. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var id: String //目录名
    var groupName: String? // 分组名
    var emoticons: [Emoticon]? // 表情数组
    
    init(id: String, groupName: String = "") {
        self.id = id
        self.groupName = groupName
    }
    
    class func packages() -> [EmoticonPackage] {
        
        let path = (bundlePath as NSString).stringByAppendingPathComponent("emoticons.plist")
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String: AnyObject]]
        var arrayM = [EmoticonPackage]()
        let package = EmoticonPackage(id: "", groupName: "最近").appendEmptyEmoction()
        arrayM.append(package)
        for d in array {
            let package = EmoticonPackage(id: (d["id"] as! String)).loadEmoticons().appendEmptyEmoction()
            arrayM.append(package)
        }
        
        return arrayM
    }
    
    func loadEmoticons() -> Self {
        let path = ((EmoticonPackage.bundlePath as NSString).stringByAppendingPathComponent(id) as NSString).stringByAppendingPathComponent("info.plist")
        let dict = NSDictionary(contentsOfFile: path)!
        groupName = dict["group_name_cn"] as? String
        
        let array = dict["emoticons"] as! [[String: String]]
        emoticons = [Emoticon]()
        var index = 0
        for d in array {
            emoticons?.append(Emoticon(id: id, dict: d))
            index += 1
            if index == 20 {
                emoticons?.append(Emoticon(remove: true))
                index = 0
            }
        }
        
        return self
    }
    
    func appendEmptyEmoction() -> Self {
        if emoticons == nil {
            emoticons = [Emoticon]()
        }
        
        let count = emoticons!.count % 21
        if count > 0 || emoticons?.count == 0 {
            for _ in count..<20 {
                emoticons?.append(Emoticon(remove: false))
            }
            emoticons?.append(Emoticon(remove: true))
        }

        return self
    }
    
    static let bundlePath = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    
    override var description: String {
        return "\(id) \(groupName) \(emoticons)"
    }
    
}

class Emoticon: NSObject {
    
    var id: String?
    var chs: String?
    var png: String?
    
    var imagePath: String {
        if chs == nil {
            return ""
        }
        return ((EmoticonPackage.bundlePath as NSString).stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
        
    }
    
    var code: String? {
        didSet {
            let scanner = NSScanner(string: code!)
            
            var value: UInt32 = 0
            scanner.scanHexInt(&value)
            emoji = String(Character(UnicodeScalar(value)))
        }
    }
    var emoji: String?
    
    //删除表情
    var emoticonRemove: Bool?
    init(remove: Bool) {
        emoticonRemove = remove
    }
    
    init(id: String, dict: [String: String]) {
        self.id = id
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    override var description: String {
        return "\(chs) \(png) \(code)"
    }
}

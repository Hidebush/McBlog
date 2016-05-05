//
//  Status.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class Status: NSObject {
    ///微博创建时间
    var created_at: String?
    /// 微博id
    var id: Int = 0
    /// 微博内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            if pic_urls!.count == 0 {
                return
            }
            picURLs = [NSURL]()
            
            for dict in pic_urls! {
                if let urlString = dict["thumbnail_pic"] as? String {
                    picURLs?.append(NSURL(string: urlString)!)
                }
            }
            
        }
    }
    /// 配图URLS
    var picURLs: [NSURL]?
    /// 微博用户
    var user: User?
    
    class func loadStatus(finished: (datalist: [Status]?, error: NSError?) -> ()){
        NetWorkTools.shareTools.loadStatus { (result, error) in
            if error != nil {
                finished(datalist: nil, error: error)
                return
            }
            
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                var list = [Status]()
                for dict in array {
                    list.append(Status(dict: dict))
                }
                finished(datalist: list, error: nil)
            }
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            if let dict = value as? [String: AnyObject] {
                user = User(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        return "\(dictionaryWithValuesForKeys(keys))"
    }
    
}

//
//  Status.swift
//  McBlog
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SDWebImage

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
            storePicURLs = [NSURL]()
            
            for dict in pic_urls! {
                if let urlString = dict["thumbnail_pic"] as? String {
                    storePicURLs?.append(NSURL(string: urlString)!)
                }
            }
            
        }
    }
    /// 存储配图数组
    var storePicURLs: [NSURL]?
    /// 配图URLS
    var picURLs: [NSURL]? {
        return retweeted_status == nil ? storePicURLs : retweeted_status?.storePicURLs
    }
    /// 微博用户
    var user: User?
    /// cell行高
    var rowHeight: CGFloat?
    /// 转发微博
    var retweeted_status: Status?
    
    class func loadStatus(since_id: Int, max_id: Int, finished: (datalist: [Status]?, error: NSError?) -> ()){
        NetWorkTools.shareTools.loadStatus(since_id, max_id: max_id) { (result, error) in
            if error != nil {
                finished(datalist: nil, error: error)
                return
            }
            
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                var list = [Status]()
                for dict in array {
                    list.append(Status(dict: dict))
                }
                
                self.cacheWebImage(list, finished: finished)
            } else {
                finished(datalist: nil, error: error)
            }
        }
    }
    
    /// 缓存图片
    private class func cacheWebImage(list: [Status], finished: (datalist: [Status]?, error: NSError?) -> ()) {
        
        let group = dispatch_group_create()
        var dataLength = 0
        for status in list {
            guard let urls = status.picURLs else {
                continue
            }
            
            for url in urls {
                dispatch_group_enter(group)
                SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: SDWebImageDownloaderOptions(rawValue: 0), progress: nil, completed: { (image, _, _, _) in
                    if image != nil {
                        let data = UIImagePNGRepresentation(image)!
                        dataLength += data.length
                        print(image)
                    }
                    dispatch_group_leave(group)
                })
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            print(" \(dataLength / 1000)k")
            finished(datalist: list, error: nil)
        })
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
        
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                retweeted_status = Status(dict: dict)
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

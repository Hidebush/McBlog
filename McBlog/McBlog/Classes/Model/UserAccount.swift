//
//  UserAccount.swift
//  McBlog
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    var access_token: String?
    //过期时间
    var expireDate: NSDate?
    var expires_in: NSTimeInterval = 0 {
        didSet {
            expireDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    var uid: String?
    // 用户头像
    var avatar_large: String?
    // 显示名字
    var name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
//        expireDate = NSDate(timeIntervalSinceNow: expires_in!)
    }
    
    // MARK: - 归档&解裆
    
    static private let accountPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.plist")
    
    // MARK - 保存
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
        
    }
    
    
    // MARK - 读取
    private static var userAccount: UserAccount? //私有变量记录
    class func loadAccount() -> UserAccount? {
        
//        if userAccount == nil {
//            if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount {
//                // 判断账户是否过期
//                if account.expireDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
//                    return account
//                }
//                
//            }
//        } else {
//            if userAccount!.expireDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
//                return userAccount
//            }
//        }
        
        
        if userAccount == nil {
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount
        }
        
        if let date = userAccount?.expireDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            userAccount = nil
        }

        return userAccount
    }
    
    func loadUserInfo(finished: (error: NSError?) -> ()) {
        NetWorkTools.shareTools.loadUserInfo(uid!) { (result, error) in
            if error != nil {
                finished(error: error)
                return
            }
            
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            self.saveAccount()
            
            finished(error: nil)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expireDate, forKey: "expireDate")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expireDate = aDecoder.decodeObjectForKey("expireDate") as? NSDate
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        
        let perporties = ["access_token", "expires_in", "expireDate", "uid", "name", "avatar_large"]
        return "\(dictionaryWithValuesForKeys(perporties))"
    }
    
}

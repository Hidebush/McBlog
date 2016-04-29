//
//  NetWorkTools.swift
//  McBlog
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import AFNetworking
//App Key：1849210861
//App Secret：b3b1408d1ade4ca68af191693a3df127

public enum YHNetWorkRequstMethod : Int {
    
    case GET
    case POST
    case HEAD
    case PUT
    case DELETE
}

private let YHErrorDominName = "com.yuehuig.error.network"

class NetWorkTools: AFHTTPSessionManager {
    
    private let clientId = "1849210861"
    private let appSecret = "b3b1408d1ade4ca68af191693a3df127"
    let redirectUrl = "http://www.baidu.com"
    
    typealias YHNetWorkFinishedCallBack = (result: [String: AnyObject]?, error: NSError?)->()
    
    static let shareTools: NetWorkTools = {
        let baseUrl = NSURL(string: "https://api.weibo.com/")!
        let tools = NetWorkTools(baseURL: baseUrl)
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/json","text/javascript","text/plain","") as? Set<String>
 
        return tools
    }()
    

    
    //返回OAuth授权
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUrl)"
        return NSURL(string: urlString)!
    }
    
    func loadAccessToken(code: String, finished: YHNetWorkFinishedCallBack) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": clientId,
                      "client_secret": appSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": redirectUrl
                      ]

//        POST(urlString, parameters: params, progress: nil, success: { (_, data) in
//            finished(result: data as? [String: AnyObject], error: nil)
//            }) { (_, error) in
//                finished(result: nil, error: error)
//        }
        requestNetWork(.POST, urlString: urlString, params: params) { (result, error) in
            finished(result: result, error: error)
        }
        
    }
    
    func loadUserInfo(uid: String, finished: YHNetWorkFinishedCallBack) {
        let urlString = "2/users/show.json"
        if UserAccount.loadAccount()?.access_token == nil {
            return
        }
        
        let params = ["access_token": UserAccount.loadAccount()!.access_token!, "uid": uid] as [String: AnyObject]
        
        requestNetWork(.GET, urlString: urlString, params: params, finished: finished)
        
    }
    
    
    
    
    
    
    private func requestNetWork(requestMethod: YHNetWorkRequstMethod, urlString: String, params: [String: AnyObject]?, finished:YHNetWorkFinishedCallBack) {
        switch requestMethod {
        case .GET:
            GET(urlString, parameters: params, progress: nil, success: { (_, data) in
                if let jsonData = data as? [String: AnyObject] {
                    finished(result: jsonData, error: nil)
                } else {
                    let error = NSError(domain: YHErrorDominName, code: -1, userInfo: ["errorMessage": "空数据"])
                    print("空数据 --  \(requestMethod) --  \(urlString) --  \(error)")
                    finished(result: nil, error: error)
                }
                
                }, failure: { (_, error) in
                    print(error)
                    finished(result: nil, error: error)
            })
            
        case .POST:
            POST(urlString, parameters: params, progress: nil, success: { (_, data) in
                if let jsonData = data as? [String: AnyObject] {
                    finished(result: jsonData, error: nil)
                } else {
                    let error = NSError(domain: YHErrorDominName, code: -1, userInfo: ["errorMessage": "空数据"])
                    print("空数据 --  \(requestMethod) --  \(urlString) --  \(error)")
                    finished(result: nil, error: error)
                }
                
                }, failure: { (_, error) in
                    print(error)
                    finished(result: nil, error: error)
            })
            
        case .HEAD:
            HEAD(urlString, parameters: params, success: { (_) in
                
                }, failure: { (_, error) in
                    print(error)
                    finished(result: nil, error: error)
            })
            
        case .PUT:
            PUT(urlString, parameters: params, success: { (_, data) in
                if let jsonData = data as? [String: AnyObject] {
                    finished(result: jsonData, error: nil)
                } else {
                    let error = NSError(domain: YHErrorDominName, code: -1, userInfo: ["errorMessage": "空数据"])
                    print("空数据 --  \(requestMethod) --  \(urlString) --  \(error)")
                    finished(result: nil, error: error)
                }
                
                }, failure: { (_, error) in
                    print(error)
                    finished(result: nil, error: error)
            })
            
        case .DELETE:
            DELETE(urlString, parameters: params, success: { (_, data) in
                if let jsonData = data as? [String: AnyObject] {
                    finished(result: jsonData, error: nil)
                } else {
                    let error = NSError(domain: YHErrorDominName, code: -1, userInfo: ["errorMessage": "空数据"])
                    print("空数据 --  \(requestMethod) --  \(urlString) --  \(error)")
                    finished(result: nil, error: error)
                }
                
                }, failure: { (_, error) in
                    print(error)
                    finished(result: nil, error: error)
            })

        }
    }
    
}

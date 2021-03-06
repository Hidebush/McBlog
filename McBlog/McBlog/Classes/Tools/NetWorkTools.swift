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

private enum YHNetWorkError: Int {
    
    case emptyDataError  = -1
    case emptyTokenError = -2
    
    private var errorDescrption: String {
        switch self {
        case .emptyDataError:
            return "空数据"
        case .emptyTokenError:
            return "Token为nil"
        }
    }
    
    private func error() -> NSError {
        
        let error = NSError(domain: YHErrorDominName, code: rawValue, userInfo: [YHErrorDominName: errorDescrption])
        return error
    }
    
}

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
    
    /*
     检查Token
     */
    private func tokenDict(finished: YHNetWorkFinishedCallBack) -> [String: AnyObject]? {
        if UserAccount.loadAccount()?.access_token == nil {
            let error = YHNetWorkError.emptyTokenError.error()
            print(error)
            finished(result: nil, error: error)
        }
        
        return ["access_token": UserAccount.loadAccount()!.access_token!]
    }
    
    //加载微博数据
    func loadStatus(since_id: Int, max_id: Int, finished: YHNetWorkFinishedCallBack) {
        
        guard var params = tokenDict(finished) else {
            return
        }
        if since_id > 0 {
            params["since_id"] = since_id
        }
        if max_id > 0 {
            params["max_id"] = max_id
        }
        
        let urlString = "2/statuses/home_timeline.json"
        requestNetWork(.GET, urlString: urlString, params: params, finished: finished)
    }
    
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
    
    func sendStatus(status: String, image: UIImage?, finished: YHNetWorkFinishedCallBack) {
        guard var params = tokenDict(finished) else {
            return
        }
        params["status"] = status
        
        if image == nil {
            requestNetWork(.POST, urlString: "2/statuses/update.json", params: params) { (result, error) in
                finished(result: result, error: error)
            }
        } else {
            uploadImage("https://upload.api.weibo.com/2/statuses/upload.json", image: image!, params: params, finished: finished)
        }
        
    }
    
    func loadUserInfo(uid: String, finished: YHNetWorkFinishedCallBack) {
        
        guard var params = tokenDict(finished) else {
            return
        }
        let urlString = "2/users/show.json"
        params["uid"] = uid
        requestNetWork(.GET, urlString: urlString, params: params, finished: finished)
        
    }
    
    /**
     上传图像发表微博
     
     - parameter urlString: 上传接口
     - parameter image:     图片
     - parameter params:    参数
     - parameter finished:  回调
     */
    
    private func uploadImage(urlString: String, image: UIImage, params: [String: AnyObject], finished: YHNetWorkFinishedCallBack) {
        
        let successCallBack: (NSURLSessionDataTask!, AnyObject?) -> Void = {(_, data) in
            
            if let jsonData = data as? [String: AnyObject] {
                finished(result: jsonData, error: nil)
            } else {
                
                let error = YHNetWorkError.emptyDataError.error()
                print(error)
                finished(result: nil, error: error)
            }
            
        }
        
        
        let failureCallBack: (NSURLSessionDataTask?, NSError) -> Void = {(_, error) in
            print(error)
            finished(result: nil, error: error)
        }
        
        POST(urlString, parameters: params, constructingBodyWithBlock: { (formData) in
            
            let imageData = UIImagePNGRepresentation(image)
            formData.appendPartWithFileData(imageData!, name: "pic", fileName: "statusImage", mimeType: "application/octet-stream")
            
            }, progress: nil, success: successCallBack, failure: failureCallBack)
    }
    
    private func requestNetWork(requestMethod: YHNetWorkRequstMethod, urlString: String, params: [String: AnyObject]?, finished:YHNetWorkFinishedCallBack) {

        let successCallBack: (NSURLSessionDataTask!, AnyObject?) -> Void = {(_, data) in
            
            if let jsonData = data as? [String: AnyObject] {
                finished(result: jsonData, error: nil)
            } else {

                let error = YHNetWorkError.emptyDataError.error()
                print(error)
                finished(result: nil, error: error)
            }
            
        }
        
        
        let failureCallBack: (NSURLSessionDataTask?, NSError) -> Void = {(_, error) in
            print(error)
            finished(result: nil, error: error)
        }
        
        
        switch requestMethod {
        case .GET:
            GET(urlString, parameters: params, progress: nil, success: successCallBack, failure: failureCallBack)
            
        case .POST:
            POST(urlString, parameters: params, progress: nil, success: successCallBack, failure: failureCallBack)
            
        case .HEAD:
            HEAD(urlString, parameters: params, success: { (_) in
                
                }, failure: failureCallBack)
            
        case .PUT:
            PUT(urlString, parameters: params, success: successCallBack, failure: failureCallBack)
            
        case .DELETE:
            DELETE(urlString, parameters: params, success: successCallBack, failure: failureCallBack)

        }
    }
    
}

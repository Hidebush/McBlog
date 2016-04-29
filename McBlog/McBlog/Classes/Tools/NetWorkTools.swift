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

class NetWorkTools: AFHTTPSessionManager {
    static let shareTools: NetWorkTools = {
        let baseUrl = NSURL(string: "https://api.weibo.com/")!
        let tools = NetWorkTools(baseURL: baseUrl)
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/json","text/javascript","text/plain","") as? Set<String>
 
        return tools
    }()
    
    
    private let clientId = "1849210861"
    private let appSecret = "b3b1408d1ade4ca68af191693a3df127"
    let redirectUrl = "http://www.baidu.com"
    
    //返回OAuth授权
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUrl)"
        return NSURL(string: urlString)!
    }
    
    func loadAccessToken(code: String, finished: (result: [String: AnyObject]?, error: NSError?)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": clientId,
                      "client_secret": appSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": redirectUrl
                      ]

        POST(urlString, parameters: params, progress: nil, success: { (_, data) in
            finished(result: data as? [String: AnyObject], error: nil)
            }) { (_, error) in
                finished(result: nil, error: error)
        }
    }
    
}

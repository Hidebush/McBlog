//
//  OAuthViewController.swift
//  McBlog
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController, UIWebViewDelegate{

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNav()
        
        view.backgroundColor = UIColor.whiteColor()
        let request = NSURLRequest(URL: NetWorkTools.shareTools.oauthUrl(), cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 15)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    private func setUpNav() {
        title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeAction))
    }
    
    @objc private func closeAction() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UIWebviewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.URL!.absoluteString
        if !urlString.hasPrefix(NetWorkTools.shareTools.redirectUrl) {
            return true
        }
        
        if let query = request.URL?.query where query.hasPrefix("code=") {
            let code = (query as NSString).substringFromIndex("code=".length)
            print(request)
            print(code)
            
            // TODO: 换区Token
            loadAccessToken(code)
            
            
        } else {
            closeAction()
        }
        return false
    }
    
    private func loadAccessToken(code: String) {
        NetWorkTools.shareTools.loadAccessToken(code) { (result, error) in
            if error != nil {
                print(error)
                self.closeVC("网络不好哦~")
                
                return
            } else {
                SVProgressHUD.dismiss()
                print(result)
                if result != nil {
                    UserAccount(dict: result!).loadUserInfo({ (error) in
                        if error != nil {
                            print(error)
                            self.closeVC("加载用户信息失败~")
                        }
                    })
                }
                
            }
        }
    }
    
    
    private func closeVC(message: String) {
        SVProgressHUD.showErrorWithStatus(message)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(when, dispatch_get_main_queue()) {
            self.closeAction()
        }
    }
    
    deinit {
        print("销毁")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

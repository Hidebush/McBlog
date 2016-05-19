//
//  ComposeViewController.swift
//  McBlog
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SnapKit

class ComposeViewController: UIViewController {

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        setUpNav()
        prepareToolBar()
        prepareTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    

    @objc private func sendAction() {
        print("发送微博")
        textView.resignFirstResponder()
    }
    
    @objc private func closeAction() {
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func inputEmoticon() {
        removeKeyboardObserver()
        
        textView.resignFirstResponder()
        textView.inputView = (textView.inputView == nil) ? emoticonVc.view : nil
        
        addKeyboardObserver()
        textView.becomeFirstResponder()
    }
    
    private func removeKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func addKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardChange), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardChange(notification: NSNotification) {
        print(notification)
        let rect: CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        self.toolBarBottom?.updateOffset(rect.origin.y - kScreenHeight)
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func prepareTextView() {
        view.addSubview(textView)
        textView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(toolBar.snp_top)
        }
    }
    
    private var toolBarBottom: Constraint? = nil
    private func prepareToolBar() {
        view.addSubview(toolBar)
        toolBar.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(44)
            toolBarBottom = make.bottom.equalTo(view).constraint
        }
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        var items = [UIBarButtonItem]()
        for dict in itemSettings {
            let barButtonItem = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action:dict["action"])
            items.append(barButtonItem)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
    private func setUpNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendAction))
        navigationItem.rightBarButtonItem?.enabled = false
        
        let titleView = UIView(frame: CGRectMake(0, 0, 200, 35))
        let nameLb = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        nameLb.textAlignment = NSTextAlignment.Center
        let subTitleLb = UILabel(color: UIColor.lightGrayColor(), fontSize: 13)
        subTitleLb.textAlignment = NSTextAlignment.Center
        titleView.addSubview(nameLb)
        titleView.addSubview(subTitleLb)
        nameLb.text = UserAccount.loadAccount()?.name ?? ""
        subTitleLb.text = "发微博"
        nameLb.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(titleView)
        }
        subTitleLb.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(titleView)
            make.height.equalTo(nameLb.snp_height)
            make.top.equalTo(nameLb.snp_bottom)
        }
        navigationItem.titleView = titleView
        
    }
    
    private lazy var emoticonVc: EmoticonViewController = EmoticonViewController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon)
        
    }
    
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFontOfSize(17)
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        let placeHolderLb: UILabel = UILabel()
        placeHolderLb.text = "分享新鲜事儿..."
        placeHolderLb.textColor = UIColor.lightGrayColor()
        placeHolderLb.font = UIFont.systemFontOfSize(17)
        textView.addSubview(placeHolderLb)
        placeHolderLb.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(5)
            make.top.equalTo(8)
        })
        
        return textView
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return toolBar
    }()

    
    deinit {
        removeKeyboardObserver()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

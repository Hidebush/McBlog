//
//  ComposeViewController.swift
//  McBlog
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


private let kStatusTextMaxLength = 10
class ComposeViewController: UIViewController, UITextViewDelegate {
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        addChildViewController(pictureSelectorVC)
        addSubViews()
        setUpNav()
        prepareToolBar()
        prepareTextView()
        preparePhotoView()
    }
    
    private func addSubViews() {
        view.addSubview(textView)
        view.addSubview(pictureSelectorVC.view)
        view.addSubview(lengthTipLabel) // 添加在textView不显示  视图还没调整好
        view.addSubview(toolBar)
    }
    
    private func preparePhotoView() {
        
        pictureSelectorVC.view.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kScreenHeight * 0.6)
        }
        
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
        
        let image = pictureSelectorVC.photos.last
        NetWorkTools.shareTools.sendStatus(textView.emoticonStr, image: image) { (result, error) in
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
            if error != nil {
                print(error)
                SVProgressHUD.showWithStatus("发送失败")
            } else {
                SVProgressHUD.showSuccessWithStatus("发送成功")
            }
            self.closeAction()
        }
    }
    
    @objc private func closeAction() {
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func inputEmoticon() {
        /// 第一种 方法  先移除键盘通知  替换后 再监听
//        removeKeyboardObserver()
//        
//        textView.resignFirstResponder()
//        textView.inputView = (textView.inputView == nil) ? emoticonVc.view : nil
//        
//        addKeyboardObserver()
//        textView.becomeFirstResponder()
        
        /// 第二种方法  通知中设置 动画
        
        textView.resignFirstResponder()
        textView.inputView = (textView.inputView == nil) ? emoticonVc.view : nil
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
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue
        self.toolBarBottom?.updateOffset(rect.origin.y - kScreenHeight)
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func prepareTextView() {
        lengthTipLabel.sizeToFit()
        lengthTipLabel.backgroundColor = UIColor.cyanColor()
        placeHolderLb.text = "分享新鲜事儿..."
        textView.addSubview(placeHolderLb)
        placeHolderLb.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(5)
            make.top.equalTo(8)
        })
        textView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(toolBar.snp_top)
        }
        lengthTipLabel.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(textView).offset(-8)
        }
        
    }
    
    private var toolBarBottom: Constraint? = nil
    private func prepareToolBar() {
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
    
    private lazy var pictureSelectorVC: YHImagePickerController = YHImagePickerController()
    
    private lazy var emoticonVc: EmoticonViewController = EmoticonViewController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        placeHolderLb.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        let len = kStatusTextMaxLength - textView.emoticonStr.characters.count
        lengthTipLabel.text = String(len)
        lengthTipLabel.textColor = len < 0 ? UIColor.redColor() : UIColor.lightGrayColor()
    }
    
    private lazy var placeHolderLb: UILabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 17)
    
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.delegate = self
        // 添加collectionview后 textview高度下降
//        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFontOfSize(17)
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        return textView
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return toolBar
    }()

    private lazy var lengthTipLabel: UILabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 14)
    
    deinit {
        removeKeyboardObserver()
        print("销毁了.")
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

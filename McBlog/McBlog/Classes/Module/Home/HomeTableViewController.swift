//
//  HomeTableViewController.swift
//  McBlog
//
//  Created by Theshy on 16/4/15.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

private enum StatusCellIdentifier: String {
    case NormalReuseId = "NormalReuseId"
    case ForwardReuseId = "ForwardReuseId"
    
    static func cellId(status: Status) -> String {
        return status.retweeted_status == nil ? StatusCellIdentifier.NormalReuseId.rawValue : StatusCellIdentifier.ForwardReuseId.rawValue
    }
}

class HomeTableViewController: BaseTableViewController {

    /// 微博数据数组
    private var statuses: [Status]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccount.userLogon {
            visitorView?.setUpVisitView(true, imageName: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")
            return ;
        }
        refreshControl = YHRefreshConrol()
        refreshControl?.addTarget(self, action: #selector(loadStatus), forControlEvents: UIControlEvents.ValueChanged)
        prepareTableView()
        loadStatus()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentPicture), name: YHStatusCellSelectedPictureNotification, object: nil)
        
    }
    
    @objc private func presentPicture(notification: NSNotification) {
        print(notification)
        guard let urls = notification.userInfo![YHStatusCellSelectedPictureURLKey] as? [NSURL] else {
            print("URL数组不存在")
            return
        }
        
        guard let indexPath = notification.userInfo![YHStatusCellSelectedPictureIndexKey] as? NSIndexPath else {
            print("选择index不存在")
            return
        }
        
        let pictureVC = PhotoBrowerController.init(urls: urls, index: indexPath.item)

        pictureVC.transitioningDelegate = self
        pictureVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(pictureVC, animated: true, completion: nil)
    }
    
    private func prepareTableView() {
        tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: StatusCellIdentifier.NormalReuseId.rawValue)
        tableView.registerClass(StatusForwardCell.self, forCellReuseIdentifier: StatusCellIdentifier.ForwardReuseId.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        tableView.estimatedRowHeight = 300
//        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private var pullUpRefresh = false
    @objc private func loadStatus() {
        refreshControl?.beginRefreshing()
        
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        if pullUpRefresh {
            since_id = 0
            max_id = statuses!.last!.id - 1 ?? 0
        }
        
        
        Status.loadStatus(since_id, max_id: max_id) {(datalist, error) in
            self.refreshControl?.endRefreshing()
            if error != nil {
                print(error)
                return
            }
            
            let count = datalist?.count
            print("刷新到 \(count)条新数据")
            if (since_id > 0) {
                self.showPullTipAction(Int(count!))
            }
            if count == 0 {
                return
            }
            if since_id > 0 {
                self.statuses! = datalist! + self.statuses!
            } else if (max_id > 0) {
                self.statuses! += datalist!
                self.pullUpRefresh = false
            } else {
                self.statuses = datalist
            }
            print(datalist)
        }
    }
    
    private func showPullTipAction(count: Int) {
        let originY: CGFloat = 44
        tipLabel.text = count == 0 ? "暂时没有新的微博":"刷新到 \(count)条新数据"
        UIView.animateWithDuration(1.2, animations: {
            UIView.setAnimationRepeatAutoreverses(true)
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 3 * originY)
            }) { (_) in
                self.tipLabel.transform = CGAffineTransformIdentity
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status), forIndexPath: indexPath) as! StatusCell
        
        if indexPath.row == statuses!.count - 1 {
            pullUpRefresh = true
            loadStatus()
        }
        cell.status = status
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        if let h = status.rowHeight {
            return h
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status)) as! StatusCell
        status.rowHeight = cell.rowHeight(status)
        return status.rowHeight!
    }
    
    
    private lazy var tipLabel: UILabel = {
        let originY: CGFloat = 44
        let label = UILabel(color: UIColor.whiteColor(), fontSize: 15)
        label.backgroundColor = UIColor.orangeColor()
        label.frame = CGRectMake(0, -2*originY, UIScreen.mainScreen().bounds.size.width, originY)
        label.textAlignment = NSTextAlignment.Center
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        return label
    }()

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 是否转场
    private var isPresent : Bool = false
    
}


extension HomeTableViewController: UIViewControllerTransitioningDelegate {
    
    /**
     返回提供转场动画的对象   这个对象可以是任何一个对象 只要遵守了 UIViewControllerAnimatedTransitioning 协议
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        
        return self
    }
    
    /**
     返回提供解除动画的对象
     */
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        
        return self
    }
    
}

extension HomeTableViewController: UIViewControllerAnimatedTransitioning {
    
    // 转场动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.3
    }
    
    /**
     自定义转场动画  只要实现了此方法 就需要自己写动画
     
     - parameter transitionContext: 提供了转场动画所需要的元素
     - transitionContext.completeTransition(true) 动画结束后必须调用
     
     - containerView() 容器视图
     
     - viewForKey      获取到转场的视图  ios8.0
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // MainViewController 弹出视图的控制器
//        let fromVc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        // 要展现的控制器
//        let toVc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        
        if isPresent {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            transitionContext.containerView()?.addSubview(toView)
            
            toView.alpha = 0.0
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toView.alpha = 1.0
            }) { (_) in
                
                // 此方法必须实现（API 注明）
                // 动画结束之后一定要执行，如果不执行，系统会一直等待，无法进行后续交互
                
                transitionContext.completeTransition(true)
            }

        } else {
            // 解除转场的时候 fromVc 是 present出来的控制器  反了一下
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
                fromView.alpha = 0.0
                }, completion: { (_) in
                    
                    fromView.removeFromSuperview()
                    // 解除转场 会把容器视图和内部视图 销毁
                    transitionContext.completeTransition(true)
            })

        }

    }
}


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

}

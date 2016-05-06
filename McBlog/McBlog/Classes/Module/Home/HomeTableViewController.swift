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
    
    private func loadStatus() {
        Status.loadStatus {[weak self] (datalist, error) in
            if error != nil {
                print(error)
                return
            }
            self?.statuses = datalist
            print(datalist)
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

}

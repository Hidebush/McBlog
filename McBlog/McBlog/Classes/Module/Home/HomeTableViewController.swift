//
//  HomeTableViewController.swift
//  McBlog
//
//  Created by Theshy on 16/4/15.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    let reuseId = "statusCellId"
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
        prepareTableView()
        loadStatus()
    }
    
    private func prepareTableView() {
        tableView.registerClass(StatusCell.self, forCellReuseIdentifier: reuseId)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        tableView.estimatedRowHeight = 200
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as! StatusCell
        cell.status = statuses![indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as! StatusCell
        return cell.rowHeight(statuses![indexPath.row])
    }

}

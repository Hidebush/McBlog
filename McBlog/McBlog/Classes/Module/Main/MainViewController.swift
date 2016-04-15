//
//  MainViewController.swift
//  McBlog
//
//  Created by Theshy on 16/4/15.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBar.tintColor = UIColor.orangeColor()
        addChildViewControllers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpComposeBtn()
    }
    
    private func setUpComposeBtn() {
        let w = UIScreen.mainScreen().bounds.size.width/CGFloat(childViewControllers.count)
        let rect = CGRectMake(0, 0, w, tabBar.bounds.size.height)
        composeBtn.frame = CGRectOffset(rect, 2 * w, 0)
        
    }
    
    private func addChildViewControllers() {
        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    /**
     添加子控制器
     */
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        vc.title = title;
        vc.tabBarItem.image = UIImage(named: imageName)
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
    
    func composeBtnClick() {
        print(__FUNCTION__)
    }
    
    
    lazy private var composeBtn: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button .setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button .setImage(UIImage(named: "tabbar_compose_icon_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "composeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tabBar.addSubview(button)
        
        return button
    }()

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

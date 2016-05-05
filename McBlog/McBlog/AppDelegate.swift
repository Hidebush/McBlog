//
//  AppDelegate.swift
//  McBlog
//
//  Created by Theshy on 16/4/14.
//  Copyright © 2016年 郭月辉. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(switchRootViewController), name: YHRootViewControllerSwitchNotification, object: nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        setUpAppearance()
        isNewUpdate()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func switchRootViewController(notification: NSNotification) {
        print("切换控制器")
        window?.rootViewController = (notification.object as! Bool) ? MainViewController() : WelcomeViewController()
    }
    
    private func defaultViewController() -> UIViewController {
        if !UserAccount.userLogon {
            return MainViewController()
        }
        return isNewUpdate() ? NewFeautureController() : WelcomeViewController()
    }
    
    private func isNewUpdate() -> Bool {
        
        let currentVersion = Double(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)
        let sandBoxVersion = NSUserDefaults.standardUserDefaults().doubleForKey("sandBoxVersionKey")
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion!, forKey: "sandBoxVersionKey")
        
        return currentVersion > sandBoxVersion
    }
    
    private func setUpAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
    


    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

}


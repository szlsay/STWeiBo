//
//  AppDelegate.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.setupStartUI()
        
        return true
    }
    
    func setupStartUI () {
        
        print(UserAccount.loadAccount()?.expires_Date)
        
        // 0.设置导航条和工具条的外观，因为外观一旦设置全局有效, 所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 2.创建根控制器
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
    }
}


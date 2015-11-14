//
//  DiscoverTableViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

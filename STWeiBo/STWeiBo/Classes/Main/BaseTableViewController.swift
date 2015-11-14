//
//  BaseTableViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // 定义一个变量保存用户当前是否登录
    var userLogin = false
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    /**
    创建未登录界面
    */
    private func setupVisitorView()
    {
        let customView = VisitorView()
//        customView.backgroundColor = UIColor.redColor()
        view = customView
        
    }

}

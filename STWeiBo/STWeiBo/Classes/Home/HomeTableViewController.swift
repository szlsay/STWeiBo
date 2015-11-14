//
//  HomeTableViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//
import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
        // 2.初始化导航条
        setupNav()
    }
    
    private func setupNav()
    {
        /*
        // 1.左边按钮
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
        leftBtn.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: UIControlState.Highlighted)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        // 2.右边按钮
        // command + control + e
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage(named: "navigationbar_pop"), forState: UIControlState.Normal)
        rightBtn.setImage(UIImage(named: "navigationbar_pop_highlighted"), forState: UIControlState.Highlighted)
        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        */
        /*
        navigationItem.leftBarButtonItem = creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = creatBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        */
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
    }
    
    func leftItemClick()
    {
        print(__FUNCTION__)
    }
    
    func rightItemClick()
    {
        print(__FUNCTION__)
    }
    
    /*
    private func creatBarButtonItem(imageName:String, target: AnyObject?, action:Selector) ->UIBarButtonItem
    {
    let btn = UIButton()
    btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    btn.sizeToFit()
    return UIBarButtonItem(customView: btn)
    }
    */
}

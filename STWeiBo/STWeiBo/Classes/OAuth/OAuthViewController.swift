//
//  OAuthViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/16.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    let WB_App_Key = "1946603044"
    let WB_App_Secret = "f9c43774ae9264439076483ec77deb3c"
    let WB_redirect_uri = "http://home.cnblogs.com/u/shentian"
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0.初始化导航条
        navigationItem.title = "小沈微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 1.获取未授权的RequestToken
        // 要求SSL1.2
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}


extension OAuthViewController: UIWebViewDelegate
{
    // 返回ture正常加载 , 返回false不加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        /*
        加载授权界面: https://api.weibo.com/oauth2/authorize?client_id=2624860832&redirect_uri=http://www.520it.com
        
        跳转到授权界面: https://api.weibo.com/oauth2/authorize
        
        授权成功: http://www.520it.com/?code=91e779d15aa73698cbbb72bc7452f3b3
        
        取消授权: http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        */
        print(request.URL?.absoluteString)
        
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri)
        {
            // 继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr)
        {
            // 授权成功
            print("授权成功")
            // 取出已经授权的RequestToken
            // codeStr.endIndex是拿到code=最后的位置
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            print(code)
        }else
        {
            // 取消授权
            print("取消授权")
            // 关闭界面
            close()
        }
        
        return false
    }
}

//
//  NetworkTools.swift
//  STWeiBo
//
//  Created by ST on 15/11/16.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

    static let tools:NetworkTools = {
        // 注意: baseURL一定要以/结尾
        let url = NSURL(string: "https://api.weibo.com/")
        let t = NetworkTools(baseURL: url)
        
        // 设置AFN能够接收得数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        return t
    }()
    
    /// 获取单粒的方法
    class func shareNetworkTools() -> NetworkTools {
        return tools
    }
    
    private static let instance: NetworkTools = {
        // baseURL 要以 `/` 结尾
        let urlString = "https://api.weibo.com/"
        let baseURL = NSURL(string: urlString)!
        
        let tools = NetworkTools(baseURL: baseURL)
        
        // 设置相应的默认反序列化格式
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        
        return tools
    }()
    
    /// 全局访问方法
    class func sharedNetworkTools() -> NetworkTools {
        return instance
    }

}

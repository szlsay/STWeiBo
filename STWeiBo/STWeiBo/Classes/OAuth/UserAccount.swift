//
//  UserAccount.swift
//  STWeiBo
//
//  Created by ST on 15/11/16.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

// Swift2.0 打印对象需要重写CustomStringConvertible协议中的description
class UserAccount: NSObject {
 /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
 /// access_token的生命周期，单位是秒数。
    var expires_in: NSNumber?
 /// 当前授权用户的UID。
    var uid:String?
    
    
    override init() {
        
    }
    init(dict: [String: AnyObject])
    {
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
}

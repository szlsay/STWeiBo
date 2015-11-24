//
//  UIBarButtonItem+Category.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    // 如果在func前面加上class, 就相当于OC中的+
    class func creatBarButtonItem(imageName:String, target: AnyObject?, action:Selector) ->UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }
    
    ///  创建 UIBarButtonItem
    ///
    ///  :param: imageName            图像名
    ///  :param: highlightedImageName 高亮名，可以为 nil
    ///  :param: target               target
    ///  :param: actionName           actionName
    convenience init(imageName: String, highlightedImageName: String?, target: AnyObject?, actionName: String?) {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal);
        
        let hImageName = highlightedImageName ?? imageName + "_highlighted"
        btn.setImage(UIImage(named: hImageName), forState: UIControlState.Highlighted)
        
        btn.sizeToFit()
        
        // 添加监听方法
        if actionName != nil {
            btn.addTarget(target, action: Selector(actionName!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.init(customView: btn)
    }

}
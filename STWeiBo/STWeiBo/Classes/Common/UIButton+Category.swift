//
//  UIButton+Category.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//


import UIKit

extension UIButton
{
    class func createButton(imageName: String, title: String) -> UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }
    
    convenience init(title: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGrayColor(), backColor: UIColor = UIColor.whiteColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        backgroundColor = backColor
        
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    convenience init(title: String, imageName: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGrayColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    convenience init(imageName: String) {
        self.init()
        
        setImage(imageName)
    }
    
    /// 使用图像名设置按钮图像
    func setImage(imageName: String) {
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        // 提示：如果高亮图片不存在，不会设置
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    }

}

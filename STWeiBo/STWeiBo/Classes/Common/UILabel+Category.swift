//
//  UILabel+Category.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//


import UIKit


extension UILabel{
    
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
    
    convenience init(color: UIColor, fontSize: CGFloat){
        self.init()
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
    }

}
//
//  EmoticonAttachment.swift
//  STWeiBo
//
//  Created by ST on 15/11/24.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    /// 表情文字
    var chs: String?
    
    /// 使用表情模型，生成一个`属性字符串`
    class func emoticonString(emoticon: Emoticon, font: UIFont) -> NSAttributedString {
        let attachment = EmoticonAttachment()
        // 记录表情符号的文本
        attachment.chs = emoticon.chs
        attachment.image = UIImage(named: emoticon.imagePath!)
        // 设置表情大小
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: s, height: s)
        
        // 2.根据附件创建属性文本
        let imageText = NSAttributedString(attachment: attachment)
        
        // 3.获得现在的属性文本
        let strM = NSMutableAttributedString(attributedString: imageText)
        
        // 4.设置表情图片的字体
        strM.addAttribute(NSFontAttributeName, value:font, range: NSMakeRange(0, 1))
        
        return strM
    }
}

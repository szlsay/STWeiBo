//
//  StatusForwardTableViewCell.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {

    // 重写父类属性的didSet并不会覆盖父类的操作
    // 只需要在重写方法中, 做自己想做的事即可
    // 注意点: 如果父类是didSet, 那么子类重写也只能重写didSet
    override var status: Status?
        {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = name + ": " + text
        }
    }

    
    override func setupUI() {
        super.setupUI()
        
        // 1.添加子控件
//        contentView.addSubview(forwardButton)
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        // 2.布局子控件
        
        // 2.1布局转发背景
        forwardButton.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.ST_AlignVertical(type: ST_AlignType.TopRight, referView: footerView, size: nil)
        
        // 2.2布局转发正文
        forwardLabel.text = "fjdskljflkdsjflksdjlkfdsjlfjdslfjlkds"
        forwardLabel.ST_AlignInner(type: ST_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
        
        // 2.3重新调整转发配图的位置
        let cons = pictureView.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.ST_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.ST_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.ST_Constraint(cons, attribute: NSLayoutAttribute.Top)

    }
   
    // MARK: - 懒加载
    private lazy var forwardLabel: UILabel = {
    let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
    label.numberOfLines = 0
    label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
    return label
    }()
    
    private lazy var forwardButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
}

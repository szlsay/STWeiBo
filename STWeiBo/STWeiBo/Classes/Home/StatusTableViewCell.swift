//
//  StatusTableViewCell.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import SDWebImage

let STPictureViewCellReuseIdentifier = "STPictureViewCellReuseIdentifier"

/**
 保存cell的重用标示
 
 - NormalCell:  原创微博的重用标识
 - ForwardCell: 转发微博的重用标识
 */
enum StatusTableViewCellIdentifier: String
{
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    // 如果在枚举中利用static修饰一个方法 , 相当于类中的class修饰方法
    // 如果调用枚举值的rawValue, 那么意味着拿到枚举对应的原始值
    static func cellID(status: Status) ->String
    {
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}

class StatusTableViewCell: UITableViewCell {
    
    /// 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    /// 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    /// 保存配图的顶部约束
    var pictureTopCons: NSLayoutConstraint?
    
    var status: Status?
        {
        didSet{
            
            // 设置顶部视图
            topView.status = status
            
            // 设置正文
            contentLabel.text = status?.text
            
            // 设置配图的尺寸
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            
            // 1.1根据模型计算配图的尺寸
            // 注意: 计算尺寸需要用到模型, 所以必须先传递模型
            let size = pictureView.calculateImageSize()
            // 1.2设置配图的尺寸
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化UI
        setupUI()
    }
    
    func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        
        let width = UIScreen.mainScreen().bounds.width
        // 2.布局子控件
        topView.ST_AlignInner(type: ST_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        footerView.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
    }
    
    /**
     用于获取行号
     */
    func rowHeight(status: Status) -> CGFloat
    {
        // 1.为了能够调用didSet, 计算配图的高度
        self.status = status
        
        // 2.强制更新界面
        self.layoutIfNeeded()
        
        // 3.返回底部视图最大的Y值
        return CGRectGetMaxY(footerView.frame)
    }
    
    // MARK: - 懒加载
    /// 顶部视图
    private lazy var topView: StatusTableViewTopView = StatusTableViewTopView()
    
    /// 正文
    lazy var contentLabel: UILabel =
    {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    /// 配图
    lazy var pictureView: StatusPictureView = StatusPictureView()
    
    /// 底部工具条
    lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

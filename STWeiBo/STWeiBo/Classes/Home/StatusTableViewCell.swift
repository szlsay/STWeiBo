//
//  StatusTableViewCell.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

import SDWebImage

class StatusTableViewCell: UITableViewCell {

    var status: Status?
        {
        didSet{

            nameLabel.text = status?.user?.name
            timeLabel.text = "刚刚"
            contentLabel.text = status?.text
            // 设置用户头像
            if let url = status?.user?.imageURL
            {
                iconView.sd_setImageWithURL(url)
            }
            
            // 设置认证图标
            verifiedView.image = status?.user?.verifiedImage

            // 设置会员图标
            print("mbrankImage = \(status?.user?.mbrankImage)")
            vipView.image = status?.user?.mbrankImage
            
            // 设置来源
            sourceLabel.text = status?.source
            
            // 设置时间
            timeLabel.text = status?.created_at
        }
    }
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        // 2.布局子控件
        iconView.ST_AlignInner(type: ST_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.ST_AlignInner(type: ST_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.ST_AlignHorizontal(type: ST_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.ST_AlignHorizontal(type: ST_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.ST_AlignHorizontal(type: ST_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.ST_AlignHorizontal(type: ST_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        // 添加一个底部约束
        // TODO: 这个地方是又问题的
//        contentLabel.ST_AlignInner(type: ST_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        
        let width = UIScreen.mainScreen().bounds.width
        footerView.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
        footerView.ST_AlignInner(type: ST_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }

    
    /**
     计算配图的尺寸
     */
    private func calculateImageSize() -> CGSize
    {
        // 1.取出配图个数
        let count = status?.storedPicURLS?.count
        // 2.如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSizeZero
        }
        // 3.如果只有一张配图, 返回图片的实际大小
        if count == 1
        {
            // 3.1取出缓存的图片
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            // 3.2返回缓存图片的尺寸
            return image.size
        }
        // 4.如果有4张配图, 计算田字格的大小
        let width = 90
        let margin = 10
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        /*
        2/3
        5/6
        7/8/9
        */
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        //               (8 - 1) / 3 + 1
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
        
    }
    

    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView =
    {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    /// 正文
    private lazy var contentLabel: UILabel =
    {
       let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
        }()
    
    /// 底部工具条
    private lazy var footerView: StatusFooterView = StatusFooterView()

}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        // 2.布局子控件
        ST_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    
    // 赞
    private lazy var unlikeBtn: UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")
    
    // 评论
    private lazy var commonBtn: UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

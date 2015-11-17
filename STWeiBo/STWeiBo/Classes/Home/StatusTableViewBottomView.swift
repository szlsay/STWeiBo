//
//  StatusTableViewBottomView.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class StatusTableViewBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
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

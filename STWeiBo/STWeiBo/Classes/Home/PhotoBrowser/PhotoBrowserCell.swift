//
//  PhotoBrowserCell.swift
//  STWeiBo
//
//  Created by ST on 15/11/20.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {

    var imageURL: NSURL?
        {
        didSet{
//            iconView.sd_setImageWithURL(imageURL)
            
            print("\(__FUNCTION__) \(imageURL)")
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
                /*
                1.图片显示不完整
                2.图片没有居中显示
                3.长图显示也会有一些问题
                */
//                self.iconView.frame = CGRect(origin: CGPointZero, size: image.size)
//                let size = self.displaySize(image)
//                self.iconView.frame = CGRect(origin: CGPointZero, size: size)
                self.setImageViewPostion()
                
            }
        }
    }
    
    /**
     调整图片显示的位置
     */
    private func setImageViewPostion()
    {
        // 1.拿到按照宽高比计算之后的图片大小
        let size = self.displaySize(iconView.image!)
        // 2.判断图片的高度, 是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.height
        {
            // 2.2小于 短图 --> 设置边距, 让图片居中显示
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            // 处理居中显示
            let y = (UIScreen.mainScreen().bounds.height - size.height) * 0.5
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        }else
        {
            // 2.1大于 长图 --> y = 0, 设置scrollview的滚动范围为图片的大小
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            scrollview.contentSize = size
        }
    }
    /**
     按照图片的宽高比计算图片显示的大小
     */
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.初始化UI
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconView)
        
        // 2.布局子控件
        scrollview.frame = UIScreen.mainScreen().bounds
        
    }
    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = UIScrollView()
    private lazy var iconView: UIImageView = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

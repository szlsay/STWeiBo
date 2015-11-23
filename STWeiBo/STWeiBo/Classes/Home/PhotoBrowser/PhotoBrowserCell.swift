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
                let size = self.displaySize(image)
                self.iconView.frame = CGRect(origin: CGPointZero, size: size)
            }
        }
    }
    
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
        contentView.addSubview(iconView)
        
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

//
//  PhotoBrowserCell.swift
//  STWeiBo
//
//  Created by ST on 15/11/20.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate : NSObjectProtocol
{
    func photoBrowserCellDidClose(cell: PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    weak var photoBrowserCellDelegate : PhotoBrowserCellDelegate?
    var imageURL: NSURL?
        {
        didSet{
            // 1.重置属性
            reset()
            
            // 2.显示菊花
            activity.startAnimating()
            
            // 3.设置图片
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
                // 4.隐藏菊花
                self.activity.stopAnimating()
                
                // 5.调整图片的尺寸和位置
                self.setImageViewPostion()
                
            }
        }
    }
    
    /**
     重置scrollview和imageview的属性
     */
    private func reset()
    {
        // 重置scrollview
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
        
        // 重置imageview
        iconView.transform = CGAffineTransformIdentity
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
        contentView.addSubview(activity)
        
        // 2.布局子控件
        scrollview.frame = UIScreen.mainScreen().bounds
        activity.center = contentView.center
        
        // 3.处理缩放
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        
        // 4.监听图片的点击
        let tap = UITapGestureRecognizer(target: self, action: "close")
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
        
        
    }
    
    /**
     关闭浏览器
     */
    func close()
    {
        print("close")
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }

    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = UIScrollView()
    private lazy var iconView: UIImageView = UIImageView()
     private lazy var activity: UIActivityIndicatorView =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserCell: UIScrollViewDelegate
{
    // 告诉系统需要缩放哪个控件
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return iconView
    }
    
    // 重新调整配图的位置
    // view: 被缩放的视图
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        
        // 注意: 缩放的本质是修改transfrom, 而修改transfrom不会影响到bounds, 只有frame会受到影响
        //        print(view?.bounds)
        //        print(view?.frame)
        
        var offsetX = (UIScreen.mainScreen().bounds.width - view!.frame.width) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - view!.frame.height) * 0.5
        //        print("offsetX = \(offsetX), offsetY = \(offsetY)")
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}

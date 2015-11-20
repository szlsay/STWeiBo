//
//  StatusPictureView.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import SDWebImage

class StatusPictureView: UICollectionView {
    var status: Status?
        {
        didSet{
            // 1. 刷新表格
            reloadData()
        }
    }
    
    private var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    init()
    {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        // 1.注册cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: STPictureViewCellReuseIdentifier)
        
        // 2.设置数据源
        dataSource = self
        delegate = self
        
        
        // 2.设置cell之间的间隙
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        // 3.设置配图的背景颜色
        backgroundColor = UIColor.darkGrayColor()
    }

    
    /**
    计算配图的尺寸
    */
    func calculateImageSize() -> CGSize
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
            
            pictureLayout.itemSize = image.size
            // 3.2返回缓存图片的尺寸
            return image.size
        }
        // 4.如果有4张配图, 计算田字格的大小
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private class PictureViewCell: UICollectionViewCell {
        
        // 定义属性接收外界传入的数据
        var imageURL: NSURL?
            {
            didSet{
                iconImageView.sd_setImageWithURL(imageURL!)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            // 初始化UI
            setupUI()
        }
        
        private func setupUI()
        {
            // 1.添加子控件
            contentView.addSubview(iconImageView)
            // 2.布局子控件
            iconImageView.ST_Fill(contentView)
        }
        
        // MARK: - 懒加载
        private lazy var iconImageView:UIImageView = UIImageView()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}


extension StatusPictureView: UICollectionViewDataSource , UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(STPictureViewCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        
        // 2.设置数据
        cell.imageURL = status?.storedPicURLS![indexPath.item]
        
        // 3.返回cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        print(indexPath.item)
        print(status?.storedLargePicURLS![indexPath.item])
    }


}

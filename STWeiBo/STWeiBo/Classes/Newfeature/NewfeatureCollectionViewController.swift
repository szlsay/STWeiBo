//
//  NewfeatureCollectionViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/16.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
class NewfeatureCollectionViewController: UICollectionViewController {
    
    /// 页面个数
    private let  pageCount = 4
    /// 布局对象
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()
    // 因为系统指定的初始化构造方法是带参数的(collectionViewLayout), 而不是不带参数的, 所以不用写override
    init(){
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.注册一个cell
        //      OC :  [UICollectionViewCell class]
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        // 1.设置layout布局
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        */
        
    }
    
    // MARK: - UICollectionViewDataSource
    // 1.返回一个有多少个cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    // 2.返回对应indexPath的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
        
        // 2.设置cell的数据
        //        cell.backgroundColor = UIColor.redColor()
        cell.imageIndex = indexPath.item
        
        // 3.返回cell
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 传递给我们的是上一页的索引
        //        print(indexPath)
        
        // 1.拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
        print(path)
        if path.item == (pageCount - 1)
        {
            // 2.拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            // 3.让cell执行按钮动画
            cell.startBtnAnimation()
        }
    }
}

// Swift中一个文件中是可以定义多个类的
// 如果当前类需要监听按钮的点击方法, 那么当前类不是是私有的
class NewfeatureCell: UICollectionViewCell
{
    /// 保存图片的索引
    // Swift中被private休息的东西, 如果是在同一个文件中是可以访问的
    private var imageIndex:Int? {
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    /**
     让按钮做动画
     */
    func startBtnAnimation()
    {
        startButton.hidden = false
        
        // 执行动画
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        
        // UIViewAnimationOptions(rawValue: 0) == OC knilOptions
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 清空形变
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customBtnClick()
    {
        print("-----")
    }
    
    private func setupUI(){
        // 1.添加子控件到contentView上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 2.布局子控件的位置
        iconView.ST_Fill(contentView)
        startButton.ST_AlignInner(type: ST_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    // MARK: - 懒加载
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.hidden = true
        btn.addTarget(self, action: "customBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
}

private class NewfeatureLayout: UICollectionViewFlowLayout {
    
    // 准备布局
    // 什么时候调用? 1.先调用一个有多少行cell 2.调用准备布局 3.调用返回cell
    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}

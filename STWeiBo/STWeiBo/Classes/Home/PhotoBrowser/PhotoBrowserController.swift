//
//  PhotoBrowserController.swift
//  STWeiBo
//
//  Created by ST on 15/11/20.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

private let photoBrowserCellReuseIdentifier = "pictureCell"
class PhotoBrowserController: UIViewController {

    var currentIndex: Int?
    var pictureURLs: [NSURL]?
    init(index: Int, urls: [NSURL])
    {
        // Swift语法规定, 必须先初始化本类属性, 再初始化父类
        currentIndex = index
        pictureURLs = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        // 初始化UI
        setupUI()
    }
    
    private func setupUI(){
        
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.布局子控件
        closeBtn.ST_AlignInner(type: ST_AlignType.BottomLeft, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: 10, y: -10))
        saveBtn.ST_AlignInner(type: ST_AlignType.BottomRight, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: -10, y: -10))
        collectionView.frame = UIScreen.mainScreen().bounds
        
        // 3.设置数据源
        collectionView.dataSource = self
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func save()
    {
        print(__FUNCTION__)
    }
    
    // MARK: - 懒加载
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        
        btn.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        
        btn.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
        }()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserLayout())
}

extension PhotoBrowserController : UICollectionViewDataSource,PhotoBrowserCellDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellReuseIdentifier, forIndexPath: indexPath) as! PhotoBrowserCell
        
        cell.backgroundColor = UIColor.randomColor()
        cell.imageURL = pictureURLs![indexPath.item]
        cell.photoBrowserCellDelegate = self
        
        return cell
    }
    
    func photoBrowserCellDidClose(cell: PhotoBrowserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class PhotoBrowserLayout : UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces =  false
    }
}


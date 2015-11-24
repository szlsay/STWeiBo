//
//  EmoticonViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/24.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit


class EmoticonViewController: UIViewController {
    
    /// 选中表情的回调
    var didSelectedEmoticonCallBack: (emoticon: Emoticon)->()
    
    init(didSelectedEmoticon: (emoticon: Emoticon)->()) {
        // 记录闭包
        didSelectedEmoticonCallBack = didSelectedEmoticon
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        setupUI()
        
        EmoticonPackage.packages()
    }
    
    private func setupUI()
    {
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        
        // 自动布局 - 提示：如果要做第三方框架，尽量不要使用其他框架
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
        var cons = [NSLayoutConstraint]()
        let viewDict = ["collectionView": collectionView, "toolBar": toolBar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        
        // 添加约束
        view.addConstraints(cons)
        
        // 初始化工具条
        setupToolbar()
        
        // 初始化collectionview
        setupCollectionView()
    }
    
    /**
    准备collectionView
    */
    private func setupCollectionView()
    {
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: XMGEmoticonCellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    /**
    准备toolbar
    */
    private func setupToolbar(){
        
        toolBar.tintColor = UIColor.darkGrayColor()
        
        var items = [UIBarButtonItem]()
        var index = 0
        for s in ["最近", "默认", "emoji", "浪小花"]
        {
            let item = UIBarButtonItem(title: s, style: UIBarButtonItemStyle.Plain, target: self, action: "itemClick:")
            item.tag = index++
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    func itemClick(item: UIBarButtonItem)
    {
//        print(item.tag)
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }

    // MARK - 懒加载
    private lazy var toolBar = UIToolbar()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
    /// 表情分组数据
    private lazy var packages: [EmoticonPackage] = EmoticonPackage.packages()
}
let XMGEmoticonCellReuseIdentifier = "XMGEmoticonCellReuseIdentifier"
extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return packages.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XMGEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! EmoticonCell
        
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        cell.emoticon = packages[indexPath.section].emoticons![indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 获取用户选中的 表情
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        print(packages[0].emoticons)
        
         // 判断表情符号是否有效
        if indexPath.section != 0 && emoticon.chs != nil || emoticon.emoji != nil
        {
            emoticon.times++
            // 将表情添加到 `最近的` emoticons 数组
            packages[0].addFavoriteEmoticon(emoticon)
            
        }
        didSelectedEmoticonCallBack(emoticon: emoticon)
    }

}


private class EmoticonLayout: UICollectionViewFlowLayout
{
    // 在 collectionView 的大小设置完成之后，准备布局之前会调用一次
    private override func prepareLayout() {
        super.prepareLayout()
        
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 由于CGFloat不准确, 所以不要写0.5, 可能出现只显示2两(iPhone4)
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}

class EmoticonCell: UICollectionViewCell {
    
    /// 表情模型
    var emoticon: Emoticon?
        {
        didSet{
            // 1.设置图片
            if let path = emoticon!.imagePath{
                emoticonBtn.setImage(UIImage(named: path), forState: UIControlState.Normal)
            }else
            {
                // 防止 cell 的重用
                emoticonBtn.setImage(nil, forState: UIControlState.Normal)
            }
            // 2.设置emoji - 直接过滤调用 cell 重用的问题
            emoticonBtn.setTitle(emoticon!.emoji ?? "", forState: UIControlState.Normal)
            
            // 设置删除按钮
            if emoticon!.removeButton {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = CGRectInset(bounds, 4, 4)
        emoticonBtn.backgroundColor = UIColor.whiteColor()
        // 禁止按钮交互
        emoticonBtn.userInteractionEnabled = false
    }

    // MARK: - 懒加载
    private lazy var emoticonBtn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
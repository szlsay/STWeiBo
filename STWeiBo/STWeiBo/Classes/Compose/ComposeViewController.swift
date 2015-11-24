//
//  ComposeViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/24.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import SVProgressHUD


/// 发布微博的最大长度
private let STStatusTextMaxLength = 10
class ComposeViewController: UIViewController, UITextViewDelegate {
    /// 工具栏底部约束
    private var toolbarBottomCons: NSLayoutConstraint?
    
    /// 表情键盘控制器
    private lazy var emoticonKeyboardVC: EmoticonViewController = EmoticonViewController { (emoticon) -> () in
        self.tv.insertEmoticon(emoticon)
        self.textViewDidChange(self.tv)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 1. 添加子控制器
        addChildViewController(emoticonKeyboardVC)
        
        // 准备导航条
        prepareNavigationBar()
        // 准备输入框
        prepareTextView()
        // 准备toolbar
        prepareToolBar()
        
        // 2.注册通知监听键盘
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardChange(notify: NSNotification)
    {
        print(notify)
        
        // 获取最终的frame － OC 中将结构体保存在字典中，存成 NSValue
        let rect = notify.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        //        toolbarBottomCons?.constant = -rect.height
        toolbarBottomCons?.constant = -(view.bounds.height - rect!.origin.y)
        
        // 获取动画时长
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        // 获取动画曲线数值 － 7 苹果没有提供文档
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue
        
        UIView.animateWithDuration(duration) { () -> Void in
            // 设置动画曲线
            UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        
        let anim = toolbar.layer.animationForKey("position")
        print(anim?.duration)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 唤醒键盘
        tv.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tv.resignFirstResponder()
    }
    
    
    /**
    准备导航条
    */
    private func prepareNavigationBar(){
        // 1. 左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 2. 右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 3. 导航栏
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        label1.text = "发微博"
        label1.sizeToFit()
        let label2 = UILabel(color: UIColor(white: 0.0, alpha: 0.5), fontSize: 13)
        label2.text = UserAccount.loadAccount()?.name ?? ""
        label2.sizeToFit()
        
        titleView.addSubview(label1)
        titleView.addSubview(label2)
        
        label1.ST_AlignInner(type: ST_AlignType.TopCenter, referView: titleView, size: nil)
        label2.ST_AlignInner(type: ST_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
        
    }
    
    ///  关闭
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///  发布微博
    func sendStatus() {
        
        // 1. 获取带表情符号的文本字符串
        let text = self.tv.emoticonText()
        // 2. 判断文本长度
        if text.characters.count > STStatusTextMaxLength
        {
              SVProgressHUD.showInfoWithStatus("输入的内容过长", maskType: .Gradient)
                return
        }
        
        
        let path = "2/statuses/update.json"
        let params = ["access_token" : UserAccount.loadAccount()!.access_token! , "status" : text]
        NetworkTools.sharedNetworkTools().POST(path, parameters: params, success: { (_, JSON) -> Void in
            print(JSON)
            SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            self.close()
            }) { (_, error) -> Void in
                print(error)
                SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
        }
    }
    
    /**
    准备输入视图
    */
    private func prepareTextView()
    {
        view.addSubview(tv)
        tv.ST_Fill(view)        
        // 设置 占位标签
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.sizeToFit()
        tv.addSubview(placeHolderLabel)
        placeHolderLabel.ST_AlignInner(type: ST_AlignType.TopLeft, referView: tv, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    func prepareToolBar()
    {
        view.addSubview(toolbar)
        // 提示：设置一个和按钮背景一样的颜色，具体的数值，`平面设计师`会告诉我们
        toolbar.backgroundColor = UIColor(white: 0.4, alpha: 1.0)
        
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        
        // 所有按钮的数组
        var items = [UIBarButtonItem]()
        
        // 设置按钮 - 问题：图片名称(高亮图片) / 监听方法
        for settings in itemSettings
        {
            items.append(UIBarButtonItem(imageName: settings["imageName"]!, highlightedImageName: nil, target: nil, actionName: settings["action"]))
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil))
        }
        // 删除末尾的弹簧
        items.removeLast()
        toolbar.items = items
        
        // 布局toolbar
        let w = UIScreen.mainScreen().bounds.width
        let cons = toolbar.ST_AlignInner(type: ST_AlignType.BottomLeft, referView: view, size: CGSize(width: w, height: 44))
        toolbarBottomCons = toolbar.ST_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        view.addSubview(lengthTipLabel)
        lengthTipLabel.ST_AlignVertical(type: ST_AlignType.TopRight, referView: toolbar, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    ///  选择照片
    func selectPicture() {
        print("选择照片")
    }
    ///  切换表情视图
    func inputEmoticon() {
        // 如果输入视图是 nil，说明使用的是系统键盘
        print(tv.inputView)
        
        // 要切换键盘之前，需要先关闭键盘
        tv.resignFirstResponder()
        
        // 更换键盘输入视图
        tv.inputView = (tv.inputView == nil) ? emoticonKeyboardVC.view : nil
        
        // 重新设置焦点
        tv.becomeFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(textView: UITextView) {

        // 1.修改提示文本状态
        placeHolderLabel.hidden = textView.hasText()
        // 2.修改发送按钮状态
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        // 3.修改文字数量
        let len = STStatusTextMaxLength - textView.emoticonText().characters.count
        print(len)
        lengthTipLabel.text = (len == STStatusTextMaxLength) ? "" : String(len)
        lengthTipLabel.textColor = len >= 0 ? UIColor.lightGrayColor() : UIColor.redColor()
        
    }
    
    // MARK: 懒加载
    private lazy var tv: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.font = UIFont.systemFontOfSize(18)
        // 设置垂直滚动
        tv.alwaysBounceVertical = true
        // 滚动关闭键盘
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        return tv
        }()
    /// 提示文本
    private lazy var placeHolderLabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 18)
    /// 底部工具条
    private lazy var toolbar = UIToolbar()
    
    /// 长度提示标签
    private lazy var lengthTipLabel: UILabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 12)
}

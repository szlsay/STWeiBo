//
//  WelcomeViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/16.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    /// 记录底部约束
    var bottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.添加子控件
        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        // 2.布局子控件
        bgIV.ST_Fill(view)

        let cons = iconView.ST_AlignInner(type: ST_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -150))
        // 拿到头像的底部约束
        bottomCons = iconView.ST_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        messageLabel.ST_AlignVertical(type: ST_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))
        
        // 3.设置用户头像
        if let iconUrl = UserAccount.loadAccount()?.avatar_large
        {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomCons?.constant = -UIScreen.mainScreen().bounds.height -  bottomCons!.constant
        print(-UIScreen.mainScreen().bounds.height)
        print(bottomCons!.constant)
        // -736.0 + 586.0 = -150.0
        print(-UIScreen.mainScreen().bounds.height -  bottomCons!.constant)
        
        // 3.执行动画
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                // 头像动画
                self.iconView.layoutIfNeeded()
            }) { (_) -> Void in
 
                // 文本动画
                UIView.animateWithDuration( 2.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.messageLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        print("OK")
                })
        }
        
    }
    
    // MARK: -懒加载
    private lazy var bgIV: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var messageLabel: UILabel = {
       let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()
}

//
//  HomeTableViewController.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//
import UIKit

class HomeTableViewController: BaseTableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
        // 2.初始化导航条
        setupNav()
    }
    
    private func setupNav()
    {
        // 1.初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        // 2.初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("小沈微博 ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: "titleBtnClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(btn: TitleButton)
    {
        // 1.修改箭头方向
        btn.selected = !btn.selected
        
        // 2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        // 2.1设置转场代理
        // 默认情况下modal会移除以前控制器的view, 替换为当前弹出的view
        // 如果自定义转场, 那么就不会移除以前控制器的view
        vc?.transitioningDelegate = self
        // 2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)

    }
    
    func leftItemClick()
    {
        print(__FUNCTION__)
    }
    
    func rightItemClick()
    {
        print(__FUNCTION__)
    }
    
    /// 记录当前是否是展开
    var isPresent: Bool = false
}

extension HomeTableViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // MARK: - 只要实现了一下方法, 那么系统自带的默认动画就没有了, "所有"东西都需要程序员自己来实现
    /**
    告诉系统谁来负责Modal的展现动画
    
    :param: presented  被展现视图
    :param: presenting 发起的视图
    :returns: 谁来负责
    */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }
    
    /**
     告诉系统谁来负责Modal的消失动画
     
     :param: dismissed 被关闭的视图
     
     :returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    /**
    返回动画时长
    
    :param: transitionContext 上下文, 里面保存了动画需要的所有参数
    
    :returns: 动画时长
    */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    /**
     告诉系统如何动画, 无论是展现还是消失都会调用这个方法
     
     :param: transitionContext 上下文, 里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.拿到展现视图
        /*
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        // 通过打印发现需要修改的就是toVC上面的View
        print(toVC)
        print(fromVC)
        */
        if isPresent
        {
            // 展开
            print("展开")
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
            
            // 注意: 一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            // 设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // 2.执行动画
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                // 2.1清空transform
                toView.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    // 2.2动画执行完毕, 一定要告诉系统
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            }
        }else
        {
            // 关闭
            print("关闭")
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                // 注意:由于CGFloat是不准确的, 所以如果写0.0会没有动画
                // 压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
        }
    }
}

//
//  PopoverAnimator.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit


// 定义常量保存通知的名称
let STPopoverAnimatorWillShow = "STPopoverAnimatorWillShow"
let STPopoverAnimatorWilldismiss = "STPopoverAnimatorWilldismiss"

class PopoverAnimator: NSObject , UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
    /// 记录当前是否是展开
    var isPresent: Bool = false
    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        // 设置菜单的大小
        pc.presentFrame = presentFrame
        return pc
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
        // 发送通知, 通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(STPopoverAnimatorWillShow, object: self)
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
        // 发送通知, 通知控制器即将消失
        NSNotificationCenter.defaultCenter().postNotificationName(STPopoverAnimatorWilldismiss, object: self)
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
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
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
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
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

//
//  MJMagicMoveTransition.m
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import "MJMagicMovePresentTransition.h"
#import "MJBeautyViewController.h"
#import "MJBeautyDetailViewController.h"
#import "MJImageCollectionViewCell.h"

@implementation MJMagicMovePresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1.获取动画的源控制器和目标控制器
    MJBeautyDetailViewController* toVC = (MJBeautyDetailViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];

    //2.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;

    //3.添加到 container 中
    [containerView addSubview:toVC.view];

    //4.执行动画: 第二个控制器的透明度0~1
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        delay:0.0f
        usingSpringWithDamping:0.6f
        initialSpringVelocity:1.0f
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            toVC.view.alpha = 1.0;
        }
        completion:^(BOOL finished) {
            //告诉系统动画结束
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
}
@end

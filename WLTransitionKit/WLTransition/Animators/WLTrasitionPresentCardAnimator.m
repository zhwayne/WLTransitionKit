//
//  WLTrasitionPresentCardAnimator.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/2.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTrasitionPresentCardAnimator.h"

@interface WLTrasitionPresentCardAnimator ()

@property (nonatomic) UIView *dimmingView;

@end

@implementation WLTrasitionPresentCardAnimator

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dammingOpacity = 0.7;
    }
    return self;
}

- (NSTimeInterval)duration {
    return 0.3;
}

- (CGRect)frameOfPresentedViewInContainerView:(UIView *)containerView {
    const CGFloat topOffset = 150;
    CGRect frame = containerView.bounds;
    frame.origin.y += topOffset;
    frame.size.height -= topOffset;
    return frame;
}

- (void)comeOverAnimationWillBegin:(WLTransitionContext *)context {
    
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:context.containerView.bounds];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
        [_dimmingView addGestureRecognizer:tap];
    } else {
        [_dimmingView removeFromSuperview];
    }
    [context.containerView insertSubview:_dimmingView atIndex:0];
    
    __block CGRect toViewFrame = context.toView.frame;
    toViewFrame.origin.y += CGRectGetHeight(toViewFrame);
    context.toView.frame = toViewFrame;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:context.toView.bounds
                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                     cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    context.toView.layer.mask = maskLayer;
    [context.containerView addSubview:context.toView];
    
    context.fromView.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.dimmingView.alpha = self.dammingOpacity;
                         toViewFrame.origin.y -= CGRectGetHeight(toViewFrame);
                         context.toView.frame = toViewFrame;
                         
                         context.fromView.layer.cornerRadius = 16;
                         context.fromView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
                     } completion:^(BOOL finished) {
                         [context completeTransition];
                     }];
}

- (void)goBackAnimationWillBegin:(WLTransitionContext *)context {
    
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.dimmingView.alpha = 0;
                         CGRect fromViewFrame = context.fromView.frame;
                         fromViewFrame.origin.y += CGRectGetHeight(fromViewFrame);
                         context.fromView.frame = fromViewFrame;
                         
                         context.toView.layer.cornerRadius = 0;
                         context.toView.layer.transform = CATransform3DIdentity;
                     } completion:^(BOOL finished) {
                         if (!context.wasCancelled) {
                             [self.dimmingView removeFromSuperview];
                             [context.fromView removeFromSuperview];
                         }
                         [context completeTransition];
                     }];
}

@end

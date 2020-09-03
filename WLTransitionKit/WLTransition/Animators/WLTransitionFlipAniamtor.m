//
//  WLTransitionFlipAniamtor.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTransitionFlipAniamtor.h"

@implementation WLTransitionFlipAniamtor

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (NSTimeInterval)duration {
    return 1;
}

- (void)appearWithContext:(WLTransitionContext *)context {
    
    context.fromView.layer.doubleSided = NO;
    context.toView.layer.doubleSided = NO;
    context.containerView.backgroundColor = self.dammingColor ?: [UIColor blackColor];
    
    [context.containerView addSubview:context.toView];
    context.toView.alpha = 0;
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1 / 2000.0;
    
    context.fromView.layer.transform = t;
    context.toView.layer.transform = CATransform3DRotate(t, -M_PI, 0, 1, 0);
    
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         context.fromView.layer.transform = CATransform3DRotate(t, -M_PI, 0, 1, 0);
                         context.toView.layer.transform = CATransform3DRotate(t, 0.000001, 0, 1, 0);
                         context.fromView.alpha = 0;
                         context.toView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [context completeTransition];
                         context.toView.layer.transform = CATransform3DIdentity;
                     }];
}

- (void)dissappearWithContext:(WLTransitionContext *)context {
    
    context.fromView.layer.doubleSided = NO;
    context.toView.layer.doubleSided = NO;
    
    [context.containerView addSubview:context.toView];
    context.toView.alpha = 0;
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1 / 2000.0;
    
    context.fromView.layer.transform = CATransform3DRotate(t, 0.000001, 0, 1, 0);
    context.toView.layer.transform = CATransform3DRotate(t, -M_PI * 0.999999, 0, 1, 0);
    
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         context.fromView.layer.transform = CATransform3DRotate(t, M_PI, 0, 1, 0);
                         context.toView.layer.transform = CATransform3DRotate(t, 0, 0, 1, 0);
                         context.fromView.alpha = 0;
                         context.toView.alpha = 1;
                     } completion:^(BOOL finished) {
                         if (!context.wasCancelled) {
                             [context.fromView removeFromSuperview];
                         }
                         context.toView.layer.transform = CATransform3DIdentity;
                         [context.toView layoutIfNeeded];
                         [context completeTransition];
                     }];
}

@end

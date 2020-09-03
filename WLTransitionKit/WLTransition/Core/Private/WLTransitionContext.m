//
//  WLTransitionContext.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTransitionContext.h"
#import "WLTransitionContext+Private.h"

@interface WLTransitionContext ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning>transition;

@end

@implementation WLTransitionContext
@dynamic wasCancelled;

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (instancetype)initWithTransition:(id<UIViewControllerContextTransitioning>)transition
{
    self = [super init];
    if (self) {
        _transition = transition;
    }
    return self;
}

- (void)completeTransition {
    BOOL wasCancelled = self.wasCancelled;
    if (_transition) {
        // Once the 'completed transition' method executes, 'wasCancel' will become NO.
        [_transition completeTransition:!wasCancelled];
    }
    if (_didEndTransition) {
        _didEndTransition(wasCancelled);
        if (!self.wasCancelled) { _didEndTransition = nil; }
    }
}

- (UIViewController *)fromViewController {
    return [_transition viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (UIViewController *)toViewController {
    return [_transition viewControllerForKey:UITransitionContextToViewControllerKey];
}

- (UIView *)fromView {
    return [_transition viewForKey:UITransitionContextFromViewKey] ?: self.fromViewController.view;
}

- (UIView *)toView {
    return [_transition viewForKey:UITransitionContextToViewKey] ?: self.toViewController.view;
}

- (UIView *)containerView {
    return [_transition containerView];
}

- (BOOL)wasCancelled {
    return _transition.transitionWasCancelled;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    return [_transition initialFrameForViewController:vc];
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    return [_transition finalFrameForViewController:vc];
}

@end

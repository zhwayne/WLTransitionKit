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

@property (nonatomic, weak) id<UIViewControllerContextTransitioning>transition;

@end

@implementation WLTransitionContext
@dynamic wasCancelled;

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (BOOL)wasCancelled {
    return _transition.transitionWasCancelled;
}

- (instancetype)initWithTransition:(id<UIViewControllerContextTransitioning>)transition
{
    self = [super init];
    if (self) {
        _transition = transition;
        _fromViewController = [transition viewControllerForKey:UITransitionContextFromViewControllerKey];
        _toViewController = [transition viewControllerForKey:UITransitionContextToViewControllerKey];
        _fromView = [transition viewForKey:UITransitionContextFromViewKey] ?: _fromViewController.view;
        _toView = [transition viewForKey:UITransitionContextToViewKey] ?: _toViewController.view;
        _containerView = [transition containerView];
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

@end

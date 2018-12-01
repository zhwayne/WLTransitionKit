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
        _fromView = [transition viewForKey:UITransitionContextFromViewKey];
        _toView = [transition viewForKey:UITransitionContextToViewKey];
        _containerView = [transition containerView];
    }
    return self;
}

- (void)completeTransition {
    if (_transition) {
        [_transition completeTransition:!self.wasCancelled];
    }
    if (_didEndTransition) {
        _didEndTransition(self.wasCancelled);
    }
}

@end

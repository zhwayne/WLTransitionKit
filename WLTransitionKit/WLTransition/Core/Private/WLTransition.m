//
//  WLTransition.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTransition.h"
#import "WLTransition+Private.h"
#import "WLTransitionContext+Private.h"

@implementation WLTransition
@synthesize interactive = _interactive;

- (instancetype)init {
    self = [super init];
    if (self) {
        _interactive = [[WLPercentDrivenInteractiveTransition alloc] init];
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animator.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    WLTransitionContext *context = [[WLTransitionContext alloc] initWithTransition:transitionContext];
    context.duration = self.animator.duration;
    
    if (self.operation == WLTransitionOperationComeOver) {
        if ([self.animator respondsToSelector:@selector(frameOfPresentedViewInContainerView:)]) {
            CGRect frame = [self.animator frameOfPresentedViewInContainerView:context.containerView];
            context.toView.frame = frame;
        }
        context.didEndTransition = self.didEndComeOverTransition;
        [self.animator comeOverAnimationWillBegin:context];
    } else {
        context.didEndTransition = self.didEndGoBackTransition;
        [self.animator goBackAnimationWillBegin:context];
    }
}

@end

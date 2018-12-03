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
#import "UIViewController+WLTransition.h"

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
            context.toViewController.preferredContentSize = frame.size;
            context.toView.frame = frame;
        }
        context.didEndTransition = self.didEndComeOverTransition;
        [self.animator comeOverAnimationWillBegin:context];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(context.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Add pan gesture if needed.
            [self _addScreenEdgePanGestureRecognizerIfNeededWithContext:context];
        });
    } else {
        context.didEndTransition = self.didEndGoBackTransition;
        [self.animator goBackAnimationWillBegin:context];
    }
}

- (void)_addScreenEdgePanGestureRecognizerIfNeededWithContext:(WLTransitionContext *)context {
    
    BOOL presented = context.fromViewController.presentedViewController == context.toViewController;
    void (^addPanGestureRecognizer)(void) = ^ {
        self.interactive.edge = WLEdgePanGestureEdgeLeft;
        self.interactive.operation = WLTransitionOperationGoBack;
        self.interactive.goBackAction = ^{
            if (presented) {
                [context.toViewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [context.fromViewController.navigationController popViewControllerAnimated:YES];
            }
        };
        [self.interactive attachGestureToView:context.containerView];
    };
    
    if (!context.toViewController.wlt_disableGoBackInteractive) {
        addPanGestureRecognizer();
    }
}

@end

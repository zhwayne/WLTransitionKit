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

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

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
    
    if (self.operation == WLTransitionOperationAppear) {
        context.didEndTransition = self.didEndAppearTransition;
        [self.animator appearWithContext:context];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(context.duration + 0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Add pan gesture if needed.
            [self _addScreenEdgePanGestureRecognizerIfNeededWithContext:context];
        });
    } else {
        context.didEndTransition = self.didEndDisappearTransition;
        if (self.interactive.isInteractive) {
            [self.animator dissappearWithContext:context];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.animator dissappearWithContext:context];
            });
        }
    }
}

- (void)_addScreenEdgePanGestureRecognizerIfNeededWithContext:(WLTransitionContext *)context {
    // FIXME: context 中的属性会全部为nil
    BOOL presented = context.fromViewController.presentedViewController == context.toViewController;
    self.interactive.operation = WLTransitionOperationDisappear;
    self.interactive.disappearAction = ^{
        if (presented) {
            [context.toViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [context.toViewController.navigationController popViewControllerAnimated:YES];
        }
    };
    
    if (!context.toViewController.wlt_interactivePopDisabled) {
        [self.interactive attachGestureToView:context.toView];
    }
}

@end

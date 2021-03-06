//
//  UIViewController+WLTransition.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "UIViewController+WLTransition.h"
#import "UIViewController+WLTPrivate.h"
#import "WLTransition+Private.h"
#import <objc/runtime.h>

@implementation UIViewController (WLTransition)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method dismissViewControllerAnimated_completion = class_getInstanceMethod(self.class, @selector(dismissViewControllerAnimated:completion:));
        Method wlt_dismissViewControllerAnimated_completion = class_getInstanceMethod(self.class, @selector(wlt_dismissViewControllerAnimated:completion:));
        method_exchangeImplementations(dismissViewControllerAnimated_completion, wlt_dismissViewControllerAnimated_completion);
    });
}

- (void)setWlt_interactivePopDisabled:(BOOL)wlt_disableGoBackInteractive {
    objc_setAssociatedObject(self,
                             @selector(wlt_interactivePopDisabled),
                             @(wlt_disableGoBackInteractive),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wlt_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)wlt_presentViewController:(UIViewController *)viewControllerToPresent
           withTransitionAnimator:(id<WLTransitionAnimation>)animator
                       completion:(void (^ _Nullable)(void))completion {
    
    WLViewControllerTransitioningDelegate *traDelegate = [[WLViewControllerTransitioningDelegate alloc] init];
    traDelegate.transition.animator = animator;
    traDelegate.transition.operation = WLTransitionOperationAppear;
    viewControllerToPresent.wlt_transitionDelegate = traDelegate;
    
    viewControllerToPresent.transitioningDelegate = traDelegate;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (void)wlt_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    __weak typeof(self) weakSelf = self;
    if (self.wlt_transitionDelegate) {
        self.wlt_transitionDelegate.transition.operation = WLTransitionOperationDisappear;
        self.wlt_transitionDelegate.transition.didEndDisappearTransition = ^(BOOL wasCancelled) {
            if (!wasCancelled) {
                weakSelf.wlt_transitionDelegate = nil;
            }
        };
        self.transitioningDelegate = self.wlt_transitionDelegate;
    }
    [self wlt_dismissViewControllerAnimated:flag completion:completion];
}

@end


@implementation UIViewController (WLTGoBackPercentDriven)

- (void)wlt_beginInteractiveTransition {
    if (self.wlt_navigationDelegate) {
        [self.wlt_navigationDelegate.transition.interactive beginPercentDriven];
    } else if (self.wlt_transitionDelegate) {
        [self.wlt_transitionDelegate.transition.interactive beginPercentDriven];
    }
}

- (void)wlt_updateInteractiveTransition:(CGFloat)percent {
    if (self.wlt_navigationDelegate) {
        [self.wlt_navigationDelegate.transition.interactive updatePercent:percent];
    } else if (self.wlt_transitionDelegate) {
        [self.wlt_transitionDelegate.transition.interactive updatePercent:percent];
    }
}

- (void)wlt_endInteractiveTransition {
    if (self.wlt_navigationDelegate) {
        [self.wlt_navigationDelegate.transition.interactive endPercentDriven];
    } else if (self.wlt_transitionDelegate) {
        [self.wlt_transitionDelegate.transition.interactive endPercentDriven];
    }
}

@end

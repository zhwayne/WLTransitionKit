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
        
        Method viewWillAppear = class_getInstanceMethod(self.class, @selector(viewDidAppear:));
        Method wlt_viewWillAppear = class_getInstanceMethod(self.class, @selector(wlt_viewDidAppear:));
        method_exchangeImplementations(viewWillAppear, wlt_viewWillAppear);
        
        Method dismissViewControllerAnimated_completion = class_getInstanceMethod(self.class, @selector(dismissViewControllerAnimated:completion:));
        Method wlt_dismissViewControllerAnimated_completion = class_getInstanceMethod(self.class, @selector(wlt_dismissViewControllerAnimated:completion:));
        method_exchangeImplementations(dismissViewControllerAnimated_completion, wlt_dismissViewControllerAnimated_completion);
    });
}

- (void)wlt_viewDidAppear:(BOOL)animate {
    [self wlt_viewDidAppear:animate];
    
    if (!self.presentingViewController && self.navigationController) {
        if (self.wlt_navDelegate) { // Push with animation.
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.navigationController.interactivePopGestureRecognizer.enabled = !self.wlt_disableGoBackInteractive;
        }
    }
}

- (void)setWlt_disableGoBackInteractive:(BOOL)wlt_disableGoBackInteractive {
    objc_setAssociatedObject(self, @selector(wlt_disableGoBackInteractive), @(wlt_disableGoBackInteractive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wlt_disableGoBackInteractive {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)wlt_presentViewController:(UIViewController *)viewControllerToPresent
           withTransitionAnimator:(id<WLTransitionAnimation>)animator
                       completion:(void (^ _Nullable)(void))completion {
    
    WLViewControllerTransitioningDelegate *traDelegate = [[WLViewControllerTransitioningDelegate alloc] init];
    traDelegate.transition.animator = animator;
    traDelegate.transition.operation = WLTransitionOperationComeOver;
    viewControllerToPresent.wlt_traDelegate = traDelegate;
    
    viewControllerToPresent.transitioningDelegate = traDelegate;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (void)wlt_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    self.transitioningDelegate = self.wlt_traDelegate;
    self.wlt_traDelegate.transition.operation = WLTransitionOperationGoBack;
    [self wlt_dismissViewControllerAnimated:flag completion:^{
        self.wlt_traDelegate = nil;
        if (completion) completion();
    }];
}

@end

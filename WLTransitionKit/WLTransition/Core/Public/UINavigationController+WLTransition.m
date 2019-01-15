//
//  UINavigationController+WLTransition.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "UINavigationController+WLTransition.h"
#import "UIViewController+WLTransition.h"
#import "UIViewController+WLTPrivate.h"
#import "WLTransition+Private.h"
#import "WLTransitionAnimation.h"
#import <objc/runtime.h>

@interface UINavigationController ()

@property (nonatomic) id<UINavigationControllerDelegate> wlt_originalDelegate;

@end

@implementation UINavigationController (WLTransition)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method method_popViewControllerAnimated = class_getInstanceMethod(self.class, @selector(popViewControllerAnimated:));
        Method wlt_method_popViewControllerAnimated = class_getInstanceMethod(self.class, @selector(wlt_popViewControllerAnimated:));
        method_exchangeImplementations(method_popViewControllerAnimated, wlt_method_popViewControllerAnimated);
        
        Method pushViewController_animated = class_getInstanceMethod(self.class, @selector(pushViewController:animated:));
        Method wlt_pushViewController_animated = class_getInstanceMethod(self.class, @selector(wlt_pushViewController:animated:));
        method_exchangeImplementations(pushViewController_animated, wlt_pushViewController_animated);
    });
}

- (void)setWlt_originalDelegate:(id<UINavigationControllerDelegate>)wlt_originalDelegate {
    objc_setAssociatedObject(self, @selector(wlt_originalDelegate), wlt_originalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UINavigationControllerDelegate>)wlt_originalDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)wlt_pushViewController:(UIViewController *)viewController
        withTransitionAnimator:(nonnull id<WLTransitionAnimation>)animator
                    completion:(void (^ _Nullable)(BOOL))completion {
    
    if (self.delegate) {
        self.wlt_originalDelegate = self.delegate;
    }
    
    WLNavigationControllerDelegate *tempDelegate = [WLNavigationControllerDelegate new];
    tempDelegate.transition.animator = animator;
    
    __weak typeof(self) weakSelf = self;
    tempDelegate.transition.didEndComeOverTransition = ^(BOOL wasCancelled) {
        weakSelf.delegate = weakSelf.wlt_originalDelegate;
        weakSelf.wlt_originalDelegate = nil;
        
        if (!wasCancelled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(wasCancelled);
            });
        }
    };

    viewController.wlt_navDelegate = tempDelegate;
    self.delegate = viewController.wlt_navDelegate;
    [self pushViewController:viewController animated:YES];
}

- (void)wlt_pushViewController:(UIViewController *)viewController withTransitionAnimator:(id<WLTransitionAnimation>)animator {
    [self wlt_pushViewController:viewController withTransitionAnimator:animator completion:nil];
}

- (void)wlt_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.navigationController.viewControllers containsObject:viewController]) {;
        [self wlt_pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)wlt_popViewControllerAnimated:(BOOL)animated {
    __weak UIViewController *viewController = self.viewControllers.lastObject;
    if (viewController.wlt_navDelegate == nil) {
        return [self wlt_popViewControllerAnimated:animated];
    }

    if (self.delegate) {
        self.wlt_originalDelegate = self.delegate ;
    }

    __weak typeof(self) weakSelf = self;
    viewController.wlt_navDelegate.transition.didEndGoBackTransition = ^(BOOL wasCancelled) {
        weakSelf.delegate = weakSelf.wlt_originalDelegate;
        if (!wasCancelled) {
            weakSelf.wlt_navDelegate = nil;
            weakSelf.wlt_originalDelegate = nil;
            viewController.wlt_navDelegate = nil;
        }
    };
    
    self.delegate = viewController.wlt_navDelegate;
    id res = [self wlt_popViewControllerAnimated:animated];
    return res;
}

@end

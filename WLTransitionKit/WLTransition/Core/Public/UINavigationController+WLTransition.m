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

@interface UINavigationController () <UIGestureRecognizerDelegate>

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
    
    if (![self.viewControllers containsObject:viewController]) {
        [self pushViewController:viewController animated:YES];
    }
}

- (void)wlt_pushViewController:(UIViewController *)viewController withTransitionAnimator:(id<WLTransitionAnimation>)animator {
    [self wlt_pushViewController:viewController withTransitionAnimator:animator completion:nil];
}

- (void)wlt_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.navigationController.viewControllers containsObject:viewController]) {;
        // 部分代码来源于 https://github.com/forkingdog/FDFullscreenPopGesture
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.wlt_popGestureRecognizer]) {
            
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.wlt_popGestureRecognizer];
            
            NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
            id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            self.wlt_popGestureRecognizer.delegate = self;
            [self.wlt_popGestureRecognizer addTarget:internalTarget action:internalAction];
            
            self.interactivePopGestureRecognizer.enabled = NO;
        }
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

#pragma mark - Gesture recognizer handler

- (UIPanGestureRecognizer *)wlt_popGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

// 这部分大部分代码来源于 https://github.com/forkingdog/FDFullscreenPopGesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.viewControllers.lastObject;
    if (topViewController.wlt_navDelegate) {
        return NO;
    }
    if (topViewController.wlt_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = 44;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end

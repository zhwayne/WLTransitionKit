//
//  WLNavigationControllerDelegate.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLNavigationControllerDelegate.h"
#import "WLTransition+Private.h"
#import "UIViewController+WLTransition.h"
#import "UINavigationController+WLTransition.h"

@interface WLNavigationControllerDelegate ()

@end

@implementation WLNavigationControllerDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _transition = [WLTransition new];
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.transition.operation == WLTransitionOperationComeOver
        && self.transition.animator.isEnablePopInteractive
        && !viewController.wlt_isDisablePopInteractive) {
        // 页面出现以后, 需要设置返回手势
        self.transition.interactive.edge = WLEdgePanGestureEdgeLeft;
        self.transition.interactive.operation = WLTransitionOperationGoBack;
        self.transition.interactive.goBackAction = ^{
            [navigationController popViewControllerAnimated:YES];
        };
        [self.transition.interactive attachGestureToViewController:viewController];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    _navigationController = navigationController;
    
    if (operation == UINavigationControllerOperationPush) {
        self.transition.operation = WLTransitionOperationComeOver;
        if (![self.transition.animator respondsToSelector:@selector(comeOverAnimationWillBegin:)]) {
            return nil;
        }
    } else {
        self.transition.operation = WLTransitionOperationGoBack;
        if (![self.transition.animator respondsToSelector:@selector(goBackAnimationWillBegin:)]) {
            return nil;
        }
    }
    return self.transition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if (animationController != self.transition) {
        return nil;
    }
    
    if (self.transition.operation == WLTransitionOperationComeOver) {
        return nil;
    }
    
    if (self.transition.interactive.isInteractive == NO) {
        return nil;
    }
    
    return self.transition.interactive;
}

@end

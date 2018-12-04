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

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (instancetype)init
{
    self = [super init];
    if (self) {
        _transition = [WLTransition new];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{    
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

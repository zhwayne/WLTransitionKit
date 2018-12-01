//
//  WLViewControllerTransitioningDelegate.m
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/1.
//  Copyright © 2018 wayne. All rights reserved.
//

#import "WLViewControllerTransitioningDelegate.h"
#import "WLTransition+Private.h"

@implementation WLViewControllerTransitioningDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _transition = [WLTransition new];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transition.interactive;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transition.interactive;
}

@end

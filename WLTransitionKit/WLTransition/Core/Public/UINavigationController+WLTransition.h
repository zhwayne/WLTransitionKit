//
//  UINavigationController+WLTransition.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTransition.h"
#import "WLTransitionAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (WLTransition)

- (void)wlt_pushViewController:(UIViewController *)viewController
        withTransitionAnimator:(id<WLTransitionAnimation>)animator;

- (void)wlt_pushViewController:(UIViewController *)viewController
        withTransitionAnimator:(id<WLTransitionAnimation>)animator
                    completion:(void (^ _Nullable)(BOOL wasCancelled))completion;

@end

NS_ASSUME_NONNULL_END

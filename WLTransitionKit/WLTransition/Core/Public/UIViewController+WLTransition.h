//
//  UIViewController+WLTransition.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTransitionAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (WLTransition)

@property (nonatomic) BOOL wlt_disableGoBackInteractive;

- (void)wlt_presentViewController:(UIViewController *)viewControllerToPresent
           withTransitionAnimator:(id<WLTransitionAnimation>)animator
                       completion:(void (^ _Nullable)(void))completion;


@end

@interface UIViewController (WLTGoBackPercentDriven)

- (void)wlt_beginInteractiveTransition;
- (void)wlt_updateInteractiveTransition:(CGFloat)percent;
- (void)wlt_endInteractiveTransition;

@end

NS_ASSUME_NONNULL_END

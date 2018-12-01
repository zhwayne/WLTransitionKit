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

@property (nonatomic, getter=wlt_isDisablePopInteractive) BOOL wlt_disablePopInteractive;


- (void)wlt_presentViewController:(UIViewController *)viewControllerToPresent
           withTransitionAnimator:(id<WLTransitionAnimation>)animator
                       completion:(void (^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
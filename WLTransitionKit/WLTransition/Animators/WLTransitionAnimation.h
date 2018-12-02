//
//  WLTransitionAnimation.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLTransitionContext.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WLTransitionAnimation <NSObject>

/**
 This is the time required to specify the transition animation.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 In general, when we push or present a view controller, we can use the on-screen edge gesture to
 swipe back when we need to return to the previous view controller. This property can be used to
 determine whether the feature needs to be enabled.
 
 Note: In the Navigation Bar Controller, if we have disabled the screen edge gesture, this property
 is invalid for the view controller in the navigation stack.
 */
@property (nonatomic, readonly, getter=isEnableGoBackInteractive) BOOL enableGoBackInteractive;

@optional

- (void)comeOverAnimationWillBegin:(WLTransitionContext *)context;
- (void)goBackAnimationWillBegin:(WLTransitionContext *)context;

- (CGRect)frameOfPresentedViewInContainerView:(UIView *)containerView;

@end

NS_ASSUME_NONNULL_END

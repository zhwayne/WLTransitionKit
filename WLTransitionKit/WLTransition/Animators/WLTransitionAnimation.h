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

@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly, getter=isEnablePopInteractive) BOOL enableGoBackInteractive;

@optional

- (void)comeOverAnimationWillBegin:(WLTransitionContext *)context;
- (void)comeOverAnimationDidEnd:(WLTransitionContext *)context;
- (void)goBackAnimationWillBegin:(WLTransitionContext *)context;
- (void)goBackAnimationDidEnd:(WLTransitionContext *)context;

- (CGRect)frameOfPresentedViewInContainerView:(UIView *)containerView;

@end

NS_ASSUME_NONNULL_END

//
//  WLTransitionContext.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLTransitionContext : NSObject

@property (weak, nonatomic, readonly, nullable) UIViewController *fromViewController;
@property (weak, nonatomic, readonly, nullable) UIViewController *toViewController;

@property (weak, nonatomic, readonly, nullable) UIView *fromView;
@property (weak, nonatomic, readonly, nullable) UIView *toView;

@property (weak, nonatomic, readonly) UIView *containerView;

@property (nonatomic, readonly) BOOL wasCancelled;

@property (nonatomic) NSTimeInterval duration;

- (void)completeTransition;

@end

NS_ASSUME_NONNULL_END

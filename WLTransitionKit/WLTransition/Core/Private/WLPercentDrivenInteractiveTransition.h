//
//  WLPercentDrivenInteractiveTransition.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTransitionConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, readonly) BOOL isInteractive;

@property (nonatomic) WLTransitionOperation operation;

@property (nonatomic, copy) void (^goBackAction)(void);

- (void)attachGestureToView:(UIView *)view;

- (void)beginPercentDriven;
- (void)updatePercent:(CGFloat)percent;
- (void)endPercentDriven;

@end

NS_ASSUME_NONNULL_END

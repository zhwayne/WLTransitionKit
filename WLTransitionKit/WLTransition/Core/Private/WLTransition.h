//
//  WLTransition.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLTransitionContext.h"
#import "WLTransitionAnimation.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^WLAnimateTransitionBlock)(WLTransitionContext *context);

@interface WLTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) id<WLTransitionAnimation> animator;

@end

NS_ASSUME_NONNULL_END

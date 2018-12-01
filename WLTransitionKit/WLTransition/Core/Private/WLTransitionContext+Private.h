//
//  WLTransitionContext+Private.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTransitionContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLTransitionContext ()

@property (nonatomic, copy) void (^didEndTransition)(BOOL wasCancelled);

- (instancetype)initWithTransition:(id<UIViewControllerContextTransitioning>)transition;

@end

NS_ASSUME_NONNULL_END

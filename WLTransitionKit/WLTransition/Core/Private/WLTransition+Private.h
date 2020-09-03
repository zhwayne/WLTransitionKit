//
//  WLTransition+Private.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTransition.h"
#import "WLTransitionConstant.h"
#import "WLPercentDrivenInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLTransition ()

@property (nonatomic) WLTransitionOperation operation;
@property (nonatomic, readonly) WLPercentDrivenInteractiveTransition *interactive;

@property (nonatomic, copy) void (^didEndAppearTransition)(BOOL wasCancelled);
@property (nonatomic, copy) void (^didEndDisappearTransition)(BOOL wasCancelled);

@end

NS_ASSUME_NONNULL_END

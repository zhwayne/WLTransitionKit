//
//  UIGestureRecognizer+BlockSupport.h
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/22.
//  Copyright © 2018 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (BlockSupport)

+ (instancetype)gestureRecognizerWitHandler:(void (^)(__kindof UIGestureRecognizer *gestureRecognizer))handler;

@end

NS_ASSUME_NONNULL_END

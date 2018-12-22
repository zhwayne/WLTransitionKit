//
//  UIGestureRecognizer+BlockSupport.m
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/22.
//  Copyright © 2018 wayne. All rights reserved.
//

#import "UIGestureRecognizer+BlockSupport.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (BlockSupport)

+ (instancetype)gestureRecognizerWitHandler:(void (^)(__kindof UIGestureRecognizer * _Nonnull))handler {
    UIGestureRecognizer *ges = [[[self class] alloc] init];
    [ges addTarget:ges action:@selector(_invoke:)];
    objc_setAssociatedObject(ges, "__invokeHandler", handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return ges;
}

- (void)_invoke:(UIGestureRecognizer *)gestureRecognizer {
    void (^handler)(UIGestureRecognizer *) = objc_getAssociatedObject(self, "__invokeHandler");
    if (handler) {
        handler(gestureRecognizer);
    }
}

@end

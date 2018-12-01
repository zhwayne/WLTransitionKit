//
//  UIViewController+WLTPrivate.m
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/1.
//  Copyright © 2018 wayne. All rights reserved.
//

#import "UIViewController+WLTPrivate.h"
#import <objc/runtime.h>

@implementation UIViewController (WLTPrivate)

- (void)setWlt_navDelegate:(WLNavigationControllerDelegate *)wlt_navDelegate {
    objc_setAssociatedObject(self, @selector(wlt_navDelegate), wlt_navDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WLNavigationControllerDelegate *)wlt_navDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWlt_traDelegate:(WLViewControllerTransitioningDelegate *)wlt_traDelegate {
    objc_setAssociatedObject(self, @selector(wlt_traDelegate), wlt_traDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WLViewControllerTransitioningDelegate *)wlt_traDelegate {
    return objc_getAssociatedObject(self, _cmd);
}


@end

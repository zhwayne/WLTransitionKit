//
//  UIViewController+WLTPrivate.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLNavigationControllerDelegate.h"
#import "WLViewControllerTransitioningDelegate.h"

@interface UIViewController (WLTPrivate)

@property (nonatomic, nullable) WLNavigationControllerDelegate *wlt_navigationDelegate;
@property (nonatomic, nullable) WLViewControllerTransitioningDelegate *wlt_transitionDelegate;

@end

//
//  UIViewController+WLTPrivate.h
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/1.
//  Copyright © 2018 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLNavigationControllerDelegate.h"
#import "WLViewControllerTransitioningDelegate.h"

@interface UIViewController (WLTPrivate)

@property (nonatomic) WLNavigationControllerDelegate *wlt_navDelegate;
@property (nonatomic) WLViewControllerTransitioningDelegate *wlt_traDelegate;


@end

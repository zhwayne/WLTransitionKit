//
//  WLViewControllerTransitioningDelegate.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLTransition.h"

@interface WLViewControllerTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic) WLTransition *transition;

@end

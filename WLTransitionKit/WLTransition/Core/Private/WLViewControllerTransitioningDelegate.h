//
//  WLViewControllerTransitioningDelegate.h
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/1.
//  Copyright © 2018 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLTransition.h"

@interface WLViewControllerTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic) WLTransition *transition;

@end

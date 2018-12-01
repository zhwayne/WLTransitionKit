//
//  WLNavigationControllerDelegate.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLNavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

@property (nonatomic, readonly, nullable) UINavigationController *navigationController;

@property (nonatomic) WLTransition *transition;

@end

NS_ASSUME_NONNULL_END

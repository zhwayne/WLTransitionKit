//
//  WLTransitionConstant.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#ifndef WLTransitionConstant_h
#define WLTransitionConstant_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Operation for transition.
 
 - WLTransitionOperationAppear: Show next view controller.
 - WLTransitionOperationDisappear: Go back to the previous view controller.
 */
typedef NS_ENUM(NSUInteger, WLTransitionOperation) {
    WLTransitionOperationAppear,
    WLTransitionOperationDisappear,
} NS_ENUM_AVAILABLE_IOS(8_0);

#endif /* WLTransitionConstant_h */

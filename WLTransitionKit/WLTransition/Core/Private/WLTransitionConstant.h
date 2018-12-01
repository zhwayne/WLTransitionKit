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

typedef NS_ENUM(NSUInteger, WLTransitionOperation) {
    WLTransitionOperationComeOver,
    WLTransitionOperationGoBack,
};

typedef NS_ENUM(NSUInteger, WLEdgePanGestureEdge) {
    WLEdgePanGestureEdgeNone = 0,
    WLEdgePanGestureEdgeLeft,
    WLEdgePanGestureEdgeRight,  // 未实现
    WLEdgePanGestureEdgeTop,    // 未实现
    WLEdgePanGestureEdgeBottom  // 未实现
};

#endif /* WLTransitionConstant_h */

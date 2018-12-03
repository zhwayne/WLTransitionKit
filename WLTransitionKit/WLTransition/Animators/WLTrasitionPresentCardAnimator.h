//
//  WLTrasitionPresentCardAnimator.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/2.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLTransitionAnimation.h"

@interface WLTrasitionPresentCardAnimator : NSObject <WLTransitionAnimation>

/**
 The value range is [0, 1]. Default is 0.7.
 */
@property (nonatomic) CGFloat dammingOpacity;

@end

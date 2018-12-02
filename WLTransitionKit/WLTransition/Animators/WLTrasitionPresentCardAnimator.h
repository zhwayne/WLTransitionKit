//
//  WLTrasitionPresentCardAnimator.h
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/2.
//  Copyright © 2018 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLTransitionAnimation.h"

@interface WLTrasitionPresentCardAnimator : NSObject <WLTransitionAnimation>

/**
 The value range is [0, 1]. Default is 0.5.
 */
@property (nonatomic) CGFloat dammingOpacity;

@end

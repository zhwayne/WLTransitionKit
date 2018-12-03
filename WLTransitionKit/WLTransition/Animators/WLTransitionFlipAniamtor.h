//
//  WLTransitionFlipAniamtor.h
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLTransitionAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLTransitionFlipAniamtor : NSObject <WLTransitionAnimation>

/**
 Default is black.
 */
@property (nonatomic) UIColor *dammingColor;

@end

NS_ASSUME_NONNULL_END

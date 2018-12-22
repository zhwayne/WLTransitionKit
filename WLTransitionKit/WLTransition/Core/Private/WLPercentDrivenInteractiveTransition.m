//
//  WLPercentDrivenInteractiveTransition.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLPercentDrivenInteractiveTransition.h"

@interface WLPercentDrivenInteractiveTransition ()

@property (nonatomic) float percent;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *pan;

@end


@implementation WLPercentDrivenInteractiveTransition

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
#endif

- (void)attachGestureToView:(UIView *)view {
    
    if (self.edge != WLEdgePanGestureEdgeLeft)
        return;
    
    _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];

//    UIRectEdge edgs[] = {
//        [WLEdgePanGestureEdgeLeft]   = UIRectEdgeLeft,
//        [WLEdgePanGestureEdgeRight]  = UIRectEdgeRight,
//        [WLEdgePanGestureEdgeTop]    = UIRectEdgeTop,
//        [WLEdgePanGestureEdgeBottom] = UIRectEdgeBottom
//    };

    _pan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:_pan];
}

- (void)_handlePan:(UIScreenEdgePanGestureRecognizer *)pan {
    
    CGPoint location = CGPointApplyAffineTransform([pan translationInView:pan.view.window], pan.view.window.transform);
    CGSize viewSize = CGSizeApplyAffineTransform(pan.view.window.frame.size, pan.view.window.transform);

    if (self.edge == WLEdgePanGestureEdgeLeft) {
        _percent = location.x / viewSize.width;
    }
    else if (self.edge == WLEdgePanGestureEdgeRight) {
        _percent = -location.x / viewSize.width;
    }
    else if (self.edge == WLEdgePanGestureEdgeTop) {
        _percent = location.y / viewSize.height;
    }
    else if (self.edge == WLEdgePanGestureEdgeBottom) {
        _percent = -location.y / viewSize.height;
    } else {
        NSCAssert(NO, @"No such edge.");
    }
    
    NSLog(@"%f", _percent);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            if (_operation == WLTransitionOperationGoBack) {
                !_goBackAction ?: _goBackAction();
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            _isInteractive = YES;
            [self updateInteractiveTransition:_percent];
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            _isInteractive = NO;
            [_displayLink invalidate];
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_reverseAnimation:)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            break;
            
        default:
            break;
    }
}


- (void)_reverseAnimation:(CADisplayLink *)displayLink {
    // displayLink.duration indicates the duration of each frame, the screen refresh rate is 60,
    // duration = 1/60.
    NSTimeInterval percentOffset = displayLink.duration / MAX(0.000001, self.duration);
    _percent += (_percent > 0.3 ? percentOffset : -percentOffset);
    [self updateInteractiveTransition:_percent];
    
    if (_percent >= 1) {
        [self finishInteractiveTransition];
        [displayLink invalidate];
        _displayLink = nil;
        return;
    }
    
    if (_percent <= 0) {
        [self cancelInteractiveTransition];
        [displayLink invalidate];
        _displayLink = nil;
    }
}

@end

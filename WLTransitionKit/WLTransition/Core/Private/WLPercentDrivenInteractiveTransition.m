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

- (void)attachGestureToViewController:(UIViewController *)viewController {
    
    if (self.edge != WLEdgePanGestureEdgeLeft)
        return;
    
    _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
    
    UIRectEdge edgs[] = {
        [WLEdgePanGestureEdgeLeft]   = UIRectEdgeLeft,
        [WLEdgePanGestureEdgeRight]  = UIRectEdgeRight,
        [WLEdgePanGestureEdgeTop]    = UIRectEdgeTop,
        [WLEdgePanGestureEdgeBottom] = UIRectEdgeBottom
    };
    
    _pan.edges = edgs[self.edge];
    [viewController.view addGestureRecognizer:_pan];
}

- (void)_handlePan:(UIScreenEdgePanGestureRecognizer *)pan {
    
    CGPoint location = [pan translationInView:pan.view.window];
    CGSize viewSize = pan.view.window.frame.size;

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
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            if (_operation == WLTransitionOperationComeOver) {
                //!_comeOverAction ?: _comeOverAction();
            } else {
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
    NSTimeInterval timeOffset = displayLink.duration;
    _percent += (_percent > 0.35 ? timeOffset : -timeOffset);
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

#pragma mark - UIGestureRecognizerDelegate


@end

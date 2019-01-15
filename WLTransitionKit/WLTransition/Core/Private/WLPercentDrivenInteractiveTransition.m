//
//  WLPercentDrivenInteractiveTransition.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLPercentDrivenInteractiveTransition.h"

@interface WLPercentDrivenInteractiveTransition () <UIGestureRecognizerDelegate>

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
    _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];

    _pan.edges = UIRectEdgeLeft;
    _pan.delegate = self;
    [view addGestureRecognizer:_pan];
}

- (void)_handlePan:(UIScreenEdgePanGestureRecognizer *)pan {
    
    CGPoint location = CGPointApplyAffineTransform([pan translationInView:pan.view.window], pan.view.window.transform);
    CGSize viewSize = CGSizeApplyAffineTransform(pan.view.window.frame.size, pan.view.window.transform);
    _percent = location.x / viewSize.width;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self beginPercentDriven];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self updatePercent:_percent];
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            [self endPercentDriven];
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

#pragma mark -

- (void)beginPercentDriven {
    _isInteractive = YES;
    if (_operation == WLTransitionOperationGoBack) {
        !_goBackAction ?: _goBackAction();
    }
}

- (void)updatePercent:(CGFloat)percent {
    _isInteractive = YES;
    _percent = percent;
    [self updateInteractiveTransition:percent];
}

- (void)endPercentDriven {
    _isInteractive = NO;
    [_displayLink invalidate];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_reverseAnimation:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

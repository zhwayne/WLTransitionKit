//
//  WLTrasitionPresentCardAnimator.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/2.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "WLTrasitionPresentCardAnimator.h"

@interface WLTrasitionPresentCardAnimator ()

@property (nonatomic) UIView *dimmingView;
@property (nonatomic) WLTransitionContext *context;

@end

@implementation WLTrasitionPresentCardAnimator

#if DEBUG
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    if (@available(iOS 11.0, *)) {}
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
#endif

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dammingOpacity = 0.7;
        if (@available(iOS 11.0, *)) {}
        else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNote:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        }
    }
    return self;
}

- (void)handleNote:(NSNotification *)note {
    [_context.containerView setNeedsLayout];
    [_context.containerView layoutIfNeeded];
    if (!_context.toView)
        return;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_context.toView.bounds
                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                     cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    _context.toView.layer.mask = maskLayer;
}

- (NSTimeInterval)duration {
    return 0.25;
}

- (void)appearWithContext:(WLTransitionContext *)context {
    _context = context;
    
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:context.containerView.bounds];
        _dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.alpha = 0;
    } else {
        [_dimmingView removeFromSuperview];
    }
    [context.containerView insertSubview:_dimmingView atIndex:0];
    
    __block CGRect toViewFrame = [context finalFrameForViewController:context.toViewController];
    CGFloat topOffset = 64;
    if (@available(iOS 11.0, *)) {
        topOffset = context.containerView.safeAreaInsets.top + 44;
    }
    toViewFrame.origin.y += topOffset;
    toViewFrame.size.height -= topOffset;
    
    toViewFrame.origin.y += CGRectGetHeight(toViewFrame);
    context.toView.frame = toViewFrame;
    
    if (@available(iOS 11.0, *)) {
        context.toView.layer.cornerRadius = 10;
        context.toView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else {
        // Fallback on earlier versions
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:context.toView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        context.toView.layer.mask = maskLayer;
    }
    
    [context.containerView addSubview:context.toView];
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.dimmingView.alpha = self.dammingOpacity;
        toViewFrame.origin.y -= CGRectGetHeight(toViewFrame);
        context.toView.frame = toViewFrame;
        
        context.fromView.layer.cornerRadius = 12;
        
        CATransform3D t = CATransform3DMakeScale(0.94, 0.94, 1);
        if (@available(iOS 11.0, *)) {
            t = CATransform3DTranslate(t, 0, context.containerView.safeAreaInsets.top - 20, 0);
        }
        context.fromView.layer.transform = t;
    } completion:^(BOOL finished) {
        [context completeTransition];
    }];
}

- (void)dissappearWithContext:(WLTransitionContext *)context {
    
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.dimmingView.alpha = 0;
        CGRect fromViewFrame = context.fromView.frame;
        fromViewFrame.origin.y += CGRectGetHeight(fromViewFrame);
        context.fromView.frame = fromViewFrame;
        
        context.toView.layer.cornerRadius = 0;
        context.toView.layer.transform = CATransform3DIdentity;
        [context.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!context.wasCancelled) {
            [self.dimmingView removeFromSuperview];
            [context.fromView removeFromSuperview];
        }
        [context completeTransition];
    }];
}

@end


# Introduction

A lightweight, flexible custom transition animation library on iOS.

You can use WLTransitionKit to customize any transition animation you want. It's is very simple to implement this feature. you only need to complete the following steps:

1. Implement the `WLTransitionAnimation` protocol to complete your imaginative transition animation.
2. Push or present your next view controller by using the methods provided in the `UINavigationController` and `UIViewController` categories.

# Usage

Here is an example to demonstrate how to customize the transition animation.

If we want a flip transition animation, we can create an object and then implement the `WLTransitionAnimation` protocol first.

```objc
@interface WLTransitionFlipAniamtor : NSObject <WLTransitionAnimation>
@end

@implementation WLTransitionFlipAniamtor

- (NSTimeInterval)duration {
    return 1;
}

- (void)comeOverAnimationWillBegin:(WLTransitionContext *)context {
    
    context.fromView.layer.doubleSided = NO;
    context.toView.layer.doubleSided = NO;
    
    [context.containerView addSubview:context.toView];
    context.toView.alpha = 0;
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1 / 2000.0;
    context.fromView.layer.transform = t;
    context.toView.layer.transform = CATransform3DRotate(t, -M_PI, 0, 1, 0);
    
    [UIView animateWithDuration:context.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         context.fromView.layer.transform = CATransform3DRotate(t, -M_PI, 0, 1, 0);
                         context.toView.layer.transform = CATransform3DRotate(t, 0.000001, 0, 1, 0);
                         context.fromView.alpha = 0;
                         context.toView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [context completeTransition];
                         context.toView.layer.transform = CATransform3DIdentity;
                     }];
}

- (void)goBackAnimationWillBegin:(WLTransitionContext *)context {
    ...
}

@end
```

Then just call the code like this.

```objc
[self.navigationController wlt_pushViewController:viewController
                           withTransitionAnimator:[WLTransitionFlipAniamtor new]];
```

Okay, enjoy it now :)

# License

WLTransitionKit is released under the MIT license. 

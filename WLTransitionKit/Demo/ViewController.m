//
//  ViewController.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 wayne. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "WLTransitionKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToNext:(id)sender {
    
    SecondViewController *viewController = [SecondViewController loadFromMainStoryboard];
    
    [self.navigationController wlt_pushViewController:viewController
                               withTransitionAnimator:[WLTransitionFlipAniamtor new] completion:^(BOOL wasCancelled) {
                                   NSLog(@"Did pushed controller: %@", viewController);
                               }];
}

@end

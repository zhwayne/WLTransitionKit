//
//  SecondViewController.m
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/1.
//  Copyright © 2018 wayne. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "WLTransitionKit.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

+ (instancetype)loadFromMainStoryboard {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentNextVC:(id)sender {
    ThirdViewController *viewController = [ThirdViewController loadFromNib];
    [self.navigationController wlt_presentViewController:viewController
                                  withTransitionAnimator:[WLTransitionFlipAniamtor new]
                                              completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

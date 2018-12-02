//
//  ViewController2.m
//  WLTransitionKit
//
//  Created by 张尉 on 2018/12/2.
//  Copyright © 2018 wayne. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

+ (instancetype)loadFromNib {
    return [[ViewController2 alloc] initWithNibName:NSStringFromClass(ViewController2.class) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)goBack:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end

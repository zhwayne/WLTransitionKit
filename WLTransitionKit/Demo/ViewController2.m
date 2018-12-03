//
//  ViewController2.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/2.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "ViewController2.h"
#import "UIViewController+WLTransition.h"

@interface ViewController2 ()

@end

@implementation ViewController2

+ (instancetype)loadFromNib {
    return [[ViewController2 alloc] initWithNibName:NSStringFromClass(ViewController2.class) bundle:nil];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
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

- (IBAction)goToNext:(id)sender {
    
    ViewController2 *viewController = [ViewController2 loadFromNib];
    
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        viewController.view.backgroundColor = [UIColor orangeColor];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


@end

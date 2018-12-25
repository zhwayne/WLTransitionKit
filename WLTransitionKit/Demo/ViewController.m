//
//  ViewController.m
//  WLTransitionKit
//
//  Created by wayne on 2018/12/1.
//  Copyright © 2018 com.zhwayne. All rights reserved.
//

#import "ViewController.h"
#import "WLTransitionKit.h"
#import "ViewController2.h"
#import "UIGestureRecognizer+BlockSupport.h"

@interface SelectorWrap : NSObject
@property (nonatomic) SEL sel;
+ (instancetype)wrapWithSEL:(SEL)sel;
@end

@implementation SelectorWrap
+ (instancetype)wrapWithSEL:(SEL)sel
{
    SelectorWrap *wrap =[SelectorWrap new];
    wrap.sel = sel;
    return wrap;
}
@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray <NSArray *>*items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Animators";
    // Do any additional setup after loading the view, typically from a nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView reloadData];
}

- (NSArray *)items {
    if (!_items) {
        _items = @[@[@"Flip", [SelectorWrap wrapWithSEL:@selector(_pushWithFlip)]],
                   @[@"Present card", [SelectorWrap wrapWithSEL:@selector(_pushWithPresentCard)]],
                   ];
    }
    
    return _items;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectorWrap *wrap = [self.items[indexPath.row] lastObject];
    [self performSelectorOnMainThread:wrap.sel withObject:nil waitUntilDone:NO];
}


#pragma mark -

- (void)_pushWithFlip {
    WLTransitionFlipAniamtor *animator = [WLTransitionFlipAniamtor new];
    animator.dammingColor = [UIColor whiteColor];
    ViewController2 *viewController = [ViewController2 loadFromNib];
    [self.navigationController wlt_pushViewController:viewController withTransitionAnimator:animator];
}

- (void)_pushWithPresentCard {
    WLTrasitionPresentCardAnimator *animator = [WLTrasitionPresentCardAnimator new];
    ViewController2 *viewController = [ViewController2 loadFromNib];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController wlt_presentViewController:viewController withTransitionAnimator:animator completion:^{
        
        UIPanGestureRecognizer *pan = [UIPanGestureRecognizer gestureRecognizerWitHandler:^(UIPanGestureRecognizer *pan) {
            if (pan.state == UIGestureRecognizerStateBegan) {
                [viewController wlt_beginInteractiveTransition];
            } else if (pan.state == UIGestureRecognizerStateChanged) {
                CGPoint location = [pan translationInView:pan.view];
                if (fabs(location.y) < 10) return;
                CGFloat percent = location.y / CGRectGetHeight(pan.view.bounds);
                [viewController wlt_updateInteractiveTransition:percent];
            } else {
                [viewController wlt_endInteractiveTransition];
            }
        }];

        [viewController.view addGestureRecognizer:pan];
    }];
}



@end

//
//  LTBaseVC.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "LTBaseVC.h"

@interface LTBaseVC ()

@end

@implementation LTBaseVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindView];
    [self bindLayout];
    [self bindData];
    [self bindAction];
}

- (void)bindView {}

- (void)bindLayout {}

- (void)bindData {}

- (void)bindAction {}

@end

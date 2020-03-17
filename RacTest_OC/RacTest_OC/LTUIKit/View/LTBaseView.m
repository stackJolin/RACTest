//
//  LTBaseView.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "LTBaseView.h"

@implementation LTBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self bindView];
        [self bindLayout];
        [self bindData];
        [self bindAction];
    }
    return self;
}

- (void)bindView {}

- (void)bindLayout {}

- (void)bindData {}

- (void)bindAction {}

@end

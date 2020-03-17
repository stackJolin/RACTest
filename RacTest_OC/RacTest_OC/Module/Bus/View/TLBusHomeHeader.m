//
//  TLBusHomeHeader.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "TLBusHomeHeader.h"
#import "TLBusHomeHeaderItem.h"

@interface TLBusHomeHeader()

@property (nonatomic, strong) LTBaseView *vBack;
@property (nonatomic, strong) UIImageView *ivBus;
@property (nonatomic, strong) UIImageView *ivLocation;
@property (nonatomic, strong) TLBusHomeHeaderItem *itemBus;
@property (nonatomic, strong) TLBusHomeHeaderItem *itemBusStation;

@end

@implementation TLBusHomeHeader

- (void)bindView {
    
}

- (void)bindLayout {
    
}

- (void)bindAction {
    
}

- (LTBaseView *)vBack {
    if (!_vBack) {
        _vBack = [LTBaseView new];
    }
    return _vBack;
}

- (UIImageView *)ivBus {
    if (!_ivBus) {
        _ivBus = [UIImageView new];
    }
    return _ivBus;
}

- (UIImageView *)ivLocation {
    if (!_ivLocation) {
        _ivLocation = [UIImageView new];
    }
    return _ivLocation;
}

- (TLBusHomeHeaderItem *)itemBus {
    if (!_itemBus) {
        _itemBus = [TLBusHomeHeaderItem new];
    }
    return _itemBus;
}

- (TLBusHomeHeaderItem *)itemBusStation {
    if (!_itemBusStation) {
        _itemBusStation = [TLBusHomeHeaderItem new];
    }
    return _itemBusStation;
}

@end

//
//  TLBusHomeHeader.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "TLBusHomeHeader.h"
#import "TLBusHomeHeaderItem.h"
#import "UIView+BlocksKit.h"
#import "UIView+Associate.h"

@interface TLBusHomeHeader()

@property (nonatomic, strong) LTBaseView          *vBack;

@property (nonatomic, strong) UIView              *vUp;
@property (nonatomic, strong) UIImageView         *ivBus;
@property (nonatomic, strong) UILabel             *lbTitle;
@property (nonatomic, strong) UIImageView         *ivLocation;

@property (nonatomic, strong) TLBusHomeHeaderItem *itemBus;
@property (nonatomic, strong) TLBusHomeHeaderItem *itemBusStation;

@property (nonatomic, copy) void (^testBlock)(id a);

@end

@implementation TLBusHomeHeader

- (void)bindView {
    [self addSubview:self.vBack];
    
    [self.vBack addSubViews:@[self.vUp, self.itemBus, self.itemBusStation]];
    
    [self.vUp addSubViews:@[self.ivBus, self.lbTitle, self.ivLocation]];
}

- (void)bindLayout {
    [self.vBack mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.inset(10);
    }];
    
    [self.vUp mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScaleW(40));
        make.left.right.top.equalTo(self.vBack);
    }];
    
    [self.ivBus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.height.width.mas_equalTo(ScaleW(30));
        make.centerY.equalTo(self.vUp);
    }];
    
    [self.ivLocation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(15));
        make.height.width.mas_equalTo(ScaleW(30));
        make.centerY.equalTo(self.vUp);
    }];
    
    [self.lbTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ivBus.mas_right).offset(10);
        make.right.equalTo(self.ivLocation.mas_left).offset(-10);
        make.centerY.equalTo(self.vUp);
    }];
    
    [self.itemBus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.vBack);
        make.top.equalTo(self.vUp.mas_bottom);
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    [self.itemBusStation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.vBack);
        make.top.equalTo(self.itemBus.mas_bottom);
        make.height.mas_equalTo(ScaleW(50));
    }];
}

- (void)bindAction {
//    [self.itemBus bk_whenTapped:^{
//        int a = 1;
//        b = 2;
//    }];
//    
//    [self.itemBusStation bk_whenTapped:^{
//        int b = 1;
//    }];
    
//    void (^test1Block)(id a) = ^(id a){
//
//    };
//    NSLog(@"zhuhoulin:Block1----%@\n", test1Block);
//
//    self.testBlock = [test1Block copy];
//    NSLog(@"zhuhoulin:Block2----%@\n", self.testBlock);
//
//    void (^test2Block)(id a) = self.testBlock;
//    NSLog(@"zhuhoulin:Block3----%@\n", test2Block);
    
    void (^block1)() = ^{
        
    };

    void (^block2)() = ^{
        
    };
    
    [self.itemBus bk_whenTapped:block1];

    [self.itemBusStation bk_whenTapped:block2];
}


- (LTBaseView *)vBack {
    if (!_vBack) {
        _vBack = [LTBaseView new];
    }
    return _vBack;
}

- (UIView *)vUp {
    if (!_vUp) {
        _vUp = [UIView new];
    }
    return _vUp;
}

- (UIImageView *)ivBus {
    if (!_ivBus) {
        _ivBus = [UIImageView new];
    }
    return _ivBus;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [UILabel new];
    }
    return _lbTitle;
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
        _itemBus.backgroundColor = UIColor.yellowColor;
    }
    return _itemBus;
}

- (TLBusHomeHeaderItem *)itemBusStation {
    if (!_itemBusStation) {
        _itemBusStation = [TLBusHomeHeaderItem new];
        _itemBusStation.backgroundColor = UIColor.redColor;
    }
    return _itemBusStation;
}

@end

//
//  TLBusHomeHeader.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "TLBusHomeHeader.h"

@class TLBusHomeHeaderItem;
@interface TLBusHomeHeader()


@property (nonatomic, strong) LTBaseView *vBack;
@property (nonatomic, strong) LTBaseView *vBack;
@property (nonatomic, strong) TLBusHomeHeaderItem *itemBus;
@property (nonatomic, strong) TLBusHomeHeaderItem *itemBusStation;

@end

@implementation TLBusHomeHeader


@end


//**********************************************************
// MARK : Class == TLBusHomeHeaderItem
//**********************************************************

@interface TLBusHomeHeaderItem : LTBaseView

@property (nonatomic, strong) LTBaseView       *hLine;
@property (nonatomic, strong) UITextField      *tf;
@property (nonatomic, strong) UIImageView      *ivArrow;
@property (nonatomic, strong) UILabel          *lbTitle;

@end

@implementation TLBusHomeHeaderItem

- (void)bindView {
    
    [self lt_addSubViews:@[self.lbTitle,
                           self.tf,
                           self.ivArrow,
                           self.hLine]];
}

- (void)bindLayout {
    
    [self.lbTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.tf mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.ivArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.hLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (LTBaseView *)hLine {
    if (!_hLine) {
        _hLine = [LTBaseView new];
    }
    return _hLine;
}

- (UITextField *)tf {
    if (!_tf) {
        _tf = [UITextField new];
    }
    return _tf;
}

- (UIImageView *)ivArrow {
    if (!_ivArrow) {
        _ivArrow = [UIImageView new];
    }
    return _ivArrow;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [UILabel new];
    }
    return _lbTitle;
}
@end

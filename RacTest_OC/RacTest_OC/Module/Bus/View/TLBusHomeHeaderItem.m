//
//  TLBusHomeHeaderItem.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "TLBusHomeHeaderItem.h"

@interface TLBusHomeHeaderItem()

@end

@implementation TLBusHomeHeaderItem

- (void)bindView {
    
    [self addSubViews:@[self.lbTitle,
                           self.tf,
                           self.ivArrow,
                           self.hLine]];
}

- (void)bindLayout {
    
    [self.lbTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(-ScaleW(15));
        make.top.bottom.equalTo(self);
    }];
    
    [self.tf mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbTitle.mas_right).offset(10);
        make.top.bottom.equalTo(self.lbTitle);
    }];
    
    [self.ivArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(15));
        make.width.height.mas_equalTo(ScaleW(20));
        make.centerY.equalTo(self);
    }];
    
    [self.hLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(ScaleW(15));
        make.right.mas_equalTo(ScaleW(15));
        make.bottom.equalTo(self);
    }];
}

- (void)bindAction {
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

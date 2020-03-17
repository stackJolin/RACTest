//
//  TLBusHomeHeaderItem.h
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "LTBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLBusHomeHeaderItem : LTBaseView

@property (nonatomic, strong) LTBaseView       *hLine;
@property (nonatomic, strong) UITextField      *tf;
@property (nonatomic, strong) UIImageView      *ivArrow;
@property (nonatomic, strong) UILabel          *lbTitle;

@end

NS_ASSUME_NONNULL_END

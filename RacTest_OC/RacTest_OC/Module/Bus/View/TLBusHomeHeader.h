//
//  TLBusHomeHeader.h
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "LTBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLBusHomeHeader : LTBaseView

@property (nonatomic, copy) void (^inputCallback)();

@end

NS_ASSUME_NONNULL_END

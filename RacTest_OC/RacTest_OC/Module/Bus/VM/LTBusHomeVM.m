//
//  LTBusHomeVM.m
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "LTBusHomeVM.h"

@implementation LTBusHomeVM

- (void)fetchAllBusLines:(void (^)(BOOL, NSString *))handler {
    
}

#pragma mark- Getter
- (NSArray<TLBusLineModel *> *)busLines {
    if (!_busLines) {
        _busLines = [NSArray<TLBusLineModel *> new];
    }
    return _busLines;
}

@end

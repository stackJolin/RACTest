//
//  LTBusHomeVM.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLBusLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTBusHomeVM : NSObject

@property (nonatomic, strong) NSArray<TLBusLineModel *> *busLines;

- (void)fetchAllBusLines:(void (^)(BOOL, NSString *))handler;

@end

NS_ASSUME_NONNULL_END

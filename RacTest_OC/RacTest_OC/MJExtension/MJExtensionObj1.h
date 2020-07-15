//
//  MJExtensionObj1.h
//  RacTest_OC
//
//  Created by houlin on 2020/7/2.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModelObj1.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJExtensionObj1 : NSObject

@property (nonatomic, assign) struct HHHHH stru;
@property (nonatomic, strong) MJExtensionObj1<DDDDDProtocol, JsonModelObj2> *proto1;
@property (nonatomic, strong) NSArray<MJExtensionObj1 *> *arr;
@property (nonatomic, strong) JsonModelObj2 *obj2;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *v;

@end

NS_ASSUME_NONNULL_END

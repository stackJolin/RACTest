//
//  JsonModelObj1.m
//  RacTest_OC
//
//  Created by houlin on 2020/7/1.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "JsonModelObj1.h"

@implementation JsonModelObj1

@end

@implementation JsonModelObj2


+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"index": @"",
        @"name": @"orderDetails.name"
    }];
}


@end

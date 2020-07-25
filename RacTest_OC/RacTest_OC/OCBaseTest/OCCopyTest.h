//
//  OCCopyTest.h
//  RacTest_OC
//
//  Created by houlin on 2020/7/24.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCopyTest : NSObject

@property(nonatomic , assign) NSObject *obj1;

@property(nonatomic , copy) OCCopyTest *obj2;

@property(nonatomic , weak) NSInteger adfd;

@property(nonatomic , copy) NSArray *arr1;
@property(nonatomic , copy) NSMutableArray *arr2;

@property(nonatomic , strong) NSArray *arr3;
@property(nonatomic , strong) NSMutableArray *arr4;


+ (void)copyTest;
+ (void)copySetTest;
+ (void)testPropertyCopy;

@end

NS_ASSUME_NONNULL_END

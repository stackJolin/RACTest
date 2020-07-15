//
//  JsonModelObj1.h
//  RacTest_OC
//
//  Created by houlin on 2020/7/1.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDDDDProtocol

@optional
- (void)fdsfdsfdsfdfdsf;

@end

struct HHHHH {
    NSObject *obj1;
};

@protocol JsonModelObj1;
@protocol JsonModelObj2;

@class JsonModelObj2;
@interface JsonModelObj1 : JSONModel

//@property (nonatomic, assign) struct HHHHH stru;
//@property (nonatomic, strong) JsonModelObj1<DDDDDProtocol, JsonModelObj2> *proto1;
//@property (nonatomic, strong) NSArray<JsonModelObj1> *arr;
//@property (nonatomic, strong) JsonModelObj2 *obj2;
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, strong) UIView *v;


@end

NS_ASSUME_NONNULL_END


@interface JsonModelObj2:NSObject<DDDDDProtocol>


- (void)fdsfdsfdsfdfdsf;

@end


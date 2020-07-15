//
//  KVCTestObject1.m
//  RacTest_OC
//
//  Created by houlin on 2020/7/1.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "KVCTestObject1.h"

@interface KVCTestObject1() {
    NSObject *_obj1;
    NSObject *_isObj1;
    NSObject *obj1;
    NSObject *isObj1;
}

@end

@implementation KVCTestObject1

- (void)setObj1:(id)obj1 {
    
}

- (void)_setObj1:(id)obj1 {
    
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

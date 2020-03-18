//
//  LTSingletonMacro.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#ifndef LTSingletonMacro_h
#define LTSingletonMacro_h

#define SharedH \
+ (id)shared;

#define SharedM \
+ (instance)shared \
{ \
    static dispatch_once_t onceToken; \
    static  id _singletonInstance = nil; \
    dispatch_once(&onceToken, ^{ \
        _singletonInstance = [[self alloc] init]; \
    }); \
    return _singletonInstance; \
} \

#endif /* LTSingletonMacro_h */

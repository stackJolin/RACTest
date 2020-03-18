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
static  id _singletonInstance = nil; \
+ (id)shared \
{ \
    return  [[self alloc] init]; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
     _singletonInstance = [super allocWithZone:zone]; \
    }); \
   return _singletonInstance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
    return _singletonInstance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
  return self; \
} \

#endif /* LTSingletonMacro_h */

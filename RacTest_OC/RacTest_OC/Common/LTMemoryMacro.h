//
//  LTMemoryMacro.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#ifndef LTMemoryMacro_h
#define LTMemoryMacro_h

#define wkSelf(obj) __weak __typeof(self)obj = self;
#define stSelf(obj) __strong __typeof(wkSelf) stSelf = wkSelf;

#endif /* LTMemoryMacro_h */

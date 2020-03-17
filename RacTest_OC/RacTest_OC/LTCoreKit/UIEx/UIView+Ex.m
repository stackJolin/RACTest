//
//  UIView+Ex.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "UIView+Ex.h"

@implementation UIView (Ex)

- (void)lt_addSubViews:(NSArray<UIView *> *)subViews {
    [subViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

@end

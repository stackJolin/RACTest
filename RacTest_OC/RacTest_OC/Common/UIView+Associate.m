//
//  UIView+Associate.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/23.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "UIView+Associate.h"
#import <objc/runtime.h>

static const void *UIViewNumKey = &UIViewNumKey;

@implementation UIView (Associate)

- (void)setNum:(NSNumber *)num {
    objc_setAssociatedObject(self, UIViewNumKey, num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)num {
    return objc_getAssociatedObject(self, UIViewNumKey);
}
@end

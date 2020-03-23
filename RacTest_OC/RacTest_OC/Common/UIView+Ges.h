//
//  UIView+Ges.h
//  RacTest_OC
//
//  Created by houlin on 2020/3/21.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Ges)

- (void)addTap:(void (^)(void))handler;
- (void)singleTap:(NSTimeInterval)interval handler:(void (^)(void))handler;
- (void)singleTap:(void (^)(void))handler;

- (void)addDoubleTapGes:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END

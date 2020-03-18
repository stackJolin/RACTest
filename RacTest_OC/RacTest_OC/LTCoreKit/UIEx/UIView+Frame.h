//
//  UIView+Frame.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat     width;
@property (nonatomic, assign) CGFloat     height;

@property (nonatomic, assign) CGFloat     left;
@property (nonatomic, assign) CGFloat     right;
@property (nonatomic, assign) CGFloat     top;
@property (nonatomic, assign) CGFloat     bottom;

@property (nonatomic, assign) CGFloat     centerX;
@property (nonatomic, assign) CGFloat     centerY;
@property (nonatomic, assign) CGSize      size;

@end

NS_ASSUME_NONNULL_END

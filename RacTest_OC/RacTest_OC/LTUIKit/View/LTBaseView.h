//
//  LTBaseView.h
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTBaseView : UIView

- (void)bindView;
- (void)bindLayout;
- (void)bindData;
- (void)bindAction;

@end

NS_ASSUME_NONNULL_END

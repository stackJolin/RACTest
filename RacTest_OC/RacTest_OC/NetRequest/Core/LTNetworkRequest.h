//
//  LTNetworkRequest.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTNetworkMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTNetworkRequest : NSObject

@property (nonatomic, copy) LTSuccessHandler _successHandler;
@property (nonatomic, copy) LTFinishHandler _finishHandler;
@property (nonatomic, copy) ;

///** 成功回调 */
//typedef void(^LTSuccessHandler)(id req);
///** 成功回调带数据 */
//typedef void(^LTSuccessRespHandler)(id req, id resp);
///** 成功带cache */
//typedef void(^LTSuccessCacheHandler)(id req, id resp, BOOL cache);
///** 数据回调 */
//typedef void(^LTDataHandler)(id obj, id resp);
///** 失败回调 */
//typedef void(^LTFaildHandler)(NSError * error);
///** 取消回调 */
//typedef void(^LTCancelHandler)();
///** 完成回调 */
//typedef void(^LTFinishHandler)();

@end

NS_ASSUME_NONNULL_END

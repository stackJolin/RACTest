//
//  LTNetworkMacro.h
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#ifndef LTNetworkMacro_h
#define LTNetworkMacro_h

/** 成功回调 */
typedef void(^LTSuccessHandler)(id req);
/** 成功回调带数据 */
typedef void(^LTSuccessRespHandler)(id req, id resp);
/** 成功带cache */
typedef void(^LTSuccessCacheHandler)(id req, id resp, BOOL cache);
/** 数据回调 */
typedef void(^LTDataHandler)(id obj, id resp);
/** 失败回调 */
typedef void(^LTFaildHandler)(NSError * error);
/** 取消回调 */
typedef void(^LTCancelHandler)();
/** 完成回调 */
typedef void(^LTFinishHandler)();

/** 数据模型转换 */
typedef id(^LTTurnModelHandle)(id obj);
typedef id(^LTTurnModelWithDataHandle)(id data, id obj);

#endif /* LTNetworkMacro_h */

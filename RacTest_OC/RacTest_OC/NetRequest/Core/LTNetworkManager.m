//
//  LTNetworkManager.m
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/18.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "LTNetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface LTNetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) dispatch_queue_t queueRequest;

@end

@implementation LTNetworkManager

SharedM;

- (instancetype)init {
    if (self = [super init]) {
        [self initSessionManager];
    }
}

- (void)initSessionManager {
    _sessionManager = [AFHTTPSessionManager manager];
    // 请求超时时间
    _sessionManager.requestSerializer.timeoutInterval = 20.f;
    _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    // 服务器返回的结果类型
    _sessionManager.requestSerializer = [AFJSONResponseSerializer serializer];
    _sessionManager.requestSerializer.accessibilityContainerType = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpg", nil];
}

- (void)initRequestQueue {
    _queueRequest = dispatch_queue_create("com.zhuhoulin.www.handler.queue", DISPATCH_QUEUE_SERIAL);
}

@end

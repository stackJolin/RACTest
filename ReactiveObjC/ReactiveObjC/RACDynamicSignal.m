//
//  RACDynamicSignal.m
//  ReactiveObjC
//
//  Created by Justin Spahr-Summers on 2013-10-10.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACDynamicSignal.h"
#import <ReactiveObjC/RACEXTScope.h>
#import "RACCompoundDisposable.h"
#import "RACPassthroughSubscriber.h"
#import "RACScheduler+Private.h"
#import "RACSubscriber.h"
#import <libkern/OSAtomic.h>

@interface RACDynamicSignal ()

// The block to invoke for each subscriber.
@property (nonatomic, copy, readonly) RACDisposable * (^didSubscribe)(id<RACSubscriber> subscriber);

@end

@implementation RACDynamicSignal

#pragma mark Lifecycle

+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe {
	RACDynamicSignal *signal = [[self alloc] init];
    signal->_didSubscribe = [didSubscribe copy];
    return [signal setNameWithFormat:@"+createSignal:"];
}

#pragma mark Managing Subscribers

/// 给信号添加订阅者
- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
	NSCParameterAssert(subscriber != nil);

	RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
    
    // 真正订阅信号的订阅者
	subscriber = [[RACPassthroughSubscriber alloc] initWithSubscriber:subscriber signal:self disposable:disposable];
    
	if (self.didSubscribe != NULL) { // 如果信号存在事件
        // 调度器会调度执行block
		RACDisposable *schedulingDisposable = [RACScheduler.subscriptionScheduler schedule:^{
			RACDisposable *innerDisposable = self.didSubscribe(subscriber);
			[disposable addDisposable:innerDisposable];
		}];
        
		[disposable addDisposable:schedulingDisposable];
	}
	
	return disposable;
}

@end

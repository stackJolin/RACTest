//
//  RACTargetQueueScheduler.m
//  ReactiveObjC
//
//  Created by Josh Abernathy on 6/6/13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACTargetQueueScheduler.h"
#import "RACQueueScheduler+Subclass.h"

@implementation RACTargetQueueScheduler

#pragma mark Lifecycle

- (instancetype)initWithName:(NSString *)name targetQueue:(dispatch_queue_t)targetQueue {
	NSCParameterAssert(targetQueue != NULL);

	if (name == nil) {
		name = [NSString stringWithFormat:@"org.reactivecocoa.ReactiveObjC.RACTargetQueueScheduler(%s)", dispatch_queue_get_label(targetQueue)];
	}

	dispatch_queue_t queue = dispatch_queue_create(name.UTF8String, DISPATCH_QUEUE_SERIAL);
	if (queue == NULL) return nil;

    // dispatch_set_target_queue
    // 用法一：指定优先级
    // 用法二：队列执行。场景：不同队列B,B,D中的任务，需要同步的执行。这个时候创建一个串行队列A，然后使用dispatch_set_target_queue(A, B/C/D)函数。bcd中的内务就会串行的执行
    
    // 设置队列的优先级
    dispatch_set_target_queue(queue, targetQueue);

	return [super initWithName:name queue:queue];
}

@end

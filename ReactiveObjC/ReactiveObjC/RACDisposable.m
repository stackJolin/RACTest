//
//  RACDisposable.m
//  ReactiveObjC
//
//  Created by Josh Abernathy on 3/16/12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

#import "RACDisposable.h"
#import "RACScopedDisposable.h"
#import <libkern/OSAtomic.h>

@interface RACDisposable () {
	// A copied block of type void (^)(void) containing the logic for disposal,
	// a pointer to `self` if no logic should be performed upon disposal, or
	// NULL if the receiver is already disposed.
	//
	// This should only be used atomically.
	void * volatile _disposeBlock;
}

@end

@implementation RACDisposable

#pragma mark Properties

- (BOOL)isDisposed {
	return _disposeBlock == NULL;
}

#pragma mark Lifecycle

- (instancetype)init {
	self = [super init];

    // 如果没有block，block会指向自己。为了避免循环引用，这里使用了void *，如果使用id，那么会造成循环引用
	_disposeBlock = (__bridge void *)self;
	OSMemoryBarrier();

	return self;
}

- (instancetype)initWithBlock:(void (^)(void))block {
	NSCParameterAssert(block != nil);

	self = [super init];

	_disposeBlock = (void *)CFBridgingRetain([block copy]);
    // 此处为什么要转换成C函数 -> 转成C函数后，可以拿到函数指针，拿到函数指针就可以进行重定向。此处将oc函数转换成了C函数，同时，ARC转成了MRC，需要手动释放内存，注意dealloc中的CFRelease函数
    
	OSMemoryBarrier();
    // 内存屏障
    // 程序的实际运行时可能并不会完全按照开发者编写的顺序访问内存
    // 编译器和CPU都可能引起内存乱序的问题：编译时，编译器优化进行指令重排而导致内存的乱序访问；运行时，多CPU间交互引用内存乱序访问。因此，内存屏障包括两类：编译器屏障和CPU内存屏障
    // https://blog.csdn.net/u012233832/article/details/79619648
    // https://www.cnblogs.com/straybirds/p/8856726.html
    // https://www.cnblogs.com/straybirds/p/8856726.html

	return self;
}

+ (instancetype)disposableWithBlock:(void (^)(void))block {
	return [(RACDisposable *)[self alloc] initWithBlock:block];
}

- (void)dealloc {
    // 为空 或者 等于 自身，都不需要额外的释放或者设置为NULL
	if (_disposeBlock == NULL || _disposeBlock == (__bridge void *)self) return;

    // 释放内存
	CFRelease(_disposeBlock);
    // 避免野指针
	_disposeBlock = NULL;
}

#pragma mark Disposal

- (void)dispose {
	void (^disposeBlock)(void) = NULL;

	while (YES) {
		void *blockPtr = _disposeBlock;
        
		if (OSAtomicCompareAndSwapPtrBarrier(blockPtr, NULL, &_disposeBlock)) {
            // 如果block存在
			if (blockPtr != (__bridge void *)self) {
                // __bridge                             内存管理者不切换
                // __bridge_transfer/CFBridgingRelease  内存管理者进行切换   把CF对象转换成NS对象，并且内存管理者切换
                // __bridge_retained/CFBridgingRetain   内存管理者进行切换   把NS对象转换成CF对象，并且内存管理者切换
				disposeBlock = CFBridgingRelease(blockPtr);
			}

			break;
		}
	}

    // ARC下的block，执行完毕后会自动释放
	if (disposeBlock != nil) disposeBlock();
}

#pragma mark Scoped Disposables

- (RACScopedDisposable *)asScopedDisposable {
	return [RACScopedDisposable scopedDisposableWithDisposable:self];
}

@end

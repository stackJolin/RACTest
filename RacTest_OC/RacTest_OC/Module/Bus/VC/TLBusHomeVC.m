//
//  TLBusHomeVC.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "TLBusHomeVC.h"
#import "TLBusHomeHeader.h"
#import "KVCTestObject1.h"
#import "JsonModelObj1.h"
#import <MJExtension/MJExtension.h>
#import "MJExtensionObj1.h"
#import <objc/message.h>
#import <YYKit/NSObject+YYModel.h>
#import <VKURLAction/VKMsgSend.h>
#import "OCCopyTest.h"
#import "OCBlockTest.h"

@interface TLBusHomeVC()

@property (nonatomic, strong) UITableView     *vTable;
@property (nonatomic, strong) TLBusHomeHeader *vHeader;
@property (nonatomic, retain) NSMapTable *nMap;


@end

@implementation TLBusHomeVC

- (void)bindView {
    self.view.backgroundColor = UIColor.whiteColor;
    
    [OCCopyTest testPropertyCopy];
    

    OCBlockTest *a = [OCBlockTest new];
    
//    dispatch_queue_t serialQueue = dispatch_queue_create("Dan-serial", DISPATCH_QUEUE_SERIAL);
//    for(int i = 0; i < 5; i++){
//        dispatch_sync(serialQueue, ^{
//                NSLog(@"我开始了：%@ , %@",@(i),[NSThread currentThread]);
//                [NSThread sleepForTimeInterval: i % 3];
//        });
//    }
//
//    NSObject *b = [NSObject new];
//
//    void (^testBlock)(void) = ^{
//        NSLog(@"Integer is: %i", b);
//        self = [TLBusHomeVC new];
//    };
//    testBlock();
    
//    static CFMutableDictionaryRef cache1;
//    cache1 = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
//
//    NSObject *a = CFDictionaryGetValue(cache1, (__bridge const void *)([UIViewController class]));
//
//    MJExtensionObj1 *obj4 = [MJExtensionObj1 yy_modelWithJSON:@"{\"name\":\"fdf\"}"];
//
//    KVCTestObject1 *obj1 = [KVCTestObject1 new];
//    [obj1 setValue:@"fd" forUndefinedKey:@"obj1"];
//
//    NSError *err;
//    [self VKCallSelector:@selector(clickSelf) error:&err, 0, 1, "String"];
//
//    NSString *title = @"{\"name\":\"fdf\"}";
//
//    JsonModelObj1 *obj2 = [[JsonModelObj1 alloc] initWithString:title error:nil];
//
//    MJExtensionObj1 *obj3 = [MJExtensionObj1 mj_setKeyValues:title];
//
//    NSObject * objc3 = [NSObject new];
//
//    self.nMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
    
//    [self.view addSubview:self.vTable];
//    self.vTable.tableHeaderView = self.vHeader;
//
//
//    RACSignal *s = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//
//        [subscriber sendNext:@(0)];
//
//        [subscriber sendError:nil];
//
//        [subscriber sendCompleted];
//
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"订阅被取消了");
//        }];
//    }];
//
//    // 一次性添加三个事件(next，error，completed)的订阅者，这种只是创建了一个订阅者
//    [s subscribeNext:^(id  _Nullable x) {
//
//    } error:^(NSError * _Nullable error) {
//
//    } completed:^{
//
//    }];
//
//    // 添加Next事件的订阅者
//    [s subscribeNext:^(id  _Nullable x) {
//
//    }];
//
//    // 添加Error事件的订阅者
//    [s subscribeError:^(NSError * _Nullable error) {
//
//    }];
//
//    // 添加Completed事件的订阅者
//    [s subscribeCompleted:^{
//
//    }];
}

- (void)bindLayout {
//    [self.vTable mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}

- (void)bindData {
    
}

- (void)bindAction {

}

#pragma mark- Getter

- (UITableView *)vTable {
    if (!_vTable) {
        _vTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _vTable.backgroundColor = UIColor.whiteColor;
    }
    return _vTable;
}

- (TLBusHomeHeader *)vHeader {
    if (!_vHeader) {
        _vHeader = [TLBusHomeHeader new];
        _vHeader.height = ScaleW(140);
    }
    return _vHeader;
}

@end

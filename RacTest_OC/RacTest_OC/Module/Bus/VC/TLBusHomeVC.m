//
//  TLBusHomeVC.m
//  RacTest_OC
//
//  Created by houlin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "TLBusHomeVC.h"
#import "TLBusHomeHeader.h"

@interface TLBusHomeVC()

@property (nonatomic, strong) UITableView     *vTable;
@property (nonatomic, strong) TLBusHomeHeader *vHeader;

@end

@implementation TLBusHomeVC

- (void)bindView {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.vTable];
    self.vTable.tableHeaderView = self.vHeader;
    
    
    RACSignal *s = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@(0)];
       
        [subscriber sendError:nil];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"订阅被取消了");
        }];
    }];
    
    // 一次性添加三个事件(next，error，completed)的订阅者，这种只是创建了一个订阅者
    [s subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    
    // 添加Next事件的订阅者
    [s subscribeNext:^(id  _Nullable x) {
        
    }];
    
    // 添加Error事件的订阅者
    [s subscribeError:^(NSError * _Nullable error) {
        
    }];
    
    // 添加Completed事件的订阅者
    [s subscribeCompleted:^{
        
    }];
}

- (void)bindLayout {
    [self.vTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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

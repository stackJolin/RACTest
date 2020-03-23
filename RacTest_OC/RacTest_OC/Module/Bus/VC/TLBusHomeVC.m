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

//
//  OCBlockTest.m
//  RacTest_OC
//
//  Created by houlin on 2020/7/29.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "OCBlockTest.h"

typedef void(^MyBlock)(void);
int b = 100;

MyBlock testFunc() {
    int a = 10;
    return ^ {
        NSLog(@"test --- %d",a);
    };
}


@implementation OCBlockTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self test02];
    }
    return self;
}

- (void)test02 {
    NSLog(@"%@", testFunc());
}

- (void)test01 {
    int a = 10;

    // 打印了一个 NSStackBlock
    NSLog(@"%@",^ {
        int b = a;
    });

    __weak id obj1;
    obj1 = ^(){
        int b = a;
    };
    NSLog(@"%@", obj1);
    
    id obj2;
    obj2 = ^(){
        int b = a;
    };

    NSLog(@"%@",obj2);
}

@end

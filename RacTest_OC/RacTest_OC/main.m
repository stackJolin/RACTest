//
//  main.m
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
//#import "OCCopyTest.h"
#import <Foundation/NSObject.h>

//int main(int argc, char * argv[]) {
//    NSString * appDelegateClassName;
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//        appDelegateClassName = NSStringFromClass([AppDelegate class]);
//
//    }
//    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
//}

@interface A:NSObject {
    
}

@end

@implementation A


@end

@interface B:A {
    
}

@end

@implementation B


@end

@interface C:B {
    
}

@end

@implementation C


@end


int main(int argc, char * argv[]) {
    @autoreleasepool {
//        __block int d = 10;
//        ^(int a) {
//            int b = a;
//            d = 20;
//        };
        
        A *a = [A new];
        B *b = [B new];
        C *c = [C new];

    }
    return 0;
}

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

//int main(int argc, char * argv[]) {
//    NSString * appDelegateClassName;
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//        appDelegateClassName = NSStringFromClass([AppDelegate class]);
//
//    }
//    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
//}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        __block int d = 10;
        ^(int a) {
            int b = a;
            d = 20;
        };
        
    }
    return 0;
}

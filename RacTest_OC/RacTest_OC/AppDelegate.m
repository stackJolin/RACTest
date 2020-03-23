//
//  AppDelegate.m
//  RacTest_OC
//
//  Created by zhuhoulin on 2020/3/17.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "AppDelegate.h"
#import "TLBusHomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window = window;
    window.backgroundColor = UIColor.whiteColor;
    
    TLBusHomeVC *vc = [TLBusHomeVC new];
//    UIViewController *vc = [UIViewController new];
    
    window.rootViewController = vc;
    
    [window makeKeyAndVisible];
    
    return YES;
}

@end

//
//  OCCopyTest.m
//  RacTest_OC
//
//  Created by houlin on 2020/7/24.
//  Copyright © 2020 $(PRODUCT_NAME). All rights reserved.
//

#import "OCCopyTest.h"

@implementation OCCopyTest

+ (void)copyTest {
    
    NSString *str = @"testStrfdfdssddsfdsfds";
    
    // NSString copy
    NSString *str1 = [str copy];
    
    // NSString mutableCopy
    NSMutableString *str2 = [str mutableCopy];
    [str2 appendString:@"fdfd"];
    
    NSMutableString *str3 = [NSMutableString stringWithString:str];
    // NSMutableString copy
    NSMutableString *str4 = [str3 copy];
    // 这里会crash掉，所以str4并不是一个可变类型
//    [str4 appendString:@"fdfd"];
    
    // NSMutableString mutableCopy
    NSMutableString *str5 = [str3 mutableCopy];
    [str5 appendString:@"fdsfdsf"];
    
    NSLog(@"\nstr-变量地址：%p，字符串地址：%p，类型：%@ \
          \nstr1-变量地址：%p，字符串地址：%p，类型：%@ \
          \nstr2-变量地址：%p，字符串地址：%p，类型：%@ \
          \nstr3-变量地址：%p，字符串地址：%p，类型：%@ \
          \nstr4-变量地址：%p，字符串地址：%p，类型：%@ \
          \nstr5-变量地址：%p，字符串地址：%p，类型：%@",
          &str, str, [str class],
          &str1, str1, [str1 class],
          &str2, str2, [str2 class],
          &str3, str3, [str3 class],
          &str4, str4, [str4 class],
          &str5, str5, [str5 class]);
}

+ (void)copySetTest {
    
    NSArray *arr = @[@1, @2, @3, @4];
    
    NSArray *arr1 = [arr copy];
    
    NSMutableArray *arr2 = [arr mutableCopy];
    [arr2 addObject:@2];
    
    NSMutableArray *arr3 = [NSMutableArray arrayWithArray:arr];
    
    NSMutableArray *arr4 = [arr3 copy];
    // 这里会崩溃，说明生成的是不可变的
    // [arr4 addObject:@6];
    
    NSMutableArray *arr5 = [arr3 mutableCopy];
    [arr5 addObject:@6];
    
    NSLog(@"\narr-变量地址：%p，数组地址：%p，类型：%@ ，第一个元素的地址：%p \
          \narr1-变量地址：%p，数组地址：%p，类型：%@ ，第一个元素的地址：%p \
          \narr2-变量地址：%p，数组地址：%p，类型：%@ 第一个元素的地址：%p \
          \narr3-变量地址：%p，数组地址：%p，类型：%@ 第一个元素的地址：%p \
          \narr4-变量地址：%p，数组地址：%p，类型：%@ 第一个元素的地址：%p \
          \narr5-变量地址：%p，数组地址：%p，类型：%@ 第一个元素的地址：%p ",
          &arr, arr, [arr class], arr[0],
          &arr1, arr1, [arr1 class], arr1[0],
          &arr2, arr2, [arr2 class], arr2[0],
          &arr3, arr3, [arr3 class], arr3[0],
          &arr4, arr4, [arr4 class], arr4[0],
          &arr5, arr5, [arr5 class], arr5[0]);
}

+ (void)testPropertyCopy {
    OCCopyTest *test1 = [OCCopyTest new];
    test1.arr1 = @[@1, @2];
    test1.arr2 = [NSMutableArray arrayWithArray:@[@1, @2]];
    
    test1.arr3 = @[@1, @2, @3];
    test1.arr4 = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    
    NSArray *arr1 = @[@1, @2, @3, @4];
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5]];;
    
    test1.arr1 = arr1;
//    test1.arr2 = [arr2 copy];
    test1.arr2 = arr2;
    // 这里会崩溃，说明copy关键字，就是对被复制的对象执行了一下copy方法，也就是 test1._arr2 = [arr2 copy]
    // [test1.arr2 addObject:@[@0]];
    
    test1.arr3 = arr1;
//    test1.arr4 = [arr2 copy];
    test1.arr4 = arr2;
    [test1.arr4 addObject:@[@0]];
    
    NSLog(@"\n原地址：arr1:%p, arr2:%p\n", arr1, arr2);
    
    NSLog(@"\ntest1.arr1-地址：%p，类型：%@ ，第一个元素的地址：%p \
          \ntest1.arr2-地址：%p，类型：%@ ，第一个元素的地址：%p \
          \ntest1.arr3-地址：%p，类型：%@ 第一个元素的地址：%p \
          \ntest1.arr4-地址：%p，类型：%@ 第一个元素的地址：%p",
          test1.arr1, [test1.arr1 class], test1.arr1[0],
          test1.arr2, [test1.arr2 class], test1.arr2[0],
          test1.arr3, [test1.arr3 class], test1.arr3[0],
          test1.arr4, [test1.arr4 class], test1.arr4[0]);
}

@end

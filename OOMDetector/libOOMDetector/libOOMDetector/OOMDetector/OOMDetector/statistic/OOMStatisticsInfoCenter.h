//
//  OOMStatisticsInfoCenter.h
//  QQLeak
//
//  Tencent is pleased to support the open source community by making OOMDetector available.
//  Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
//  Licensed under the MIT License (the "License"); you may not use this file except
//  in compliance with the License. You may obtain a copy of the License at
//
//  http://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//
//

#ifndef OOMStaticsInfoCenter_h
#define OOMStaticsInfoCenter_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^StatisticsInfoBlock)(NSInteger memorySize_M);

@interface OOMStatisticsInfoCenter : NSObject

+(OOMStatisticsInfoCenter *)getInstance;

-(void)startMemoryOverFlowMonitor:(double)overFlowLimit;

-(void)stopMemoryOverFlowMonitor;

@property (nonatomic, copy) StatisticsInfoBlock statisticsInfoBlock;

- (void)showMemoryIndicatorView:(BOOL)yn;
- (void)setupMemoryIndicatorFrame:(CGRect)frame;

-(void)updateMemory;

@end

#endif /* OOMStaticsInfoCenter_h */

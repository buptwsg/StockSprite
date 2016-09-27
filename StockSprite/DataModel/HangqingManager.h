//
//  HangqingManager.h
//  StockSprite
//
//  Created by wang shuguang on 16/9/22.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHangqingDidRefreshNotification;

@class HangqingData;

//该类负责管理并更新行情数据
@interface HangqingManager : NSObject

- (void)refreshHangqing;

- (NSUInteger)numberOfStocks;

- (HangqingData*)getDataAtIndex: (NSInteger)index;

@end

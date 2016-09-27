//
//  HangqingData.h
//  StockSprite
//
//  Created by wang shuguang on 16/9/20.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HangqingData : NSObject

@property (nonatomic, copy) NSString *stockCode;
@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *currentPrice;
@property (nonatomic, copy) NSString *delta;//涨跌额
@property (nonatomic, copy) NSString *deltaPercent;//涨跌幅
@property (nonatomic, copy) NSString *rangePercent;//振幅
@property (nonatomic, copy) NSString *todayOpenPrice;
@property (nonatomic, copy) NSString *yesterdayClosePrice;
@property (nonatomic, copy) NSString *highestPrice;
@property (nonatomic, copy) NSString *lowestPrice;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *money;

- (void)initFromString: (NSString*)str;

@end

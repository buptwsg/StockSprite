//
//  HangqingData.m
//  StockSprite
//
//  Created by wang shuguang on 16/9/20.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "HangqingData.h"

@implementation HangqingData

- (void)initFromString:(NSString *)str {
    NSString *data = [str componentsSeparatedByString: @"="][1];
    data = [data substringWithRange: NSMakeRange(1, data.length - 3)];
    NSArray<NSString*> *components = [data componentsSeparatedByString: @","];
    
    self.stockName = components[0];
    self.todayOpenPrice = components[1];
    self.yesterdayClosePrice = components[2];
    self.currentPrice = components[3];
    
    float current = [self.currentPrice floatValue];
    float lastClose = [self.yesterdayClosePrice floatValue];
    self.delta = [NSString stringWithFormat: @"%.2f", current - lastClose];
    self.deltaPercent = [NSString stringWithFormat: @"%.2f%%", 100 * (current - lastClose) / lastClose];
    self.highestPrice = components[4];
    self.lowestPrice = components[5];
    self.volume = components[8];
    self.money = components[9];
    
    float highest = [self.highestPrice floatValue];
    float lowest = [self.lowestPrice floatValue];
    self.rangePercent = [NSString stringWithFormat: @"%.2f%%", 100 * (highest - lowest) / lastClose];
}

- (NSString*)description {
    return [NSString stringWithFormat: @"prefix: %@, code: %@, name: %@, current price: %@, delta: %@, deltaPercent: %@, rangePercent: %@, open price: %@, close price: %@, highest: %@, lowest: %@, volume: %@, money: %@", self.prefix, self.stockCode, self.stockName, self.currentPrice, self.delta, self.deltaPercent, self.rangePercent, self.todayOpenPrice, self.yesterdayClosePrice, self.highestPrice, self.lowestPrice, self.volume, self.money];
}
@end

//
//  AppPreference.h
//  StockSprite
//
//  Created by wang shuguang on 16/9/20.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, StockDetailMask) {
    StockDetailTodayOpenPrice = 1 << 0,
    StockDetailYesterdayClosePrice = 1 << 1,
    StockDetailHighest = 1 << 2,
    StockDetailLowest = 1 << 3,
    StockDetailVolume = 1 << 4,
    StockDetailMoney = 1 << 5,
};

#define Preference [AppPreference sharedInstance]

@interface AppPreference : NSObject<NSCoding>

@property (nonatomic) BOOL transparentBackground;
@property (nonatomic) StockDetailMask detailMask;
@property (nonatomic) int refreshInterval;

+ (AppPreference*)sharedInstance;

- (void)save;

@end

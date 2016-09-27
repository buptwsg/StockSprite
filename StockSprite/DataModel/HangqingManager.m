//
//  HangqingManager.m
//  StockSprite
//
//  Created by wang shuguang on 16/9/22.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "HangqingManager.h"
#import "ChoicesManager.h"
#import "HangqingData.h"

NSString * const kHangqingDidRefreshNotification = @"kHangqingDidRefreshNotification";

@interface HangqingManager ()

@property (nonatomic, strong) NSArray<HangqingData*> *dataArray;
@property (nonatomic, strong) NSMutableString *strUrl;

@end

@implementation HangqingManager

-(instancetype)init {
    self = [super init];
    if (self) {
        NSUInteger numberOfChoices = [[ChoicesManager sharedInstance] numberOfChoices];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity: numberOfChoices];
        for (NSUInteger i = 0; i < numberOfChoices; ++i) {
            NSDictionary *choice = [[ChoicesManager sharedInstance] getChoiceAtIndex: i];
            HangqingData *data = [[HangqingData alloc] init];
            data.stockCode = choice[kStockCodeKey];
            data.stockName = choice[kStockNameKey];
            data.prefix = choice[kPrefixKey];
            [tempArray addObject: data];
        }
        
        self.dataArray = [NSArray arrayWithArray: tempArray];
    }
    
    return self;
}

- (void)refreshHangqing {
    NSLog(@"Hangqing Manager, refresh hangqing");
    if (nil == self.strUrl) {
        NSMutableString *strUrl = [NSMutableString stringWithString: @"http://hq.sinajs.cn/list="];
        for (NSUInteger i = 0; i < self.dataArray.count; i++) {
            HangqingData *data = self.dataArray[i];
            if (i != self.dataArray.count - 1) {
                [strUrl appendFormat: @"%@%@,", data.prefix, data.stockCode];
            }
            else {
                [strUrl appendFormat: @"%@%@", data.prefix, data.stockCode];
            }
        }
        
        self.strUrl = strUrl;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: self.strUrl]];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"refresh hanging error: %@", error);
            return;
        }
        
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData: data encoding: gbkEncoding];
        [self refreshData: responseStr];
    }];
    
    [dataTask resume];
}

- (NSUInteger)numberOfStocks {
    return [self.dataArray count];
}

- (HangqingData*)getDataAtIndex: (NSInteger)index {
    if (index < self.dataArray.count) {
        return self.dataArray[index];
    }
    
    return nil;
}

- (void)refreshData: (NSString*)response {
    NSArray *stockDataArray = [response componentsSeparatedByString: @"\n"];
    for (NSUInteger i = 0; i < stockDataArray.count; i++) {
        NSString *item = stockDataArray[i];
        if (item.length > 0) {
            [self.dataArray[i] initFromString: item];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName: kHangqingDidRefreshNotification object: nil];
    });
}

@end

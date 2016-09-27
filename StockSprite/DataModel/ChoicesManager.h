//
//  ChoicesManager.h
//  StockSprite
//
//  Created by wang shuguang on 16/8/25.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kStockCodeKey;
extern NSString * const kStockNameKey;
extern NSString * const kPrefixKey;

@interface ChoicesManager : NSObject

+ (ChoicesManager*) sharedInstance;

- (NSInteger)searchStock: (NSString*)code prefix: (NSString*)prefix;

- (void) addStock: (NSString*)code name: (NSString*)name prefix: (NSString*)prefix;

- (void) removeStock: (NSString*)code prefix: (NSString*)prefix;

- (void)removeStockAtIndex: (NSInteger)index;

- (NSUInteger) numberOfChoices;

- (NSDictionary*) getChoiceAtIndex: (NSUInteger)index;

- (void)insertChoice: (NSDictionary*)choice atIndex: (NSUInteger)index;

- (void) save;

@end

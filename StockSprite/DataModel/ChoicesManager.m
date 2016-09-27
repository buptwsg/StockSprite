//
//  ChoicesManager.m
//  StockSprite
//
//  Created by wang shuguang on 16/8/25.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "ChoicesManager.h"

NSString * const kStockCodeKey = @"code";
NSString * const kStockNameKey = @"name";
NSString * const kPrefixKey = @"prefix";

@implementation ChoicesManager
{
    NSMutableArray *_choicesArray;
}

+ (ChoicesManager*) sharedInstance {
    static ChoicesManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ChoicesManager alloc] init];
    });
    
    return instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        NSString *dir = [self getSaveDir];
        NSString *path = [self getSaveFileName];
        [[NSFileManager defaultManager] createDirectoryAtPath: dir withIntermediateDirectories:YES attributes: nil error: nil];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
            _choicesArray = [NSMutableArray arrayWithContentsOfFile: path];
        }
        else {
            NSString *initPath = [[NSBundle mainBundle] pathForResource: @"InitStocks" ofType: @"plist"];
            _choicesArray = [NSMutableArray arrayWithContentsOfFile: initPath];
            [_choicesArray writeToFile: path atomically: YES];
        }
    }
    
    return self;
}

- (NSInteger)searchStock:(NSString *)code prefix:(NSString *)prefix {
    NSInteger foundIndex = -1;
    for (NSUInteger index = 0; index < _choicesArray.count; ++index) {
        NSDictionary *dict = (NSDictionary*)_choicesArray[index];
        if ([dict[kStockCodeKey] isEqualToString: code] && [dict[kPrefixKey] isEqualToString: prefix]) {
            foundIndex = index;
            break;
        }
    }
    
    return foundIndex;
}

- (void) addStock:(NSString *)code name:(NSString *)name prefix:(NSString *)prefix {
    NSDictionary *dict = @{kStockCodeKey : code, kStockNameKey : name , kPrefixKey : prefix};
    [_choicesArray addObject: dict];
}

- (void) removeStock:(NSString *)code prefix:(NSString *)prefix {
    NSInteger foundIndex = [self searchStock: code prefix: prefix];
    if (-1 != foundIndex) {
        [_choicesArray removeObjectAtIndex: foundIndex];
    }
}

-(void)removeStockAtIndex:(NSInteger)index {
    if (index >= 0 && index < _choicesArray.count) {
        [_choicesArray removeObjectAtIndex: index];
    }
}

- (NSUInteger) numberOfChoices {
    return _choicesArray.count;
}

- (NSDictionary*) getChoiceAtIndex: (NSUInteger)index {
    if (index < _choicesArray.count) {
        return _choicesArray[index];
    }
    
    return nil;
}

- (void)insertChoice:(NSDictionary *)choice atIndex:(NSUInteger)index {
    [_choicesArray insertObject: choice atIndex: index];
}

- (void) save {
    [_choicesArray writeToFile: [self getSaveFileName] atomically: YES];
}

- (NSString*) getSaveDir {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *dir = [docDir stringByAppendingPathComponent: bundleId];
    
    return dir;
}

- (NSString*) getSaveFileName {
    NSString *dir = [self getSaveDir];
    NSString *path = [dir stringByAppendingPathComponent: @"choices.plist"];
    return path;
}

@end

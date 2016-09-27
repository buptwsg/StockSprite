//
//  AppPreference.m
//  StockSprite
//
//  Created by wang shuguang on 16/9/20.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "AppPreference.h"

static NSString * const kBackgroundKey = @"transparentBackground";
static NSString * const kDetailMaskKey = @"stockDetailMask";
static NSString * const kRefreshIntervalKey = @"refreshInterval";

@implementation AppPreference

+ (AppPreference*)sharedInstance {
    static AppPreference *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *archiveFile = [self archiveFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath: archiveFile]) {
            instance = [NSKeyedUnarchiver unarchiveObjectWithFile: archiveFile];
        }
        else {
            instance = [[self alloc] init];
        }
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _transparentBackground = NO;
        _detailMask = 0;
        _refreshInterval = 3;
    }
    
    return self;
}

- (void)save {
    [NSKeyedArchiver archiveRootObject: self toFile: [[self class] archiveFilePath]];
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _transparentBackground = [aDecoder decodeBoolForKey: kBackgroundKey];
        _detailMask = [aDecoder decodeIntegerForKey: kDetailMaskKey];
        _refreshInterval = [aDecoder decodeIntForKey: kRefreshIntervalKey];
        
        if (0 == _refreshInterval) {
            _refreshInterval = 3;
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool: _transparentBackground forKey: kBackgroundKey];
    [aCoder encodeInteger: _detailMask forKey: kDetailMaskKey];
    [aCoder encodeInt: _refreshInterval forKey: kRefreshIntervalKey];
}

+ (NSString*)archiveFilePath {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *dir = [docDir stringByAppendingPathComponent: bundleId];
    
    return [dir stringByAppendingPathComponent: @"preferences.bin"];
}

@end

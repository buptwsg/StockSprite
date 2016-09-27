//
//  AppDelegate.m
//  StockSprite
//
//  Created by wang shuguang on 16/8/4.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "AppDelegate.h"
#import "ChoicesManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [ChoicesManager sharedInstance];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

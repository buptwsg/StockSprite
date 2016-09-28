//
//  MenuController.m
//  StockSprite
//
//  Created by wang shuguang on 16/8/4.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//
#import <MASShortcut/Shortcut.h>

#import "MenuController.h"
#import "AppPreference.h"

extern NSString *const kPreferenceGlobalShortcut;

@interface MenuController ()

@property (weak) IBOutlet NSMenu *menu;

@end

@implementation MenuController
{
    NSStatusItem *_statusItem;
    NSWindowController *_settingWindowController;
    NSWindowController *_hangqingWindowController;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setMenu: self.menu];
    
    NSImage *menuIcon = [NSImage imageNamed: @"Icon-60"];
    menuIcon.size = CGSizeMake(20, 20);
    [_statusItem.button setImage: menuIcon];
    
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut toAction:^{
        if (nil == _hangqingWindowController) {
            NSStoryboard *sb = [NSStoryboard storyboardWithName: @"Hangqing" bundle: nil];
            _hangqingWindowController = [sb instantiateInitialController];
            
            //窗口在最前
            [_hangqingWindowController.window setLevel:NSScreenSaverWindowLevel + 1];
            [_hangqingWindowController.window orderFront:nil];
            
            //透明背景
            if (Preference.transparentBackground) {
                [_hangqingWindowController.window setBackgroundColor: [NSColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.2]];
                [_hangqingWindowController.window setOpaque: NO];
            }
            
            //隐藏标题栏
            //[_hangqingWindowController.window setStyleMask: NSBorderlessWindowMask];
            //[_hangqingWindowController.window setMovableByWindowBackground: YES];
            
            [_hangqingWindowController showWindow: nil];
        }
        else {
            [_hangqingWindowController close];
            _hangqingWindowController = nil;
        }
     }];
}

- (IBAction)settingClicked:(id)sender {
    NSLog(@"setting is clicked");
    
    NSStoryboard *sb = [NSStoryboard storyboardWithName: @"Windows" bundle: nil];
    _settingWindowController = [sb instantiateInitialController];
    
    [_settingWindowController showWindow: nil];
}

- (IBAction)quitClicked:(id)sender {
    [[NSApplication sharedApplication] terminate: nil];
}

@end

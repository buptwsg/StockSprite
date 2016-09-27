//
//  SettingsWindowController.m
//  StockSprite
//
//  Created by wang shuguang on 16/8/19.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "SettingsWindowController.h"

@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSToolbar *toolbar = self.window.toolbar;
    [toolbar insertItemWithItemIdentifier: @"choice" atIndex: 0];
    [toolbar insertItemWithItemIdentifier: @"notify" atIndex: 1];
    [toolbar insertItemWithItemIdentifier: @"ui" atIndex: 2];
    
    [toolbar setSelectedItemIdentifier: @"choice"];
    [self onBarItemClicked: nil];
}


- (IBAction)onBarItemClicked:(id)sender {
    NSStoryboard *sb = [NSStoryboard storyboardWithName: @"Windows" bundle: nil];
    
    NSToolbarItem *item = (NSToolbarItem*)sender;
    switch (item.tag) {
        case 0:
            self.contentViewController = [sb instantiateControllerWithIdentifier: @"choices"];
            break;
            
        case 2:
            self.contentViewController = [sb instantiateControllerWithIdentifier: @"userInterface"];
            break;
            
        default:
            break;
    }
}

@end

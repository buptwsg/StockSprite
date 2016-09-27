//
//  ChoicesTableView.m
//  StockSprite
//
//  Created by wang shuguang on 16/9/14.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "ChoicesTableView.h"

@implementation ChoicesTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)keyDown:(NSEvent *)theEvent {
    // handle delete
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == NSDeleteCharacter && self.selectedRow != -1) {
        [NSApp sendAction:@selector(delete:) to:nil from:self];
    } else {
        [super keyDown:theEvent];
    }
}

- (NSMenu*)menuForEvent:(NSEvent *)event {
    NSInteger row = [self rowAtPoint:[self convertPoint:event.locationInWindow fromView:nil]];
    if (row == -1)
        return nil;
    if (row != self.selectedRow)
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    
    if (nil == self.menu) {
        self.menu = [[NSMenu alloc] init];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: @"删除" action: @selector(delete:) keyEquivalent: @""];
        [self.menu insertItem: item atIndex: 0];
    }
    
    return self.menu;
}

@end

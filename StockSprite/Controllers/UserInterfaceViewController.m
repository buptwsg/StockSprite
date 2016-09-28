//
//  UserInterfaceViewController.m
//  StockSprite
//
//  Created by wang shuguang on 16/8/25.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import <MASShortcut/Shortcut.h>

#import "UserInterfaceViewController.h"
#import "AppPreference.h"

NSString *const kPreferenceGlobalShortcut = @"GlobalShortcut";

@interface UserInterfaceViewController ()

@property (weak) IBOutlet MASShortcutView *shortcutView;
@property (weak) IBOutlet NSButton *checkBackground;
@property (weak) IBOutlet NSButton *checkTodayOpen;
@property (weak) IBOutlet NSButton *checkYesterdayClose;
@property (weak) IBOutlet NSButton *checkHighest;
@property (weak) IBOutlet NSButton *checkLowest;
@property (weak) IBOutlet NSButton *checkVolume;
@property (weak) IBOutlet NSButton *checkMoney;
@property (weak) IBOutlet NSButton *checkDelta;
@property (weak) IBOutlet NSButton *checkRangePercent;

@property (weak) IBOutlet NSPopUpButton *popupIntervals;

@end

@implementation UserInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    if (Preference.transparentBackground) {
        self.checkBackground.state = NSOnState;
    }
    else {
        self.checkBackground.state = NSOffState;
    }
    
    _checkTodayOpen.state = (Preference.detailMask & StockDetailTodayOpenPrice) ? NSOnState : NSOffState;
    _checkYesterdayClose.state = (Preference.detailMask & StockDetailYesterdayClosePrice) ? NSOnState : NSOffState;
    _checkHighest.state = (Preference.detailMask & StockDetailHighest) ? NSOnState : NSOffState;
    _checkLowest.state = (Preference.detailMask & StockDetailLowest) ? NSOnState : NSOffState;
    _checkVolume.state = (Preference.detailMask & StockDetailVolume) ? NSOnState : NSOffState;
    _checkMoney.state = (Preference.detailMask & StockDetailMoney) ? NSOnState : NSOffState;
    _checkDelta.state = (Preference.detailMask & StockDetailDelta) ? NSOnState : NSOffState;
    _checkRangePercent.state = (Preference.detailMask & StockDetailRangePercent) ? NSOnState : NSOffState;
    
    [_popupIntervals removeAllItems];
    [_popupIntervals addItemsWithTitles: @[@"2秒", @"3秒", @"4秒", @"5秒"]];
    switch (Preference.refreshInterval) {
        case 2:
            [_popupIntervals selectItemAtIndex: 0];
            break;
            
        case 3:
            [_popupIntervals selectItemAtIndex: 1];
            break;
            
        case 4:
            [_popupIntervals selectItemAtIndex: 2];
            break;
            
        case 5:
            [_popupIntervals selectItemAtIndex: 3];
            break;
            
        default:
            break;
    }
}

- (IBAction)checkboxClicked:(id)sender {
    NSButton *checkBox = (NSButton*)sender;
    switch ([checkBox tag]) {
        case 0:
            Preference.transparentBackground = (checkBox.state == NSOnState);
            break;
            
        case 1:
            Preference.detailMask ^= StockDetailTodayOpenPrice;
            break;
            
        case 2:
            Preference.detailMask ^= StockDetailYesterdayClosePrice;
            break;
            
        case 3:
            Preference.detailMask ^= StockDetailHighest;
            break;
            
        case 4:
            Preference.detailMask ^= StockDetailLowest;
            break;
            
        case 5:
            Preference.detailMask ^= StockDetailVolume;
            break;
            
        case 6:
            Preference.detailMask ^= StockDetailMoney;
            break;
            
        case 7:
            Preference.detailMask ^= StockDetailDelta;
            break;
            
        case 8:
            Preference.detailMask ^= StockDetailRangePercent;
            break;
            
        default:
            break;
    }
    
    [Preference save];
}

- (IBAction)intervalSelected:(id)sender {
    switch ([_popupIntervals indexOfSelectedItem]) {
        case 0:
            Preference.refreshInterval = 2;
            break;
            
        case 1:
            Preference.refreshInterval = 3;
            break;
            
        case 2:
            Preference.refreshInterval = 4;
            break;
            
        case 3:
            Preference.refreshInterval = 5;
            break;
            
        default:
            break;
    }
    
    [Preference save];
}

@end

//
//  HangqingViewController.m
//  StockSprite
//
//  Created by wang shuguang on 2016/9/22.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "HangqingViewController.h"
#import "HangqingManager.h"
#import "HangqingData.h"
#import "AppPreference.h"

@interface HangqingViewController () <NSTableViewDataSource, NSTableViewDelegate>
{
    NSTimer *_refreshTimer;
    BOOL _hideFlags[20];
}

@property (nonatomic, strong) HangqingManager *hqManager;
@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation HangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    memset(_hideFlags, 0, sizeof(_hideFlags));
    
    self.hqManager = [[HangqingManager alloc] init];
    [self.hqManager refreshHangqing];
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval: Preference.refreshInterval target: self.hqManager selector: @selector(refreshHangqing) userInfo: nil repeats: YES];
    self.tableView.backgroundColor = [NSColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hangqingRefreshed) name: kHangqingDidRefreshNotification object: nil];
}

- (void)dealloc {
    NSLog(@"HangqingViewController dealloc");
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

- (void)hangqingRefreshed {
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.hqManager numberOfStocks];
}

#pragma mark - NSTableViewDelegate
- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    HangqingData *hqData = [self.hqManager getDataAtIndex: row];
    if (nil == hqData) {
        return nil;
    }
    
    NSString *cellId = nil;
    NSString *text = nil;
    NSTableCellView *cell = nil;
    
    if (tableColumn == self.tableView.tableColumns[0]) {
        cellId = @"cellCode";
        text = [self fixString: hqData.stockCode];
        cell = [tableView makeViewWithIdentifier: cellId owner: nil];
        cell.textField.stringValue = text;
    }
    else if (tableColumn == self.tableView.tableColumns[1]) {
        cellId = @"cellName";
        text = [self fixString: hqData.stockName];
        cell = [tableView makeViewWithIdentifier: cellId owner: nil];
        cell.textField.stringValue = text;
    }
    else if (tableColumn == self.tableView.tableColumns[2]) {
        cellId = @"cellPrice";
        text = [self fixString: hqData.currentPrice];
        if ([text isEqualToString: @"0.00"]) {
            text = @"停牌";
        }
        cell = [tableView makeViewWithIdentifier: cellId owner: nil];
        cell.textField.stringValue = text;
        cell.textField.textColor = [self fixColor: hqData forInformation: hqData.currentPrice];
    }
    else if (tableColumn == self.tableView.tableColumns[3]) {
        if (Preference.detailMask & StockDetailDelta) {
            cellId = @"cellDelta";
            text = [self fixString: hqData.delta];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
            cell.textField.textColor = [self fixColor: hqData forInformation: hqData.currentPrice];
        }
        else {
            [self hideColumn: tableColumn index: 3];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[4]) {
        cellId = @"cellDeltaPercent";
        text = [self fixString: hqData.deltaPercent];
        cell = [tableView makeViewWithIdentifier: cellId owner: nil];
        cell.textField.stringValue = text;
        cell.textField.textColor = [self fixColor: hqData forInformation: hqData.currentPrice];
    }
    else if (tableColumn == self.tableView.tableColumns[5]) {
        if (Preference.detailMask & StockDetailRangePercent) {
            cellId = @"cellRangePercent";
            text = [self fixString: hqData.rangePercent];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
            cell.textField.textColor = [NSColor whiteColor];
        }
        else {
            [self hideColumn: tableColumn index: 5];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[6]) {
        if (Preference.detailMask & StockDetailTodayOpenPrice) {
            cellId = @"cellOpenPrice";
            text = [self fixString: hqData.todayOpenPrice];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
            cell.textField.textColor = [self fixColor: hqData forInformation: hqData.todayOpenPrice];
        }
        else {
            [self hideColumn: tableColumn index: 6];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[7]) {
        if (Preference.detailMask & StockDetailYesterdayClosePrice) {
            cellId = @"cellClosePrice";
            text = [self fixString: hqData.yesterdayClosePrice];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
        }
        else {
            [self hideColumn: tableColumn index: 7];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[8]) {
        if (Preference.detailMask & StockDetailHighest) {
            cellId = @"cellHighestPrice";
            text = [self fixString: hqData.highestPrice];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
            cell.textField.textColor = [self fixColor: hqData forInformation: hqData.highestPrice];
        }
        else {
            [self hideColumn: tableColumn index: 8];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[9]) {
        if (Preference.detailMask & StockDetailLowest) {
            cellId = @"cellLowestPrice";
            text = [self fixString: hqData.lowestPrice];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
            cell.textField.textColor = [self fixColor: hqData forInformation: hqData.lowestPrice];
        }
        else {
            [self hideColumn: tableColumn index: 9];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[10]) {
        if (Preference.detailMask & StockDetailVolume) {
            cellId = @"cellVolume";
            text = [self fixVolume: hqData.volume isShanghaiIndex: [hqData.stockName isEqualToString: @"上证指数"]];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
        }
        else {
            [self hideColumn: tableColumn index: 10];
        }
    }
    else if (tableColumn == self.tableView.tableColumns[11]) {
        if (Preference.detailMask & StockDetailMoney) {
            cellId = @"cellMoney";
            text = [self fixMoney: hqData.money];
            cell = [tableView makeViewWithIdentifier: cellId owner: nil];
            cell.textField.stringValue = text;
        }
        else {
            [self hideColumn: tableColumn index: 11];
        }
    }
    
    return cell;
}

#pragma mark - private
- (NSString*)fixString: (NSString*)originalString {
    if (nil == originalString) {
        return @"--";
    }
    
    if ([originalString containsString: @"%"]) {
        return originalString;
    }
    
    NSRange range = [originalString rangeOfString: @"."];
    if (range.location + 3 < originalString.length) {
        return [originalString substringToIndex: range.location + 3];
    }
    
    return originalString;
}

- (NSString*)fixVolume: (NSString*)originalVolume isShanghaiIndex: (BOOL)isShanghai {
    if (nil == originalVolume) {
        return @"--";
    }
    
    float floatValue = [originalVolume floatValue] / (isShanghai ? 1 : 100);
    //小于1万手，显示实际的；否则显示多少万手
    if (floatValue < 10000) {
        return [NSString stringWithFormat: @"%.2f手", floatValue];
    }
    else if (floatValue < 100000000) {
        return [NSString stringWithFormat: @"%.2f万手", floatValue / 10000];
    }
    else {
        return [NSString stringWithFormat: @"%.2f亿手", floatValue / 100000000];
    }
    
    return originalVolume;
}

- (NSString*)fixMoney: (NSString*)originalMoney {
    if (nil == originalMoney) {
        return @"--";
    }
    
    //小于1万，显示实际；大于等于1万，小于1亿，则显示XX万；否则显示XX亿
    float floatValue = [originalMoney floatValue];
    if (floatValue < 10000) {
        return [NSString stringWithFormat: @"%.2f元", floatValue];
    }
    else if (floatValue < 100000000) {
        return [NSString stringWithFormat: @"%.2f万", floatValue / 10000];
    }
    else {
        return [NSString stringWithFormat: @"%.2f亿", floatValue / 100000000];
    }
    
    return originalMoney;
}

- (NSColor*)fixColor: (HangqingData *)data forInformation: (NSString*)info {
    if (nil == data || nil == info || nil == data.yesterdayClosePrice) {
        return [NSColor whiteColor];
    }
    
    //停牌
    if ([info floatValue] < FLT_EPSILON) {
        return [NSColor whiteColor];
    }
    
    float delta = [info floatValue] - [data.yesterdayClosePrice floatValue];
    if (fabsf(delta) < FLT_EPSILON) {
        return [NSColor whiteColor]; //平盘
    }
    else if (delta > 0) {
        return [NSColor redColor];
    }
    else {
        return [NSColor greenColor];
    }
}

- (void)hideColumn: (NSTableColumn*)column index: (NSInteger)columnIndex {
    if (!_hideFlags[columnIndex]) {
        _hideFlags[columnIndex] = YES;
        [column setHidden: YES];
        
        CGRect oldFrame = self.view.frame;
        CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width - column.width - 3, oldFrame.size.height);
        [self.view.window setContentSize: newFrame.size];
        
        NSPoint oldOrigin = self.view.window.frame.origin;
        CGFloat x = ([NSScreen mainScreen].frame.size.width - self.view.window.frame.size.width) / 2;
        NSPoint newOrigin = NSMakePoint(x, oldOrigin.y);
        [self.view.window setFrameOrigin: newOrigin];
    }
}

@end

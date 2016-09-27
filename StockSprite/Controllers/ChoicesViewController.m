//
//  ChoicesViewController.m
//  StockSprite
//
//  Created by wang shuguang on 16/8/25.
//  Copyright © 2016年 wang shuguang. All rights reserved.
//

#import "ChoicesViewController.h"
#import "ChoicesManager.h"

#define MyPrivateTableViewDataType @"MyPrivateTableViewDataType"

@interface ChoicesViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *inputTextField;
@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation ChoicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerForDraggedTypes: [NSArray arrayWithObject: MyPrivateTableViewDataType]];
}

- (IBAction)addStock:(id)sender {
    //根据输入框里的值，如果不是以6，3，0开头，则认为非法，目前只允许添加股票
    NSString *stockCode = self.inputTextField.stringValue;
    if (([stockCode hasPrefix: @"6"] || [stockCode hasPrefix: @"3"] || [stockCode hasPrefix: @"0"]) && stockCode.length == 6) {
        NSString *prefix = nil;
        if ([stockCode hasPrefix: @"6"]) {
            prefix = @"sh";
        }
        else {
            prefix = @"sz";
        }
        
        NSString *strUrl = [NSString stringWithFormat: @"http://hq.sinajs.cn/list=%@%@", prefix, stockCode];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: strUrl]];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (nil != error) {
                NSLog(@"add stock error: %@", error);
                [self showErrorMessage: [error localizedDescription]];
                return;
            }
            
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *responseStr = [[NSString alloc] initWithData: data encoding: gbkEncoding];
            NSArray *components = [responseStr componentsSeparatedByString: @"="];
            NSString *detail = components[1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (detail.length == 0 || [detail isEqualToString: @"FAILED"]) {
                    [self showErrorMessage: @"您输入的代码不正确，请重新输入"];
                }
                else {
                    NSRange range = [detail rangeOfString: @","];
                    NSString *stockName = [detail substringWithRange: NSMakeRange(1, range.location - 1)];
                    
                    ChoicesManager *cManager = [ChoicesManager sharedInstance];
                    if (-1 != [cManager searchStock: stockCode prefix: prefix]) {
                        [self showErrorMessage: [NSString stringWithFormat: @"你已经添加了%@", stockName]];
                        return;
                    }
                    
                    [cManager addStock: stockCode name: stockName prefix: prefix];
                    [cManager save];
                    [self.tableView reloadData];
                }
            });
        }];
        
        [dataTask resume];
    }
    else {
        [self showErrorMessage: @"您输入的代码不正确，请重新输入"];
    }
}

- (void)delete:(id)sender {
    if (self.tableView.selectedRowIndexes.count > 0) {
        [[ChoicesManager sharedInstance] removeStockAtIndex: self.tableView.selectedRow];
        [[ChoicesManager sharedInstance] save];
        [self.tableView removeRowsAtIndexes: self.tableView.selectedRowIndexes withAnimation: NSTableViewAnimationEffectFade];
    }
}

- (void) showErrorMessage: (NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: message];
        [msgBox addButtonWithTitle: @"好的"];
        [msgBox runModal];
    });
}

#pragma mark - NSTableViewDataSource
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [[ChoicesManager sharedInstance] numberOfChoices];
}

// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
    // Copy the row numbers to the pasteboard.
    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] owner:self];
    [pboard setData:zNSIndexSetData forType:MyPrivateTableViewDataType];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    // Add code here to validate the drop
    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:MyPrivateTableViewDataType];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow = [rowIndexes firstIndex];
    
    // Move the specified row to its new location...
    // if we remove a row then everything moves down by one
    // so do an insert prior to the delete
    // --- depends which way were moving the data!!!
    ChoicesManager *cManager = [ChoicesManager sharedInstance];
    if (dragRow < row) {
        [cManager insertChoice: [cManager getChoiceAtIndex: dragRow] atIndex: row];
        [cManager removeStockAtIndex: dragRow];
        [cManager save];
        
        [self.tableView noteNumberOfRowsChanged];
        [self.tableView reloadData];
        
        return YES;
        
    } // end if
    
    NSDictionary *choice = [cManager getChoiceAtIndex: dragRow];
    [cManager removeStockAtIndex: dragRow];
    [cManager insertChoice: choice atIndex: row];
    [cManager save];
    
    [self.tableView noteNumberOfRowsChanged];
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - NSTableViewDelegate
- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ChoicesManager *manager = [ChoicesManager sharedInstance];
    NSDictionary *choice = [manager getChoiceAtIndex: row];
    
    NSString *cellId = nil;
    NSString *text = nil;
    if (tableColumn == tableView.tableColumns[0]) {
        cellId = @"cellCode";
        text = choice[@"code"];
    }
    else {
        cellId = @"cellName";
        text = choice[@"name"];
    }
    NSTableCellView *cell = [tableView makeViewWithIdentifier: cellId owner: nil];
    cell.textField.stringValue = text;
    return cell;
}

@end

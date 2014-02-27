//
//  PeriodSelectionController.m
//  iDaPro
//
//  Created by Andrey Yashnev on 21/02/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "DateCellsController.h"
#import "DatePickerCell.h"
#import  <objc/runtime.h>

static const CGFloat kDefaultPickerHeight = 162;
static const CGFloat kDefaultRowHeight = 44;

@interface DateCellsController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSIndexPath *datePickerIndexPath;
@property (nonatomic, retain) NSIndexPath *currentDateObjectIndexPath;

@end

@implementation DateCellsController


#pragma mark - Init&Dealloc

- (void)dealloc {
    [_indexPathToDateMapping release];
    [_datePickerIndexPath release];
    [_tableView release];
    [super dealloc];
}

#pragma mark - Propetries

- (void)setTableView:(UITableView *)tableView {
    [_tableView autorelease];
    _tableView = [tableView retain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:[DatePickerCell cellReuseId]];
}

#pragma mark - Public

- (void)attachToTableView:(UITableView *)tableView
             withDelegate:(id<DateCellsControllerDelegate>)delegate
              withMapping:(NSMutableDictionary *)indexPathToDatemapping {
    self.delegate = delegate;
    self.tableView = tableView;
    self.indexPathToDateMapping = indexPathToDatemapping;
}

#pragma mark - Private

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath {
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow
                                                                                                    inSection:[indexPath section]]];
    return [checkDatePickerCell reuseIdentifier] == [DatePickerCell cellReuseId];
}

- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    BOOL before = NO;
    BOOL sameCellClicked = (self.datePickerIndexPath && self.datePickerIndexPath.row - 1 == indexPath.row)
                            && self.datePickerIndexPath.section == indexPath.section;
    
    if ([self hasInlineDatePicker]) {
        if (self.datePickerIndexPath &&
            self.datePickerIndexPath.row < indexPath.row &&
            self.datePickerIndexPath.section == indexPath.section) {
            before = YES;
        }
        [self.tableView deleteRowsAtIndexPaths:@[self.datePickerIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    } else {
        if ([self.delegate respondsToSelector:@selector(dateCellsController:willExpandTableViewContent:forHeight:)]) {
            [self.delegate dateCellsController:self
                    willExpandTableViewContent:_tableView
                                     forHeight:kDefaultPickerHeight];
        }
    }
    
    if (!sameCellClicked)  {
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:[indexPath section]];
        self.currentDateObjectIndexPath = indexPathToReveal;
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:[indexPath section]];
    } else {
        if ([self.delegate respondsToSelector:@selector(dateCellsController:willCollapseTableViewContent:forHeight:)]) {
            [self.delegate dateCellsController:self
                  willCollapseTableViewContent:_tableView
                                     forHeight:kDefaultPickerHeight];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView endUpdates];
}

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:[indexPath section]]];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (BOOL)hasInlineDatePicker {
    return (self.datePickerIndexPath != nil);
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath {
    return ([self hasInlineDatePicker] && ([self.datePickerIndexPath compare:indexPath] == NSOrderedSame));
}


#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathHasPicker:indexPath]) {
        return kDefaultPickerHeight ;
    } else {
        if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    return kDefaultRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = [self.delegate tableView:tableView numberOfRowsInSection:section];
    
    if ([self hasInlineDatePicker] && self.datePickerIndexPath.section == section) {
        numberOfRows++;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if ([self indexPathHasPicker:indexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:[DatePickerCell cellReuseId]];
        DatePickerCell *dateCell = (DatePickerCell *)cell;
        dateCell.datePicker.date = [_indexPathToDateMapping objectForKey:self.currentDateObjectIndexPath];
        [dateCell.datePicker addTarget:self action:@selector(dateSelectedAction:)
                      forControlEvents:UIControlEventValueChanged];
    } else {
        cell = [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
    }
   
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *shiftedIndexPath = indexPath;
    
    if (self.datePickerIndexPath == indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (self.datePickerIndexPath && self.datePickerIndexPath.section == indexPath.section) {
        BOOL before = _datePickerIndexPath.row < indexPath.row;
        int shift = before ? -1 : 0;
        shiftedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + shift inSection:indexPath.section];
    }
    if ([_indexPathToDateMapping objectForKey:shiftedIndexPath]) {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:shiftedIndexPath];
    }
}

#pragma mark - Actions

- (void)dateSelectedAction:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSIndexPath *indexPathKey = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:self.datePickerIndexPath.section];
    [self.indexPathToDateMapping setObject:picker.date forKey:indexPathKey];
    if ([self.delegate respondsToSelector:@selector(dateCellsController:didSelectedDate:forIndexPath:)]) {
        [self.delegate dateCellsController:self
                           didSelectedDate:picker.date
                              forIndexPath:indexPathKey];
    }

}

#pragma mark - NSObject

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.delegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.delegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

@end

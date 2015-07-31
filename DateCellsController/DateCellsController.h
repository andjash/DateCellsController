//
//  PeriodSelectionController.h
//  iDaPro
//
//  Created by Andrey Yashnev on 21/02/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DateCellsController;
@protocol DateCellsControllerDelegate <UITableViewDataSource, UITableViewDelegate>

@optional

- (void)dateCellsController:(DateCellsController *)controller
 willExpandTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight;

- (void)dateCellsController:(DateCellsController *)controller
willCollapseTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight;

- (void)dateCellsController:(DateCellsController *)controller
            didSelectedDate:(NSDate *)date
               forIndexPath:(NSIndexPath *)path;

- (void)dateCellsController:(DateCellsController *)controller
           configuredPicker:(UIDatePicker *)picker
               forIndexPath:(NSIndexPath *)path;

@end

@interface DateCellsController : NSObject

@property (nonatomic, weak) id<DateCellsControllerDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *indexPathToDateMapping;

- (NSIndexPath *)indexPathForDateCellWithCurrentPicker;

- (void)attachToTableView:(UITableView *)tableView
             withDelegate:(id<DateCellsControllerDelegate>)delegate
              withMapping:(NSMutableDictionary *)indexPathToDateMapping;

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath
                  ignoringPickerCells:(BOOL)ignoring;

- (void)hidePicker;

@end

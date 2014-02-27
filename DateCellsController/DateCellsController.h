//
//  PeriodSelectionController.h
//  iDaPro
//
//  Created by Andrey Yashnev on 23/02/14.
//  Copyright (c) 2014 iDA-Mobile. All rights reserved.
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

@end

@interface DateCellsController : NSObject

@property (nonatomic, assign) id<DateCellsControllerDelegate> delegate;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *indexPathToDateMapping;

- (void)attachToTableView:(UITableView *)tableView
             withDelegate:(id<DateCellsControllerDelegate>)delegate
              withMapping:(NSMutableDictionary *)indexPathToDateMapping;

@end

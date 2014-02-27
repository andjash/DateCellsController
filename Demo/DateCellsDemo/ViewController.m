//
//  ViewController.m
//  ExpandableCell
//
//  Created by Andrey Yashnev on 21/02/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "ViewController.h"
#import "DateCellsController.h"

@interface ViewController ()<DateCellsControllerDelegate>

@property (nonatomic, retain) DateCellsController *dateCellsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end

@implementation ViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
        self.dateCellsController = [[[DateCellsController alloc] init] autorelease];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *path3 = [NSIndexPath indexPathForRow:0 inSection:1];
        
       
        NSDate *date = [NSDate date];
        NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:5000];
        NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow:5000];
        
        
        self.dateCellsController.indexPathToDateMapping = [[@{path : date,
                                                          path2 : date2,
                                                          path3 : date3}
                                                          mutableCopy] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.dateFormatter = nil;
    self.tableView = nil;
    self.dateCellsController = nil;
    [super dealloc];
}

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dateCellsController attachToTableView:self.tableView
                                   withDelegate:self
                                    withMapping:self.dateCellsController.indexPathToDateMapping];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}

#pragma mark - DateCellsControllerDelegate 

- (void)dateCellsController:(DateCellsController *)controller
 willExpandTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight {
    
}

- (void)dateCellsController:(DateCellsController *)controller
willCollapseTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight {
    
}

- (void)dateCellsController:(DateCellsController *)controller
            didSelectedDate:(NSDate *)date
               forIndexPath:(NSIndexPath *)path {
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewInner cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellReuseId = @"id";
    
    UITableViewCell *cell = [tableViewInner dequeueReusableCellWithIdentifier:cellReuseId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId] autorelease];
    }
    
    NSDate *correspondedDate = [self.dateCellsController.indexPathToDateMapping objectForKey:indexPath];
    if (correspondedDate) {
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.text = [self.dateFormatter stringFromDate:correspondedDate];
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = [NSString stringWithFormat:@"Section: %ld row: %ld", (long)indexPath.section, (long)indexPath.row];
    }
    return cell;
}

@end
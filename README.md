# DateCellsController

Simple ios controller for UITableView with date cells

### Preview

![Preview1](https://github.com/andjash/DateCellsController/screenshots/screen_1.png)
![Preview2](https://github.com/andjash/DateCellsController/screenshots/screen_2.png)
![Preview3](https://github.com/andjash/DateCellsController/screenshots/screen_3.png)

(Check video: http://screencast.com/t/Vp94gyhpjUwr)

### Usage

Import required header

```objc

#import "DateCellsController.h"

```

Create NSIndexPath to NSDate mapping

```objc

NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:0];
NSIndexPath *path3 = [NSIndexPath indexPathForRow:0 inSection:1];
        
       
NSDate *date = [NSDate date];
NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:5000];
NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow:10000];
        
        
NSMutableDictionary *indexPathToDateMapping = [[@{path : date,
                                                 path2 : date2,
                                                 path3 : date3}
                                                   mutableCopy] autorelease];

```

Attach controller to existing UITableView with proper mapping

```objc

DateCellsController *dateCellsController = attachToTableView:self.tableView
                             			       withDelegate:self
                             			        withMapping:indexPathToDateMapping];

```
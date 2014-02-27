//
//  DatePickerCell.h
//  iDaPro
//
//  Created by Andrey Yashnev on 21/02/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

+ (NSString * const)cellReuseId;

@end

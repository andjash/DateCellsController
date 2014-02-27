//
//  DatePickerCell.m
//  iDaPro
//
//  Created by Andrey Yashnev on 21/02/14.
//  Copyright (c) 2014 Andrey Yashnev. All rights reserved.
//

#import "DatePickerCell.h"

static NSString * const kDatePickerCellReuseId = @"kDatePickerCellReuseId";

@implementation DatePickerCell

#pragma mark - Init&Dealloc

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (NSString * const)cellReuseId {
    return kDatePickerCellReuseId;
}


@end

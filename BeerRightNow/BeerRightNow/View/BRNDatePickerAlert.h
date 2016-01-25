//
//  BRNDatePickerAlert.h
//  BeerRightNow
//
//  Created by dukce pak on 4/17/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRNAlert.h"

@protocol DatePickerDelegate <NSObject>

-(void)onDatePicker:(NSDate*)date;
@end

@interface BRNDatePickerAlert : UIViewController

@property (nonatomic, weak) id<DatePickerDelegate> delegate;

- (void)setDate:(NSDate *)date;
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode;

@end

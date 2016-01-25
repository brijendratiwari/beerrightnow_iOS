//
//  BRNExpireDateAlert.h
//  BeerRightNow
//
//  Created by dukce pak on 5/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpireDateDelegate <NSObject>

-(void)onDatePicker:(NSDate*)date;
@end

@interface BRNExpireDateAlert : UIViewController

@property (nonatomic, weak) id<ExpireDateDelegate> delegate;

- (void)setDate:(NSDate *)date;

@end

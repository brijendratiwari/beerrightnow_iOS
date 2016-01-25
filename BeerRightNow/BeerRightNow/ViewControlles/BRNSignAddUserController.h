//
//  BRNSignAddUserController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/14/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRNDatePickerAlert.h"

@class BRNSignInfo;
@interface BRNSignAddUserController : UIViewController<DatePickerDelegate>

@property (weak, nonatomic) BRNSignInfo * signInfo;
@end

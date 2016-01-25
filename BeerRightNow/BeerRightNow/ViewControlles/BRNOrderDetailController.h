//
//  BRNOrderDetailController.h
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRNOrderItem;

@interface BRNOrderDetailController : UITableViewController

@property (strong, nonatomic) BRNOrderItem * orderItem;

@end

//
//  BRNDeliveryController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRNDeliveryTimeAlert.h"
@class BRNCartResponse;

@interface BRNDeliveryController : UIViewController<UITableViewDataSource , UITableViewDelegate, DeliveryTimeAlert>
@property (strong, nonatomic) BRNCartResponse *cartResponse;
@end

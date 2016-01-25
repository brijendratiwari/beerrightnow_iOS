//
//  BRNShippingAddressController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/26/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRNUpdateAddressAlert.h"
@class BRNCartResponse;

@interface BRNShippingAddressController : UIViewController <UITableViewDataSource , UITableViewDelegate, UIAlertViewDelegate, UpdateAddressDelegate>

@property (nonatomic) BOOL fromLeftMenu;
@property (strong, nonatomic) BRNCartResponse *cartResponse;

@end

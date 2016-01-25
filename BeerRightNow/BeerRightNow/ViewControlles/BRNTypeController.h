//
//  BRNTypeController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/6/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRNSection;
@interface BRNTypeController : UITableViewController

@property (nonatomic, weak) BRNSection * section;
@property (nonatomic, strong) NSArray * typeArr;

@end

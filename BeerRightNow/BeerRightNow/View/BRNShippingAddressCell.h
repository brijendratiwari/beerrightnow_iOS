//
//  BRNShippingAddressCell.h
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNShippingAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *outlineView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@end

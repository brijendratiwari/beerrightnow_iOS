//
//  BRNCartCell.h
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRNCartHoldBtn.h"

@interface BRNCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet BRNCartHoldBtn *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UILabel *other1Label;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *other2Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet BRNCartHoldBtn *minusBtn;
@property (weak, nonatomic) IBOutlet BRNCartHoldBtn *plusBtn;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

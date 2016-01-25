//
//  BRNDeliveryGiftCell.h
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNDeliveryGiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *giftSwitch;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *receipentField;

-(void)setGift:(BOOL)isOn;
@end

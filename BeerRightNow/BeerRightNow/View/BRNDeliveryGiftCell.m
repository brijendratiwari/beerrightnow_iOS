//
//  BRNDeliveryGiftCell.m
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNDeliveryGiftCell.h"

@implementation BRNDeliveryGiftCell

- (void)awakeFromNib {
    // Initialization code
    _phoneField.hidden = YES;
    _receipentField.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGift:(BOOL)isOn
{
    [_giftSwitch setOn:isOn];
    
    if(isOn) {
        
        _phoneField.hidden = NO;
        _receipentField.hidden = NO;
    } else {
        
        _phoneField.hidden = YES;
        _receipentField.hidden = YES;
    }
}

@end

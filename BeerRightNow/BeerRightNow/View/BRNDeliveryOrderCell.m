//
//  BRNDeliveryOrderCell.m
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNDeliveryOrderCell.h"

@implementation BRNDeliveryOrderCell

- (void)awakeFromNib {
    // Initialization code
    _officeField.hidden = YES;
    _contactField.hidden = YES;
    _serviceEntranceField.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrder:(BOOL)isOn
{
    [_deliverySwitch setOn:isOn];
    
    if(isOn) {
        
        _officeField.hidden = NO;
        _contactField.hidden = NO;
        _serviceEntranceField.hidden = NO;
    } else {
        
        _officeField.hidden = YES;
        _contactField.hidden = YES;
        _serviceEntranceField.hidden = YES;
    }
}
@end

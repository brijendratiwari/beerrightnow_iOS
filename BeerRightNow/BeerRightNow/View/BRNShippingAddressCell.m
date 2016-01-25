//
//  BRNShippingAddressCell.m
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNShippingAddressCell.h"

@implementation BRNShippingAddressCell

- (void)awakeFromNib {
    // Initialization code
    [[BRNUtils shared] setBorder:_outlineView color:[UIColor blackColor] cornerRadius:7 borderWidth:1.0f];
    
    [_defaultBtn setImage:[UIImage imageNamed:@"ic_crossmark"] forState:UIControlStateNormal];
    [_defaultBtn setImage:[UIImage imageNamed:@"ic_checkmark"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [_defaultBtn setSelected:selected];
    [_defaultBtn setUserInteractionEnabled:!selected];
    if(selected) {
        
        [_outlineView setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f]];
    } else {
        
        [_outlineView setBackgroundColor:[UIColor clearColor]];
    }
}

@end

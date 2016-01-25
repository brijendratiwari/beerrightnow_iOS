//
//  BRNFilterCell.m
//  BeerRightNow
//
//  Created by dukce pak on 4/19/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNFilterCell.h"

@interface BRNFilterCell()


@end

@implementation BRNFilterCell

- (void)awakeFromNib {
    // Initialization code
 
    [_checkBtn setImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [_checkBtn setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [_checkBtn setSelected:selected];
}

@end

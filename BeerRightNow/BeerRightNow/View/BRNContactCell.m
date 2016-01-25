//
//  BRNContactCell.m
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNContactCell.h"

@interface BRNContactCell()

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@end

@implementation BRNContactCell

- (void)awakeFromNib {
    // Initialization code
    [_checkBtn setImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [_checkBtn setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    
    [_checkBtn setUserInteractionEnabled:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [_checkBtn setSelected:selected];
}

@end

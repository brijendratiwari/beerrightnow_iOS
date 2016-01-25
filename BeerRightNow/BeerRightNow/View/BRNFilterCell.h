//
//  BRNFilterCell.h
//  BeerRightNow
//
//  Created by dukce pak on 4/19/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNFilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end

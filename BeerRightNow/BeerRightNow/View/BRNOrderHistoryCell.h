//
//  BRNOrderHistoryCell.h
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNOrderHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *billNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *billDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;
@end

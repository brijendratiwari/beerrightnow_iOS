//
//  BRNOrderDetailCell.h
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

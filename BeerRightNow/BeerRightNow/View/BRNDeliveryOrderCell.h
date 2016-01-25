//
//  BRNDeliveryOrderCell.h
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNDeliveryOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *deliverySwitch;
@property (weak, nonatomic) IBOutlet UITextField *officeField;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UITextField *serviceEntranceField;

-(void)setOrder:(BOOL)isOn;
@end

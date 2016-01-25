//
//  BRNDeliveryTimeAlert.h
//  BeerRightNow
//
//  Created by Dragon on 4/28/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRNCartResponse;

@protocol DeliveryTimeAlert <NSObject>

-(void) onDeliveryTime:(NSString*)expectedTime;

@end

@interface BRNDeliveryTimeAlert : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic) id<DeliveryTimeAlert> delegate;
@property (strong, nonatomic) BRNCartResponse *cartResponse;

@end

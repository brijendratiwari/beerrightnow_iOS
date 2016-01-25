//
//  BRNUpdateAddressAlert.h
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRNAddress;
@protocol UpdateAddressDelegate <NSObject>

-(void) updatedAddress:(BRNAddress*)address;

@end

@interface BRNUpdateAddressAlert : UIViewController

@property (strong, nonatomic) id<UpdateAddressDelegate> delegate;

-(void)setAddress:(BRNAddress*)address;

@end

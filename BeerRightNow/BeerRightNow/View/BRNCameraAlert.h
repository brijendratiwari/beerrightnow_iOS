//
//  BRNCameraAlert.h
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraAlertDelegate <NSObject>

-(void)onShare:(UIImage*)image;

@end

@interface BRNCameraAlert : UIViewController

@property (strong, nonatomic) id<CameraAlertDelegate> delegate;

@end

//
//  UIViewController+BRNPushController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/7/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BRNPushController)
    
@property (nonatomic, retain) UILabel * productsInCart;

-(void)initializeRightNaviationItems:(BOOL)willShowShareItem;
-(void)initializeLeftButtonItem;

-(void)backClicked;
-(void)shareWith:(UIImage*)image;

-(void) updateCartBadge;

@end

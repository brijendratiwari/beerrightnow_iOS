//
//  BRNAlert.h
//  BeerRightNow
//
//  Created by dukce pak on 4/17/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNAlert : UIViewController{
    
    BOOL _animated;
}

-(void)showInView:(UIView*)targetView animated:(BOOL)animated;
-(void)removeView;

@end

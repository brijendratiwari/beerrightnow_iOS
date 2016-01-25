//
//  UIViewController+BRNPushController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/7/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "UIViewController+BRNPushController.h"
#import <objc/runtime.h>

#define PRODUCT_COUNT_BAGE_RADIUS 7

@implementation UIViewController (BRNPushController)

static char productsInCartKey ;

-(UILabel*)productsInCart
{
    return objc_getAssociatedObject(self, &productsInCartKey) ;
}

-(void)setProductsInCart:(UILabel *)productsInCart
{
    objc_setAssociatedObject(self, &productsInCartKey, productsInCart, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

-(void)initializeRightNaviationItems:(BOOL)willShowShareItem
{
    NSMutableArray * rightItems = [[NSMutableArray alloc] init];
    
    UIButton  * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[[UIImage imageNamed:@"ic_cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget: self action: @selector(cartClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    UILabel * productCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PRODUCT_COUNT_BAGE_RADIUS * 2, PRODUCT_COUNT_BAGE_RADIUS * 2)];
    [productCount setTextColor:[UIColor whiteColor]];
    [productCount setBackgroundColor:[UIColor redColor]];
    [productCount setFont:[UIFont boldSystemFontOfSize:10]];
    productCount.textAlignment = NSTextAlignmentCenter;
    productCount.layer.cornerRadius = PRODUCT_COUNT_BAGE_RADIUS;
    productCount.layer.masksToBounds = YES;
    productCount.center = CGPointMake(27, 3);
    
    [backButton addSubview:productCount];
    self.productsInCart = productCount;
    
    [rightItems addObject:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
    
    if(willShowShareItem) {
        
        UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareClicked)];
        [shareItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [rightItems addObject:shareItem];
    }
    
    self.navigationItem.rightBarButtonItems = rightItems;
}

-(void)initializeLeftButtonItem
{
    UIBarButtonItem * backBarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClicked)];
 
    self.navigationItem.leftBarButtonItem = backBarItem;
}

-(void) updateCartBadge
{
    @try {
        
        NSInteger  productCount = [[BRNCartInfo shared] productNumberInCart];
        if(productCount == 0) {
            
            self.productsInCart.hidden = YES;
        } else {
            
            self.productsInCart.hidden = NO;
            [self.productsInCart setText:[NSNumber numberWithInteger:productCount].stringValue];
        }
    } @catch(NSException * exception) {
        
    }
}

-(void)shareWith:(UIImage*)image
{
    
    NSString *textToShare = @"I'm getting Beer, Wine, Liquor, Sake, Beverage, Snacks delivered from @BeerRightNow !";
    //    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare, image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
}

-(void)shareClicked
{
    
    NSString *textToShare = @"I'm getting Beer, Wine, Liquor, Sake, Beverage, Snacks delivered from @BeerRightNow !";
//    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
}

-(void)cartClicked:(UIButton *)sender
{
    if ([[[BRNFlowManager shared] slideMenuContainerController] menuState] == MFSideMenuStateRightMenuOpen) {
        [[[BRNFlowManager shared] slideMenuContainerController] toggleRightSideMenuCompletion:nil];
    }
    if(self.productsInCart.isHidden) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Products in Cart..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    
    UIViewController * cartController = [[[BRNFlowManager shared] storyBoardForMain] instantiateViewControllerWithIdentifier:kCartControllerIdentifier];
    [self.navigationController pushViewController:cartController animated:YES];
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

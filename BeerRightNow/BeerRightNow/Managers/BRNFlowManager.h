
//
//  BRNFlowManager.h
//  BeerRightNow
//
//  Created by dukce pak on 4/5/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Segue ID

#define kConfirmZipcodeIdentifier @"confirmZipCodeIdentifier"
#define kTypeControllerIdentifier @"typeControllerIdentifier"
#define kProductDisplayControllerIdentifier1 @"productDisplayControllerIdentifier1"
#define kProductDisplayControllerIdentifier2 @"productDisplayControllerIdentifier2"
#define kProductControllerIdentifier @"productControllerIdentifier"
#define kSignZipcodeControllerIdentifier @"signZipcodeControllerIdentifier"
#define kSignAddressControllerIdentifier @"signAddressControllerIdentifier"
#define kSignConfirmControllerIdentifier @"signConfirmControllerIdentifier"
#define kReturnedIdentifier @"returnedIdentifier"
#define kSignAddUserControllerIdentifier @"signAddUserControllerIdentifier"
#define kShippingAddressControllerIdentifier @"shippingAddressControllerIdentifier"
#define kAddAddressControllerIdentifier @"addAddressControllerIdentifier"
#define kAddCreditControllerIdentifier @"addCreditControllerIdentifier"
#define kConfirmOrderControllerIdentifier @"confirmOrderControllerIdentifier"
#define kOrderCompleteControllerIdentifier @"orderCompleteControllerIdentifier"
#define kProductControllerIdentifier2 @"productControllerIdentifier2"
#define kOrderDetailsControllerIdentifier @"orderDetailsControllerIdentifier"
#define kSharePhotoControllerIdentifier @"sharePhotoControllerIdentifier"
#define kInvitePartyControllerIdentifier @"invitePartyControllerIdentifier"
#define kDeliveryOptionControllerIdentifier @"deliveryOptionControllerIdentifier"

#pragma mark Cell Resuable ID

#define kProductReusableCellIdentifier @"ProductReusableCellIdentifier"
#define kFilterReusableCellIdentifier @"FilterReusableCellIdentifer"
#define kCartReusableCellIdentifier @"CartReusableCellIdentifier"
#define kCartReusableHeaderIdentifier @"CartReusableHeaderIdentifier"
#define kShippingAddressReusableCellIdentifier @"shippingAddressReusableCellIdenfitier"
#define kDeliveryGiftReusableCellIdentifier @"deliveryGiftReusableCellIdentifier"
#define kDeliveryOrderReusableCellIdentifier @"deliveryOrderReusableCellIdentifier"
#define kOrderHistoryReusableCellIdentifier @"orderHistoryReusablecellIdentifier"
#define kOrderDetailResuableCellIdentifer @"orderDetailReusableCellIdentifier"
#define kContactInfoResuableCellIdentifier @"contactReusableCellIdentifier"

#pragma mark StoryBoard ID

#define kLoginNavigationControllerIdentifier @"LoginNavigationControllerIdentifier"
#define kLoginControllerIdentifier @"LoginControllerIdentifier"
#define kZipcodeControllerIdentifier @"ZipcodeControllerIdentifier"

#define kMFSlideCenterControllerIdentifier @"MFSlideCenterControllerIdentifier"
#define kMFSlideLeftControllerIdentifier @"MFSlideLeftControllerIdentifier"
#define kMFSlideRightControllerIdentifier @"MFSlideRightControllerIdentifier"

#define kCartControllerIdentifier @"CartControllerIdentifier"
#define kKeywordProductDisplayControllerIdentifier @"KeywordProductDisplayControllerIdentifier"
#define kSupportControllerIdentifier @"SupportControllerIdentifier"
#define kShippingAddressControllerID @"ShippingAddressControllerID"
#define kCreditCardControllerID @"CreditCardControllerID"
#define kOrderHistoryControllerID @"OrderHistoryControllerID"
#define kTakeBreakControllerIdentifier @"TakeBreakControllerIdentifier"

@class BRNRightFilterController;
@interface BRNFlowManager : NSObject
@property (strong, readonly)  MFSideMenuContainerViewController * slideMenuContainerController;

+(instancetype)shared;

-(UIStoryboard *)storyBoardForMain;

-(void) willShowHome;

-(void)setLeftMenuController:(BOOL)will;
-(void)setRightFilterController:(BOOL)will;
-(void)setPanMode:(MFSideMenuPanMode)panMode;

-(BRNRightFilterController*)filterController;
-(void)setWindow:(UIWindow*)wnd;

@end

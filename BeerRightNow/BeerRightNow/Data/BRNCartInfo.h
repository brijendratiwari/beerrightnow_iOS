//
//  BRNCartInfo.h
//  BeerRightNow
//
//  Created by Dragon on 4/2/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRNCartInfo : NSObject {
    
    NSMutableArray * cart;
}

@property(nonatomic) NSInteger cardType;
@property(nonatomic,strong) NSString * cardNumber;
@property(nonatomic,strong) NSString * cardCVV;
//@property(nonatomic) NSInteger cardExpiresYear;
//@property(nonatomic) NSInteger cardExpiresMonth;
@property(nonatomic,strong) NSString * cardExpires;

@property(nonatomic) float serviceTip;
@property(nonatomic) float totalPay;

@property(nonatomic,strong) NSString * deliveryExpected;
@property(nonatomic,strong) NSString * deliveryLiquorExpected;
@property(nonatomic) BOOL saveLiquoeInCart;

@property(nonatomic,strong) NSString * deliveryComment;

@property(nonatomic) BOOL executive;
@property(nonatomic) BOOL gift;
@property(nonatomic,strong) NSString * customerNumber;
@property(nonatomic,strong) NSString * giftForNumber;
@property(nonatomic) BOOL corporateOrder;
@property(nonatomic,strong) NSString * officeExtension;
@property(nonatomic,strong) NSString * contactCell;
@property(nonatomic,strong) NSString * serviceEnterenceAddress;

@property(nonatomic,strong) NSString * billingName;
@property(nonatomic,strong) NSString * billingAddres;
@property(nonatomic,strong) NSString * billingCity;
@property(nonatomic,strong) NSString * billingState;
@property(nonatomic,strong) NSString * billingPostCode;
@property(nonatomic,strong) NSString * billingSuite;
@property(nonatomic,strong) NSString * billingCountry;

+(instancetype) shared;

-(void)orderProcessed;
-(void)removeCarts;

-(NSString*)cartData;
-(NSInteger)productNumberInCart;
-(void)removeProductFromCart:(NSString*)productId;
-(NSString*)addProductToCart:(NSString*)productId productCount:(NSString*)productCount;

-(NSArray*)cities;
//-(NSArray*)states;

@end

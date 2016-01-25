//
//  LoginInfo.h
//  BeerRightNow
//
//  Created by Dragon on 3/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRNUserInfo;

@interface BRNLoginInfo : NSObject


@property (nonatomic) BOOL logined;
@property (nonatomic, strong) NSString * zipcode;
@property (nonatomic, strong) NSString * distributorId;
@property (nonatomic, strong) NSString * lrnDistributorId;
@property (nonatomic, strong) BRNUserInfo * userInfo;

+(instancetype) shared;

-(void)setDefaultAddressId:(NSString*)addressId;

@end

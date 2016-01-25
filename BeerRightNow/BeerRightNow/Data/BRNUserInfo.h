//
//  BRNUserInfo.h
//  BeerRightNow
//
//  Created by Dragon on 3/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNUserInfo : JSONModel

@property (strong, nonatomic) NSString* customers_id;
@property (strong, nonatomic) NSString* purchased_without_account;
@property (strong, nonatomic) NSString* customers_gender;
@property (strong, nonatomic) NSString* customers_firstname;
@property (strong, nonatomic) NSString* customers_lastname;

// 0000-00-00 00:00:00

@property (strong, nonatomic) NSString* customers_dob;
@property (strong, nonatomic) NSString* customers_email_address;
@property (strong, nonatomic) NSString* customers_default_address_id;
@property (strong, nonatomic) NSString* customers_telephone;
@property (strong, nonatomic) NSString* customers_fax;
@property (strong, nonatomic) NSString* customers_newsletter;
@property (strong, nonatomic) NSString* customers_group_name;
@property (strong, nonatomic) NSString* customers_group_id;
@property (strong, nonatomic) NSString* customers_group_ra;
@property (strong, nonatomic) NSString* customers_payment_allowed;
@property (strong, nonatomic) NSString* customers_shipment_allowed;
@property (strong, nonatomic) NSString* admin_recover;

-(NSString *)customerName;

@end

//
//  BRNAddress.h
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNAddress : JSONModel

@property (strong, nonatomic) NSString * address_id;
@property (strong, nonatomic) NSString * firstname;
@property (strong, nonatomic) NSString * lastname;
@property (strong, nonatomic) NSString * street_address;
@property (strong, nonatomic) NSString * address_zipcode;
@property (strong, nonatomic) NSString * city;
@property (strong, nonatomic) NSString * state;
@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * suite;

@end

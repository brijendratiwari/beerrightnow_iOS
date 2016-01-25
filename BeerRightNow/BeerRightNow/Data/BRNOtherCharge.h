//
//  BRNOtherCharge.h
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNOtherCharge : JSONModel

@property (nonatomic) float options_values_price;
@property (nonatomic, strong) NSString* price_prefix;
@property (nonatomic, strong) NSString* products_options_name;
@property (nonatomic, strong) NSString* products_options_values_name;

@end

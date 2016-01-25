//
//  BRNProduct.h
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNProduct : JSONModel

@property (nonatomic, strong) NSString * star_rating;
@property (nonatomic, strong) NSString * products_name;
@property (nonatomic, strong) NSString * products_length;
@property (nonatomic, strong) NSString * products_width;
@property (nonatomic, strong) NSString * products_height;
@property (nonatomic, strong) NSString * products_description;
@property (nonatomic, strong) NSString * products_id;
@property (nonatomic, strong) NSString * products_quantity;
@property (nonatomic, strong) NSString * products_price;
@property (nonatomic, strong) NSString * products_image;
@property (nonatomic, strong) NSString * products_ship_price;
@property (nonatomic, strong) NSString * products_image_large;
@property (nonatomic, strong) NSString * alcohol_percentage;
@property (nonatomic, strong) NSString * origin_name;
@property (nonatomic, strong) NSString * style_name;
@property (nonatomic, strong) NSArray * other_charges;

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err;

@end

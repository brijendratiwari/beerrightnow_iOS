//
//  BRNCartProduct.h
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNCartProduct : JSONModel

@property (strong, nonatomic) NSString * products_id;
@property (strong, nonatomic) NSString * color_name;
@property (strong, nonatomic) NSString * type_id;
@property (strong, nonatomic) NSString * products_model;
@property (strong, nonatomic) NSString * products_image;
@property (strong, nonatomic) NSString * products_image2;
@property (strong, nonatomic) NSString * products_date_added;
@property (strong, nonatomic) NSString * products_last_modified;
@property (strong, nonatomic) NSString * products_date_available;
@property (strong, nonatomic) NSString * products_weight;
@property (strong, nonatomic) NSString * products_status;
@property (strong, nonatomic) NSString * products_tax_class_id;
@property (strong, nonatomic) NSString * manufacturers_id;
@property (strong, nonatomic) NSString * brand_id;
@property (strong, nonatomic) NSString * products_ordered;
@property (strong, nonatomic) NSString * products_ship_price;
@property (strong, nonatomic) NSString * products_length;
@property (strong, nonatomic) NSString * products_width;
@property (strong, nonatomic) NSString * products_height;
@property (strong, nonatomic) NSString * products_ready_to_ship;
@property (strong, nonatomic) NSString * style_id;
@property (strong, nonatomic) NSString * origin_id;
@property (strong, nonatomic) NSString * alcholol_percentage;
@property (strong, nonatomic) NSString * region_origin;
@property (strong, nonatomic) NSString * producer_id;
@property (strong, nonatomic) NSString * style_type_name;
@property (strong, nonatomic) NSString * vareity_name;
@property (strong, nonatomic) NSString * vintage_year;
@property (strong, nonatomic) NSString * size_name;
@property (strong, nonatomic) NSString * organic;
@property (strong, nonatomic) NSString * kosher;
@property (strong, nonatomic) NSString * prefecture;
@property (strong, nonatomic) NSString * polishing;
@property (strong, nonatomic) NSString * products_name;
@property (strong, nonatomic) NSString * product_count;
@property (strong, nonatomic) NSString * products_price;
@property (strong, nonatomic) NSString * special_price;
@property (strong, nonatomic) NSString * tax;
@property (strong, nonatomic) NSArray * other_charges;

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err;

@end

//
//  BRNOrderItem.h
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNOrderItem : JSONModel

@property (strong, nonatomic) NSString * orders_id;
@property (strong, nonatomic) NSString * date_purchased;
@property (strong, nonatomic) NSString * delivery_name;
@property (strong, nonatomic) NSString * billing_name;
@property (strong, nonatomic) NSString * order_total;
@property (strong, nonatomic) NSString * orders_status_name;
@property (strong, nonatomic) NSString * total_products;

@end

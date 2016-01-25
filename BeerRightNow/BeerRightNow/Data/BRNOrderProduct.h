//
//  BRNOrderProduct.h
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNOrderProduct : JSONModel

@property (strong, nonatomic) NSString * qty;
@property (strong, nonatomic) NSString * id;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * model;
@property (strong, nonatomic) NSString * tax;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * final_price;

@end

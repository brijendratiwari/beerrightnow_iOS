//
//  BRNLiquor.h
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNLiquor : JSONModel

@property (strong, nonatomic) NSString* store;
@property (strong, nonatomic) NSArray* products;
@property (nonatomic) BOOL has_kegs;
@property (nonatomic) float tax;
@property (nonatomic) float products_total;

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err;

@end

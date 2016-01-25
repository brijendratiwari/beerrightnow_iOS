//
//  BRNCartResponse.h
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@class BRNLiquor;
@class BRNBeer;
@class BRNSummary;

@interface BRNCartResponse : JSONModel

@property (strong, nonatomic) BRNLiquor * liquor;
@property (strong, nonatomic) BRNBeer * beer;
@property (strong, nonatomic) NSArray * summary;
@property (nonatomic) float convenience_fee;

-(NSInteger)storeCount;
-(NSInteger)productCount;
-(float)beersPrice;
-(float)liquorsPrice;
-(float)beersTax;
-(float)liquorsTax;
-(float)pickupFee;
-(float)serviceCharge;

-(float)total;
-(float)productsTotal;

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err;

@end

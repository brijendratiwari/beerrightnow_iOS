//
//  BRNCartResponse.m
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNCartResponse.h"
#import "BRNLiquor.h"
#import "BRNBeer.h"
#import "BRNSummary.h"

@implementation BRNCartResponse

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err
{
    self = [super initWithDictionary:dict error:err];
    
    if (self) {
        
        self.liquor = [[BRNLiquor alloc] initWithDictionary:dict[@"liquor"] error:err];
        self.beer = [[BRNBeer alloc] initWithDictionary:dict[@"beer"] error:err];
        self.summary = [BRNSummary arrayOfModelsFromDictionaries:dict[@"summary"]];
    }
    
    return self;
}

-(NSInteger)storeCount
{
    NSInteger count = 0;
    
    @try {
        
        if(_liquor.products.count != 0) {
            
            count ++;
        }
        
        if(_beer.products.count != 0) {
            
            count ++;
        }
        
    } @catch (NSException * exception) {
        
    }
    
    return count;
}

-(NSInteger)productCount
{
    NSInteger count = 0;
    
    @try {
        
        count = _liquor.products.count + _beer.products.count;
        
    }@catch (NSException * exception) {
        
        
    }
    
    return count;
}

-(float)beersPrice
{
    @try {
        
        BRNSummary * summaryBeersPrice = _summary[0];
        return summaryBeersPrice.price;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

-(float)liquorsPrice
{
    @try {
        
        BRNSummary * summaryliquorsPrice = _summary[1];
        return summaryliquorsPrice.price;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

-(float)beersTax
{
    @try {
        
        BRNSummary * summaryBeersTax = _summary[2];
        return summaryBeersTax.price;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

-(float)liquorsTax
{
    @try {
        
        BRNSummary * summaryLiquorsTax = _summary[3];
        return summaryLiquorsTax.price;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

-(float)pickupFee
{
    @try {
        
        BRNSummary * summaryPickupTax = _summary[4];
        return summaryPickupTax.price;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

-(float)serviceCharge
{
    @try {
        
        BRNSummary * summaryServiceCharge = _summary[5];
        return summaryServiceCharge.price;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

-(float)total
{
    return [self beersPrice] + [self liquorsPrice] + [self beersTax] + [self liquorsTax] + [self pickupFee] + self.convenience_fee;
}

-(float)productsTotal
{
    return [self beersPrice] + [self liquorsPrice];
}


@end

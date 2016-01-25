//
//  BRNLiquor.m
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNLiquor.h"
#import "BRNCartProduct.h"

@implementation BRNLiquor

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err
{
    self = [super initWithDictionary:dict error:err];
    
    if (self) {
        
        self.products = [BRNCartProduct arrayOfModelsFromDictionaries:dict[@"products"]];
    }
    
    return self;
}

@end

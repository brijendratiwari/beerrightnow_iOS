//
//  BRNProduct.m
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNProduct.h"
#import "BRNOtherCharge.h"

@implementation BRNProduct

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err
{
    self = [super initWithDictionary:dict error:err];
    
    if (self) {
        
        self.other_charges = [BRNOtherCharge arrayOfModelsFromDictionaries:dict[@"other_charges"]];
    }
    
    return self;
}

@end

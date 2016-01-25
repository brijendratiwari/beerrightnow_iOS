//
//  BRNSummary.m
//  BeerRightNow
//
//  Created by dukce pak on 4/23/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSummary.h"

@implementation BRNSummary

-(float)getPrice
{
    @try {
        
        if([_operator characterAtIndex:0] == '-') {
            
            return _price * (-1);
        }
        
    }@catch (NSException * exception) {
        
    }
    
    return _price;
}

@end

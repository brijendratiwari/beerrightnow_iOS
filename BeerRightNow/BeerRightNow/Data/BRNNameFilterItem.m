//
//  BRNNameFilterItem.m
//  BeerRightNow
//
//  Created by dukce pak on 4/19/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNNameFilterItem.h"

@implementation BRNNameFilterItem

-(NSComparisonResult)compare:(BRNNameFilterItem*)other {
    
    return [self.name compare:other.name];
}

@end

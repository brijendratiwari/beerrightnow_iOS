//
//  BRNUserInfo.m
//  BeerRightNow
//
//  Created by Dragon on 3/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNUserInfo.h"

@implementation BRNUserInfo


-(NSString *)customerName
{
    return [NSString stringWithFormat:@"%@%@", self.customers_firstname, self.customers_lastname];
}

@end

//
//  BRNSummary.h
//  BeerRightNow
//
//  Created by dukce pak on 4/23/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNSummary : JSONModel

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * operator;
@property (nonatomic) float price;

@end

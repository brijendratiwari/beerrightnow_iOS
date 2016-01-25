//
//  BRNProductExtra.h
//  BeerRightNow
//
//  Created by dukce pak on 4/13/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNProductExtra : JSONModel

@property (nonatomic, strong) NSString* total_reviews;
@property (nonatomic, strong) NSString* origin_name;
@property (nonatomic, strong) NSString* alcholol_percentage;
@property (nonatomic, strong) NSString* average_rating;
@end

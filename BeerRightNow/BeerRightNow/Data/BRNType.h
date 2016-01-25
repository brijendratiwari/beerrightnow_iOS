//
//  BRNType.h
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "JSONModel.h"

@interface BRNType : JSONModel

@property (nonatomic, strong) NSString* type_id;
@property (nonatomic, strong) NSString* type_name;
@property (nonatomic, strong) NSString* sort_order;

@end

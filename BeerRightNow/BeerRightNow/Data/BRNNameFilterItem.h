//
//  BRNNameFilterItem.h
//  BeerRightNow
//
//  Created by dukce pak on 4/19/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRNNameFilterItem : NSObject

@property (strong, nonatomic) NSString * name;

-(NSComparisonResult)compare:(BRNNameFilterItem*)other;
@end

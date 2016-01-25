//
//  BRNSection.h
//  BeerRightNow
//
//  Created by dukce pak on 4/5/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRNSection : JSONModel

@property (nonatomic, strong) NSString * sectionid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * lrn;
@property (nonatomic, strong) NSString * brn;
@property (nonatomic, strong) NSString * large_image;

@end

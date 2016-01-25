//
//  BRNUtils.h
//  BeerRightNow
//
//  Created by Dragon on 3/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRNUtils : NSObject

+(BRNUtils *)shared;

-(BOOL) validateEmail:(NSString*)email;
-(BOOL) validatePassword:(NSString*)pwd;

-(NSString *)convertToDecimalPointString:(float)value decimalCount:(NSUInteger)decimalCount;

-(void) setBorder:(UIView *) theView color:(UIColor *)color cornerRadius :(float) cornerRadius borderWidth :(float) borderWidth;

@end

//
//  BRNUtils.m
//  BeerRightNow
//
//  Created by Dragon on 3/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNUtils.h"

#define EMAIL_PARTTERN @"[a-zA-Z0-9._-]+@[a-zA-Z]+\\.+[a-z]+"
#define VALIDATE_PWD_LENGTH 4

@implementation BRNUtils

static BRNUtils * g_brnUtils = nil;

+(BRNUtils *)shared
{
    
    if(g_brnUtils == nil)
        g_brnUtils = [[BRNUtils alloc] init];
    
    return g_brnUtils;
}


-(BOOL) validateEmail:(NSString*)email
{
    
    if(!email)
        return NO;
    
    if ([email rangeOfString:EMAIL_PARTTERN options:NSRegularExpressionSearch].location != NSNotFound)
    
        return YES;
    else
        
        return NO;
}

-(BOOL) validatePassword:(NSString*)pwd
{
    if(!pwd)
        return NO;
    
    if(pwd.length >= VALIDATE_PWD_LENGTH)
        
        return YES;
    else
        
        return NO;
}

-(NSString *)convertToDecimalPointString:(float)value decimalCount:(NSUInteger)decimalCount
{
    if(decimalCount > 0) {
        
        NSMutableString * formatStr = [NSMutableString stringWithString:@"%"];
        [formatStr appendString:[NSString stringWithFormat:@".%ldf", (long)decimalCount]];
        NSString *  strValue = [NSString stringWithFormat:formatStr , value ];
        return  strValue;
    } else {
        
        return [[NSNumber numberWithFloat:value] stringValue];
    }
}

-(void) setBorder:(UIView *) theView color:(UIColor *)color cornerRadius :(float) cornerRadius borderWidth :(float) borderWidth;
{
    theView.layer.borderWidth = borderWidth;
    theView.layer.cornerRadius = cornerRadius;
    theView.layer.borderColor = [color CGColor];
}

@end

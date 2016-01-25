//
//  LoginInfo.m
//  BeerRightNow
//
//  Created by Dragon on 3/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNLoginInfo.h"
#import "BRNUserInfo.h"
#import "Server.h"
#import "BRNCartInfo.h"

#define LOGINED_KEY @"is_logined"

@implementation BRNLoginInfo

static BRNLoginInfo * g_sharedLoginInfo = nil;

+(instancetype) shared
{
    if(g_sharedLoginInfo == nil)
        g_sharedLoginInfo = [[BRNLoginInfo alloc] init];
    
    return g_sharedLoginInfo;
}

-(id)init
{
    self = [super init];
    if(self) {
        
        [self initialize];
    }
    
    return  self;
}

-(void)initialize
{
    NSUserDefaults *sharedPref = [NSUserDefaults standardUserDefaults];
    
    _logined = [sharedPref boolForKey:LOGINED_KEY];
    _zipcode = [sharedPref stringForKey:ZIP_CODE];
    _distributorId = [sharedPref stringForKey:DISTRITUBTOR_ID];
    _lrnDistributorId = [sharedPref stringForKey:LRN_DISTRIBUTOR_ID];
    
    @try {
        
        NSDictionary * userDict = [NSJSONSerialization JSONObjectWithData:[[sharedPref stringForKey:USER_INFO] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        _userInfo = [[BRNUserInfo alloc] initWithDictionary:userDict error:NULL];
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
}

-(void)setLogined:(BOOL)logined {
    
    _logined = logined;
    
    if(logined) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGINED_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        [self clear];
    }
}

-(void)setLrnDistributorId:(NSString *)lrnDistributorId {
    
    _lrnDistributorId = lrnDistributorId;
    
    [[NSUserDefaults standardUserDefaults] setObject:lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setDistributorId:(NSString *)distributorId {
    
    _distributorId = distributorId;
    
    [[NSUserDefaults standardUserDefaults] setObject:distributorId forKey:DISTRITUBTOR_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setZipcode:(NSString *)zipcode {
    
    _zipcode = zipcode;
    
    [[NSUserDefaults standardUserDefaults] setObject:zipcode forKey:ZIP_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[BRNCartInfo shared] removeCarts];
}

-(void)setUserInfo:(BRNUserInfo *)userInfo
{
    
    @try {
        
        _userInfo = userInfo;
        
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo toJSONString] forKey:USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
}

-(void)setDefaultAddressId:(NSString*)addressId
{
    [self.userInfo setCustomers_default_address_id:addressId];
    [[NSUserDefaults standardUserDefaults] setObject:[self.userInfo toJSONString] forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clear
{
    NSUserDefaults * sharedPref = [NSUserDefaults standardUserDefaults];
    
    [sharedPref removeObjectForKey:LOGINED_KEY];
    [sharedPref removeObjectForKey:DISTRITUBTOR_ID];
    [sharedPref removeObjectForKey:LRN_DISTRIBUTOR_ID];
    [sharedPref removeObjectForKey:ZIP_CODE];
    [sharedPref removeObjectForKey:USER_INFO];
    
    [sharedPref synchronize];
    
    [self initialize];
}


@end

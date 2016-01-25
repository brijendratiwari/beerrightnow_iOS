//
//  AppDelegate.m
//  BeerRightNow
//
//  Created by Dragon on 3/26/15.
//  Copyright (c) 2015 jon. All rights reserved.
/*
 
 try jon@beerrightnow.com
 pass: zip100
 add a small item (like ice) in zipcode 10003
 
 american express
372322723993000
03/20 9884
address: 26 n maple ave
marlton, nj 08053
test order , do not deliver!
*/

#import "AppDelegate.h"
#import "ImageCacheManager.h"
#import "JSONModel+networking.h"
#import "BRNLoginInfo.h"
#import "Constants.h"
#import "BRNFlowManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize takeBreak= _takeBreak;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        
        // do stuff for iOS 7 and newer
        [[UINavigationBar appearance]  setBarTintColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.19 alpha:1]];
        
    }
    else {
        
        // do stuff for older versions than iOS 7
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.19 alpha:1]];
        
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [ImageCacheManager initCacheDirectory];
    
    //[JSONHTTPClient setTimeoutInSeconds:5];
    
    [[BRNFlowManager shared] setWindow:self.window];
    [[BRNFlowManager shared] willShowHome];
    
    [FBSDKLoginButton class];
    
    if (!_takeBreak) {
        dispatch_queue_t q = dispatch_queue_create("loadUrl", nil);
        dispatch_async(q, ^{
            NSURL *restURI = [NSURL URLWithString:@"https://www.iwantbeerrightnow.com/blog/"];
            NSString *breakText = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:restURI] encoding:NSUTF8StringEncoding];
            [self performSelectorOnMainThread:@selector(setTakeBreak:) withObject:breakText waitUntilDone:YES];
        });
    }

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}


- (void)setTakeBreak:(NSString *)takeBreak {
    _takeBreak = takeBreak;
}

- (NSString *)takeBreak {
    return _takeBreak;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end

//
//  BRNFlowManager.m
//  BeerRightNow
//
//  Created by dukce pak on 4/5/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNFlowManager.h"

#import "Constants.h"
#import "BRNLoginInfo.h"
#import "BRNLeftMenuController.h"
#import "BRNRightFilterController.h"

static BRNFlowManager *  g_sharedFlowManager = nil;

@interface BRNFlowManager (){
    
    UIWindow * window;
   
}

@property (strong, nonatomic)  MFSideMenuContainerViewController * slideMenuContainerController;
@property (strong, nonatomic)  BRNLeftMenuController * leftMenuController;
@property (strong, nonatomic)  BRNRightFilterController * rightFilterController;

@property (strong, nonatomic) UIStoryboard * storyBoard;
@end

@implementation BRNFlowManager

+(instancetype)shared
{
    if(g_sharedFlowManager == nil)
        g_sharedFlowManager = [[BRNFlowManager alloc] init];
    
    return g_sharedFlowManager;
}

-(id)init
{
    self = [super init];
    if(self) {
        
        _storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _leftMenuController = [_storyBoard instantiateViewControllerWithIdentifier:kMFSlideLeftControllerIdentifier];
        _rightFilterController = [_storyBoard instantiateViewControllerWithIdentifier:kMFSlideRightControllerIdentifier];
        
    }
    
    return self;
}


-(UIStoryboard *)storyBoardForMain
{
    return _storyBoard;
}

-(void) willShowHome
{
    
    @try {
        
        if(![[BRNLoginInfo shared] logined]) {
            
            UINavigationController * navigationController = (UINavigationController *) [_storyBoard instantiateViewControllerWithIdentifier:kLoginNavigationControllerIdentifier];
            
            self->window.rootViewController = navigationController;
            
        } else if([[BRNLoginInfo shared] zipcode] == nil){
            
            UINavigationController * navigationController = (UINavigationController *) [_storyBoard instantiateViewControllerWithIdentifier:kLoginNavigationControllerIdentifier];
            UIViewController * zipcodeController = (UIViewController*) [_storyBoard instantiateViewControllerWithIdentifier:kZipcodeControllerIdentifier];
            
            [navigationController setViewControllers:[NSArray arrayWithObject:zipcodeController]];
            
            self->window.rootViewController = navigationController;
            
        } else {
            
            UINavigationController *navigationController = [_storyBoard instantiateViewControllerWithIdentifier:kMFSlideCenterControllerIdentifier];

            _slideMenuContainerController = [MFSideMenuContainerViewController containerWithCenterViewController:navigationController leftMenuViewController:nil rightMenuViewController:nil];
            
            self->window.rootViewController = _slideMenuContainerController;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
    
}

-(void)setPanMode:(MFSideMenuPanMode)panMode
{
    @try {
        
        _slideMenuContainerController.panMode = panMode;
    } @catch (NSException * exception) {
        
        [exception reason];
    }
}

-(void)setLeftMenuController:(BOOL)will
{
    if(will) {
        
        [_slideMenuContainerController setLeftMenuViewController:_leftMenuController];
    } else {
        [_slideMenuContainerController setLeftMenuViewController:nil];
    }
    
}


-(void)setRightFilterController:(BOOL)will
{
    if(will) {
        
        [_slideMenuContainerController setRightMenuViewController:_rightFilterController];
    } else {
        
        [_slideMenuContainerController setRightMenuViewController:nil];
    }
}

-(BRNRightFilterController*)filterController
{
    return _rightFilterController;
}

-(void)setWindow:(UIWindow*)wnd
{
    self->window = wnd;
}

@end

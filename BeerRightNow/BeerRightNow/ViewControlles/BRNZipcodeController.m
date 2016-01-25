//
//  BRNZipcodeController.m
//  BeerRightNow
//
//  Created by Dragon on 4/2/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNZipcodeController.h"

#import "BRNLoginInfo.h"
#import "BRNCartInfo.h"
#import "BRNUserInfo.h"
#import "BRNSignInfo.h"
#import "Server.h"
#import "Constants.h"
#import "BRNFlowManager.h"

@interface BRNZipcodeController()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;

@end

@implementation BRNZipcodeController

-(void)viewDidLoad
{
    [self initUI];
}

-(void)initUI
{
    if([self.navigationController viewControllers].count == 1)
        [self.navigationItem setLeftItemsSupplementBackButton:NO];
    else
        [self initializeLeftButtonItem];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:bottomConstraint];
    
    
    [_keyAvoidingScrollView contentSizeToFit];
    
    if (_signInfo.zipcode)
    {
        _zipcodeField.text = _signInfo.zipcode;
        [self zipcodeTask];
        _signInfo = nil;
    }
    
}

-(void)zipcodeTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_zipcodeField text] forKey:ZIP_CODE];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(CHECK_ZIPCODE) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
//                                               [self.view makeToast:[err localizedDescription]];
                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:[err localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                               [alertView show];
                                           } else if (json != nil){
                                               
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   [[BRNLoginInfo shared] setZipcode:_zipcodeField.text];
                                                   
                                                   
                                                   [[BRNLoginInfo shared] setDistributorId:json[DATA][DISTRITUBTOR_ID]];
                                                   [[BRNLoginInfo shared] setLrnDistributorId:json[DATA][LRN_DISTRIBUTOR_ID]];
                                                   [[BRNFlowManager shared] willShowHome];
                                               } else {
                                                   
                                                   
//                                                   [self.view makeToast:@"Zipcode not supported."];
                                                   UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Zipcode not supported." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                   [alertView show];
                                               }
                                               
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           NSLog(@"%@", exception.reason);
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                       
                                   }];
}


- (IBAction)goClicked:(id)sender
{
    
    if ([_zipcodeField.text length] == 0) {
        
        [_zipcodeField setTextColor:[UIColor redColor]];
        
//        [self.view makeToast:ALL_FIELDS_FILL];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:ALL_FIELDS_FILL delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([_zipcodeField.text length] != 5) {
        
        [_zipcodeField setTextColor:[UIColor redColor]];
        
//        [self.view makeToast:VALID_ZIPCODE];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:VALID_ZIPCODE delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [_zipcodeField setTextColor:[UIColor blackColor]];
    
    [self zipcodeTask];
}
@end

//
//  ViewController.m
//  BeerRightNow
//
//  Created by Dragon on 3/26/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNLoginViewController.h"

#import "BRNUtils.h"
#import "BRNLoginInfo.h"
#import "BRNCartInfo.h"
#import "BRNUserInfo.h"
#import "Server.h"
#import "Constants.h"
#import "BRNSignInfo.h"

#import "BRNSignAddUserController.h"
#import "BRNZipcodeController.h"

@interface BRNLoginViewController ()

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation BRNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
}

-(void)initUI
{
//    [_emailField setText:@"test@test.com"];
//    [_pwdField setText:@"12345678"];
    
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
    
    [_keyAvoidingScrollView contentSizeToFit];
}

- (IBAction)loginClicked:(id)sender {
    
    [_emailField setTextColor:[UIColor blackColor]];
    [_pwdField setTextColor:[UIColor blackColor]];
    
    [_emailField setText:[_emailField.text lowercaseString]];
    if ([_emailField.text length] == 0) {
        
        [_emailField setTextColor:[UIColor redColor]];
//        [self.view makeToast:ALL_FIELDS_FILL];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:ALL_FIELDS_FILL delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    if ([_pwdField.text length] == 0) {
        
        [_pwdField setTextColor:[UIColor redColor]];
        
//        [self.view makeToast:ALL_FIELDS_FILL];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:ALL_FIELDS_FILL delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    
    if(![[BRNUtils shared] validateEmail:_emailField.text]) {
        
        
        [_emailField setTextColor:[UIColor redColor]];
//        [self.view makeToast:VALID_EMAIL];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:VALID_EMAIL delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[_emailField text] forKey:@"email"];
    [dic setObject:[_pwdField text] forKey:@"password"];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(USER_AUTH) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       if(err != nil) {
                                           
//                                           [self.view makeToast:[err localizedDescription]];
                                           
                                           UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:[err localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                           [alertView show];
                                           
                                       } else if (json != nil){
                                           
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               [[BRNLoginInfo shared] setLogined:YES];
                                               
                                               BRNUserInfo * userInfo = [[BRNUserInfo alloc] initWithDictionary:json[USER_INFO] error:NULL];
                                               [[BRNLoginInfo shared] setUserInfo:userInfo];
                                               
                                               [self performSegueWithIdentifier:kConfirmZipcodeIdentifier sender:nil];

                                           } else {
                                               
//                                               [self.view makeToast:json[ERROR]];
                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:json[ERROR] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                               [alertView show];
                                           }
                                           
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];

    }];
    
    
    /*

    NSMutableString * apiUrl = [[NSMutableString alloc] init];
    [apiUrl appendString:API_URL];
    [apiUrl appendString:USER_AUTH];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:apiUrl parameters:dic
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"%@", operation.responseString);
              
              NSDictionary *jsonDict = nil;
              if (operation.responseString) {
                  NSError *e;
                  jsonDict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&e];
              }
              
              [HUD hideUIBlockingIndicator];
              
          }
          failure:^(AFHTTPRequestOperation * operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [HUD hideUIBlockingIndicator];
              
          }];
     */
}

-(IBAction)returned:(UIStoryboardSegue*)seque
{
    if(_signInfo) {
        
        _emailField.text = _signInfo.email;
        _pwdField.text = _signInfo.password;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(segue.identifier != nil && [segue.identifier isEqualToString:kSignAddUserControllerIdentifier]) {
        
        BRNSignAddUserController * addUserController = (BRNSignAddUserController*)segue.destinationViewController;
        self.signInfo = [[BRNSignInfo alloc] init];
        addUserController.signInfo = self.signInfo;
    }
    else if(_signInfo && [segue.identifier isEqualToString:kConfirmZipcodeIdentifier]) {
        
        BRNZipcodeController * addUserController = (BRNZipcodeController*)segue.destinationViewController;
        addUserController.signInfo = self.signInfo;
    }
}

@end

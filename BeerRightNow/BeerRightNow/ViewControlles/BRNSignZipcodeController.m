//
//  BRNSignZipcodeController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/15/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSignZipcodeController.h"
#import "BRNSignAddressController.h"
#import "BRNSignInfo.h"

@interface BRNSignZipcodeController ()

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation BRNSignZipcodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
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
    
    [_keyAvoidingScrollView contentSizeToFit];

    _zipcodeField.text = _signInfo.zipcode;
    
    
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
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           } else if (json != nil){
                                               
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   _titleLabel.text = @"Cheers!";
                                                   _titleLabel.textColor = [UIColor greenColor];
                                                   _messageLabel.text = @"Yay! We serve this zipcode! :)";
                                                   [_messageLabel sizeToFit];
                                                   
                                                   _signInfo.zipcode = _zipcodeField.text;
                                                   
                                                   [[BRNLoginInfo shared] setZipcode:_zipcodeField.text];
                                                   [[BRNLoginInfo shared] setDistributorId:json[DATA][DISTRITUBTOR_ID]];
                                                   [[BRNLoginInfo shared] setLrnDistributorId:json[DATA][LRN_DISTRIBUTOR_ID]];
                                                   [self performSegueWithIdentifier:kSignAddressControllerIdentifier sender:nil];
                                               } else {
                                                   
                                                   _titleLabel.text = @"Hic!";
                                                   _titleLabel.textColor = [UIColor redColor];
                                                   _messageLabel.text = @"We're sorry! We don't serve in the zipcode you entered! Is there any other place where you can get your delivery?";
                                                   [_messageLabel sizeToFit];
                                               }
                                               
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           NSLog(@"%@", exception.reason);
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                       
                                   }];
}

- (IBAction)continueClicked:(id)sender {
    
    if ([_zipcodeField.text length] == 0) {
        
        [_zipcodeField setTextColor:[UIColor redColor]];
        
        [self.view makeToast:ALL_FIELDS_FILL];
        return;
    }
    
    
    if ([_zipcodeField.text length] != 5) {
        
        [_zipcodeField setTextColor:[UIColor redColor]];
        
        [self.view makeToast:VALID_ZIPCODE];
        return;
    }
    
    [_zipcodeField setTextColor:[UIColor blackColor]];
    
    [self zipcodeTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    BRNSignAddressController * addressController = (BRNSignAddressController*)segue.destinationViewController;
    addressController.signInfo = self.signInfo;
    addressController.fromSign = YES;
}

@end

//
//  BRNSignAddressController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/16/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSignAddressController.h"
#import "BRNSignInfo.h"
#import "BRNSignConfirmController.h"

@interface BRNSignAddressController ()

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *suiteField;
@property (weak, nonatomic) IBOutlet UITextField *recipientPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;

@end

@implementation BRNSignAddressController

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
    
    _firstNameField.text = _signInfo.firstName;
    _lastNameField.text = _signInfo.lastName;
    _recipientPhoneField.text = _signInfo.phone;
    _zipcodeField.text = _signInfo.zipcode;
    
    if(!_fromSign) {
        
        [_continueBtn setBackgroundColor:[UIColor redColor]];
        [_continueBtn setImage:nil forState:UIControlStateNormal];
        [_continueBtn setContentEdgeInsets:UIEdgeInsetsZero];
        [_continueBtn setImageEdgeInsets:UIEdgeInsetsZero];
        [_continueBtn setTitle:@"Save" forState:UIControlStateNormal];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _continueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _continueBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
}

-(void)registerTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:_signInfo.customerId forKey:CUSTOMER_ID];
    [dic setObject:_firstNameField.text forKey:@"firstname"];
    [dic setObject:_lastNameField.text forKey:@"lastname"];
    [dic setObject:_streetAddressField.text forKey:@"street_address"];
    [dic setObject:_recipientPhoneField.text forKey:@"phone"];
    [dic setObject:_cityField.text forKey:@"city"];
    [dic setObject:_stateField.text forKey:@"state"];
    [dic setObject:_zipcodeField.text forKey:@"address_zipcode"];
    [dic setObject:_suiteField.text forKey:@"suite"];
    [dic setObject:_signInfo.email forKey:@"email"];
    
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(ADD_ADDRESS) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:err.localizedDescription];
                                               
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   _signInfo.streetAddress = _streetAddressField.text;
                                                   _signInfo.city = _cityField.text;
                                                   _signInfo.state = _stateField.text;
                                                   _suiteField.text = _signInfo.suite;
                                                   if(_fromSign) {
                                                       
                                                       [self performSegueWithIdentifier:kSignConfirmControllerIdentifier sender:nil];
                                                   } else {
                                                       
                                                       [self backClicked];
                                                   }
                                                   
                                               }
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil)
                                           [self.view makeToast:[err localizedDescription]];
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
}

- (IBAction)continueClicked:(id)sender {
    
    if (_firstNameField.text.length == 0 || _lastNameField.text.length == 0 || _streetAddressField.text.length == 0
        || _zipcodeField.text.length == 0 || _cityField.text.length == 0 || _stateField.text.length == 0) {
        
        [self.view makeToast:ALL_FIELDS_FILL];
        return;
    }
    
    if ([_zipcodeField.text length] != 5) {
        
        [_zipcodeField setTextColor:[UIColor redColor]];
        
        [self.view makeToast:VALID_ZIPCODE];
        return;
    }
    
    [self registerTask];
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
    
    BRNSignConfirmController * confirmController = (BRNSignConfirmController*)segue.destinationViewController;
    confirmController.signInfo = self.signInfo;
}

@end

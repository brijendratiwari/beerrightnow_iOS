//
//  BRNUpdateAddressAlert.m
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNUpdateAddressAlert.h"
#import "BRNAddress.h"

@interface BRNUpdateAddressAlert () {
    
    BRNAddress * _address;
}

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *suiteField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation BRNUpdateAddressAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_address) {
        
        _firstNameField.text = _address.firstname;
        _lastNameField.text = _address.lastname;
        _streetField.text = _address.street_address;
        _stateField.text = _address.state;
        _suiteField.text = _address.suite;
        _cityField.text = _address.city;
        _zipcodeField.text = _address.address_zipcode;
        _phoneField.text = _address.phone;
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
    [_backgroundView addGestureRecognizer:tapRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroundViewTapped:(UIGestureRecognizer *)sender {
    
    [self cancelClicked:sender];
}

- (IBAction)saveClicked:(id)sender {
    
    if (_firstNameField.text.length == 0 || _lastNameField.text.length == 0 || _cityField.text.length == 0
        || _streetField.text.length == 0 || _zipcodeField.text.length == 0 || _stateField.text.length == 0) {
        
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
    
    [self updateAddressTask];
}
- (IBAction)cancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setAddress:(BRNAddress*)address
{
    _address = address;
}

-(void)updateAddressTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_email_address forKey:@"email"];
    [dic setObject:_firstNameField.text forKey:@"firstname"];
    [dic setObject:_lastNameField.text forKey:@"lastname"];
    [dic setObject:_suiteField.text forKey:@"suite"];
    [dic setObject:_phoneField.text forKey:@"phone"];
    [dic setObject:_streetField.text forKey:@"street_address"];
    [dic setObject:_cityField.text forKey:@"city"];
    [dic setObject:_stateField.text forKey:@"state"];
    [dic setObject:_zipcodeField.text forKey:@"address_zipcode"];
    [dic setObject:_address.address_id forKey:@"address_id"];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(UPDATE_ADDRESS) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:err.localizedDescription];
                                               
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   if(_delegate && [_delegate respondsToSelector:@selector(updatedAddress:)]) {
                                                       
                                                       _address.firstname =_firstNameField.text;
                                                       _address.lastname = _lastNameField.text;
                                                       _address.suite = _suiteField.text;
                                                       _address.phone = _phoneField.text;
                                                       _address.state = _stateField.text;
                                                       _address.street_address = _streetField.text;
                                                       _address.city = _cityField.text;
                                                       _address.address_zipcode = _zipcodeField.text;
                                                       
                                                       [_delegate updatedAddress:_address];
                                                   }
                                                   
                                               }
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           }
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

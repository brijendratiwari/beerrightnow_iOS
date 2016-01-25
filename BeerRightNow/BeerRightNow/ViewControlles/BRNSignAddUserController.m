//
//  BRNSignAddUserController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/14/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSignAddUserController.h"
#import "BRNSignInfo.h"
#import "BRNSignZipcodeController.h"

@interface BRNSignAddUserController ()<FBSDKLoginButtonDelegate> {
    
    NSDateFormatter * _dateFormatter;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginBtn;

@property (strong, nonatomic) NSDate * date;

@end

@implementation BRNSignAddUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
    _fbLoginBtn.readPermissions = @[@"public_profile", @"email"];
    [_fbLoginBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    _fbLoginBtn.delegate = self;
    
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
    
    _date = nil;
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:DATEONLY_FORMAT];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [self gettingMe];
    }
}

-(void)gettingMe {
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             _emailField.text = result[@"email"];
             _firstNameField.text = result[@"first_name"];
             _lastNameField.text = result[@"last_name"];
         }
     }];
}

-(void)registerTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_firstNameField.text forKey:@"firstname"];
    [dic setObject:_lastNameField.text forKey:@"lastname"];
    [dic setObject:_emailField.text forKey:@"emailid"];
    [dic setObject:_mobileField.text forKey:@"mobile"];
    [dic setObject:_birthdayLabel.text forKey:@"dateofbirth"];
    [dic setObject:_pwdField.text forKey:@"password"];
    [dic setObject:_zipcodeField.text forKey:ZIP_CODE];
    
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(ADD_USER) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               self.signInfo.firstName = _firstNameField.text;
                                               self.signInfo.lastName = _lastNameField.text;
                                               self.signInfo.email = _emailField.text;
                                               self.signInfo.password = _pwdField.text;
                                               self.signInfo.zipcode = _zipcodeField.text;
                                               self.signInfo.phone = _mobileField.text;
                                               self.signInfo.customerId = json[@"userid"];
                                               
                                               
                                               [self performSegueWithIdentifier:kSignZipcodeControllerIdentifier sender:nil];
                                               
                                           } else {
                                               
                                               [self.view makeToast:json[MESSAGE]];
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil)
                                               [self.view makeToast:[err localizedDescription]];
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
}

- (IBAction)datePickerClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    BRNDatePickerAlert * datePickerAlert = [[BRNDatePickerAlert alloc] init];
    if(_date) {
        [datePickerAlert setDate:_date];
    }
    [datePickerAlert setDatePickerMode:UIDatePickerModeDate];
    datePickerAlert.delegate = self;
//    [_datePickerAlert showInView:self.view animated:YES];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        
        self.providesPresentationContextTransitionStyle  = YES;
        self.definesPresentationContext = YES;
        datePickerAlert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    } else {
        
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [self presentViewController:datePickerAlert animated:YES completion:nil];
}

- (IBAction)continueClicked:(id)sender {
    
    [_emailField setText:[_emailField.text lowercaseString]];
    if (_emailField.text.length != 0 && ![[BRNUtils shared] validateEmail:_emailField.text]) {
        
        [self.view makeToast:VALID_EMAIL];
        return;
    }

    if (_pwdField.text.length != 0 && _confirmField.text.length == 0) {
        
        [self.view makeToast:@"Retype password"];
        return;
    }

    if (![_confirmField.text isEqualToString:_pwdField.text]) {
        
        _pwdField.text = @"";
        _confirmField.text = @"";
        
        [self.view makeToast:@"Confirm Password"];
        return;
        
    }

    if (_firstNameField.text.length == 0 || _lastNameField.text.length == 0 || _emailField.text.length == 0
        || _pwdField.text.length == 0 || _zipcodeField.text.length == 0) {
        
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
    
    BRNSignZipcodeController * zipcodeController = (BRNSignZipcodeController*)segue.destinationViewController;
    zipcodeController.signInfo = self.signInfo;
    
}
#pragma mark Date Picker Delegate

-(void)onDatePicker:(NSDate *)date
{
    _date = date;
    if(_date) {
        
        _birthdayLabel.text = [_dateFormatter stringFromDate:_date];
    }
}

#pragma mark FBLoginButtonDelegate

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    
    if(!error) {
        
        [self gettingMe];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
    _emailField.text = @"";
    _firstNameField.text = @"";
    _lastNameField.text = @"";
}

@end

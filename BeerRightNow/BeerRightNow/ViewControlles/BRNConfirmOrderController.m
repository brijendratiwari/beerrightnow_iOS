//
//  BRNConfirmOrderController.m
//  BeerRightNow
//
//  Created by Dragon on 4/29/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNConfirmOrderController.h"
#import "BRNCreditCardController.h"
#import "CreditCard.h"
#import "BRNOrderCompleteController.h"

@interface BRNConfirmOrderController ()

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation BRNConfirmOrderController

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
    
    _commentLabel.text = [BRNCartInfo shared].deliveryComment;
    _cardNumLabel.text = [BRNCartInfo shared].cardNumber;
    _expiryLabel.text = [BRNCartInfo shared].cardExpires;
    _totalLabel.text = [NSString stringWithFormat:@"$%@",[[BRNUtils shared] convertToDecimalPointString:[BRNCartInfo shared].totalPay decimalCount:2 ]];
    
    [self defaultAddressTask];
}

-(void)defaultAddressTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_default_address_id forKey:@"address_id"];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_ADDRESS) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:err.localizedDescription];
                                               
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   _addressLabel.text = [NSString stringWithFormat:@"%@ %@", json[DATA][@"firstname"], json[DATA][@"lastname"]];
                                                   _streetLabel.text = json[DATA][@"street_address"];
                                                   _cityLabel.text = [NSString stringWithFormat:@"%@ %@", json[DATA][@"city"], json[DATA][@"state"]];
                                                   _zipcodeLabel.text = json[DATA][@"address_zipcode"];
                                                   
                                               } else {
                                                   
                                                   [self.view makeToast:json[MESSAGE]];
                                               }
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           }
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)orderClicked:(id)sender {
    
//    [self performSegueWithIdentifier:kOrderCompleteControllerIdentifier sender:nil];
//    return;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_default_address_id forKey:@"address_id"];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_email_address forKey:@"customer_email"];
    [dic setObject:[[BRNCartInfo shared] cartData] forKey:DATA];
    [dic setObject:[BRNCartInfo shared].deliveryComment forKey:@"comments"];
    [dic setObject:[NSNumber numberWithFloat:[BRNCartInfo shared].serviceTip] forKey:@"tip"];
    [dic setObject:[BRNCartInfo shared].billingName forKey:@"billing_name"];
    [dic setObject:[BRNCartInfo shared].billingAddres forKey:@"billing_street_address"];
    [dic setObject:[BRNCartInfo shared].billingCity forKey:@"billing_city"];
    [dic setObject:[BRNCartInfo shared].billingPostCode forKey:@"billing_postcode"];
    [dic setObject:[BRNCartInfo shared].billingState forKey:@"billing_state"];
    [dic setObject:[BRNCartInfo shared].billingCountry forKey:@"billing_country"];
    
    CreditCard * card = [BRNCreditCardController cardArray][[BRNCartInfo shared].cardType];
    [dic setObject:card.cardName forKey:@"cc_type"];
    [dic setObject:[BRNCartInfo shared].cardNumber forKey:@"cc_number"];
    [dic setObject:[BRNCartInfo shared].cardExpires forKey:@"cc_expires"];
    [dic setObject:[BRNCartInfo shared].cardCVV forKey:@"cc_cvv"];
    [dic setObject:[BRNCartInfo shared].executive ? @"yes" : @"no" forKey:@"isexecutive"];
    if ([BRNCartInfo shared].deliveryLiquorExpected && ![BRNCartInfo shared].saveLiquoeInCart)
    {
        [dic setObject:[BRNCartInfo shared].deliveryExpected forKey:@"expected_beer_delivery"];
        [dic setObject:[BRNCartInfo shared].deliveryLiquorExpected forKey:@"expected_liquor_delivery"];
    }
    else
    {
        [dic setObject:[BRNCartInfo shared].deliveryExpected forKey:@"expected_delivery"];
    }
    [dic setObject:[BRNCartInfo shared].gift ? @"yes" : @"no" forKey:@"is_gift"];
    [dic setObject:[BRNCartInfo shared].customerNumber forKey:@"customer_number"];
    [dic setObject:[BRNCartInfo shared].giftForNumber forKey:@"gift_for_number"];
    [dic setObject:[BRNCartInfo shared].corporateOrder ? @"yes" : @"no" forKey:@"is_corporate_order"];
    [dic setObject:[BRNCartInfo shared].officeExtension forKey:@"office_extensijon"];
    [dic setObject:[BRNCartInfo shared].contactCell forKey:@"contact_cell"];
    [dic setObject:[BRNCartInfo shared].serviceEnterenceAddress forKey:@"service_enterence_address"];
    [dic setObject:@"1" forKey:@"device"];
    
    [HUD showUIBlockingIndicatorWithText:@"Processing Order..."];
    
    //NSLog(@"send paramter===>%@",dic);
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(PLACE_ORDER) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       NSLog(@"response of order string====>%@",json);
                                      //NSLog(@"err==%@ \n localise desc===>%@",err,[err localizedDescription]);
                                       //[[[UIAlertView alloc] initWithTitle:@"Sanju" message:[NSString stringWithFormat:@"%@",json] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:err.localizedDescription];
                                               
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   [[BRNCartInfo shared] orderProcessed];
                                                   
                                                   NSString * orderId = json[DATA][@"order_id"];
                                                   [self performSegueWithIdentifier:kOrderCompleteControllerIdentifier sender:orderId];
                                                   
                                               } else {
                                                   
                                                   if (json[DATA])
                                                   {
                                                       [self.view makeToast:json[DATA][MESSAGE]];
                                                   }
                                                   else
                                                   {
                                                       [self.view makeToast:json[MESSAGE]];
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
                                   }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:kOrderCompleteControllerIdentifier]) {
        
        BRNOrderCompleteController * orderCompleteController = (BRNOrderCompleteController*)segue.destinationViewController;
        orderCompleteController.orderId = sender;
    }
}

@end

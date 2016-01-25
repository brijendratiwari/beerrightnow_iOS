//
//  BRNShippingAddressController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/26/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNShippingAddressController.h"
#import "BRNAddress.h"
#import "BRNShippingAddressCell.h"
#import "BRNSignAddressController.h"
#import "BRNSignInfo.h"
#import "BRNCartResponse.h"
#import "BRNDeliveryController.h"

@interface BRNShippingAddressController () {
    
    NSMutableArray * _addressArr;
    BRNAddress * _willRemoveAddress;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *deliveyView;
@property (weak, nonatomic) IBOutlet UIButton *sameChecked;


@end

@implementation BRNShippingAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addressTask];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_sameChecked.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    if(_fromLeftMenu) {
        
        [_deliveyView hideByHeight:YES];
    }
    
    [_sameChecked setSelected:YES];
}

-(void)reload
{
    [_tableView reloadData];
    
    for(NSInteger i = 0 ; i < _addressArr.count ; i++) {
        
        BRNAddress * address = _addressArr[i];
        if([[BRNLoginInfo shared].userInfo.customers_default_address_id isEqualToString:address.address_id]) {
            
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addressTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_ADDRESSES) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:err.localizedDescription];
                                               
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   _addressArr = [BRNAddress arrayOfModelsFromDictionaries:json[DATA]];
                                                
                                                   [self reload];
                                                   
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

-(void)removeAddressClicked:(id)sender
{
    @try {
        
        UIButton * btn = sender;
        _willRemoveAddress = _addressArr[btn.tag];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Would you like to delete it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView show];
    } @catch (NSException * exception) {
        
    }
}

-(void)editAddressClicked:(id)sender
{
    @try {
        
        UIButton * btn = sender;
        BRNAddress * address = _addressArr[btn.tag];
        
        BRNUpdateAddressAlert * updateAddressAlert = [[BRNUpdateAddressAlert alloc] init];
        updateAddressAlert.delegate = self;
        [updateAddressAlert setAddress:address];
        
        if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
            
            self.providesPresentationContextTransitionStyle  = YES;
            self.definesPresentationContext = YES;
            updateAddressAlert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
        } else {
            
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        [self presentViewController:updateAddressAlert animated:YES completion:nil];
        
    }@catch (NSException *  exception) {
        
    }
}
- (IBAction)sameClicked:(id)sender {
    
    [_sameChecked setSelected:!_sameChecked.selected];
}

- (IBAction)otherClicked:(id)sender {
    
    [self performSegueWithIdentifier:kAddAddressControllerIdentifier sender:nil];
}

- (IBAction)deliveryClicked:(id)sender {
    
    if(_sameChecked.selected) {
        
        @try {
            
            for (id object in _addressArr) {
                
                if([object isKindOfClass:[BRNAddress class]]) {
                    
                    BRNAddress * address = (BRNAddress*)object;
                    if([address.address_id isEqualToString:[BRNLoginInfo shared].userInfo.customers_default_address_id]) {
                        
                        [BRNCartInfo shared].billingName = [NSString stringWithFormat:@"%@%@%@", address.firstname , @" ", address.lastname];
                        [BRNCartInfo shared].billingAddres = address.street_address;
                        [BRNCartInfo shared].billingCity = address.city;
                        [BRNCartInfo shared].billingSuite = address.suite;
                        [BRNCartInfo shared].billingPostCode = address.address_zipcode;
                        [BRNCartInfo shared].billingState = address.state;
                        
                    }
                }
            }
            
        } @catch (NSException * exception) {
            
            NSLog(@"%@", exception.reason);
        }
    }
    
    [self performSegueWithIdentifier:kDeliveryOptionControllerIdentifier sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:kAddAddressControllerIdentifier]) {
        
        BRNSignAddressController * addressController = (BRNSignAddressController*) segue.destinationViewController;
        addressController.fromSign  = NO;
        BRNSignInfo * signInfo = [[BRNSignInfo alloc] init];
        signInfo.firstName = [BRNLoginInfo shared].userInfo.customers_firstname;
        signInfo.lastName = [BRNLoginInfo shared].userInfo.customers_lastname;
        signInfo.customerId = [BRNLoginInfo shared].userInfo.customers_id;
        signInfo.email = [BRNLoginInfo shared].userInfo.customers_email_address;
        signInfo.phone = [BRNLoginInfo shared].userInfo.customers_telephone;
        addressController.signInfo = signInfo;
    }
    else if([segue.identifier isEqualToString:kDeliveryOptionControllerIdentifier]) {
        
        BRNDeliveryController * deliveryController = (BRNDeliveryController*) segue.destinationViewController;
        deliveryController.cartResponse = _cartResponse;
       
    }
}


-(void) updatedAddress:(BRNAddress*)address
{
    [self reload];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && _willRemoveAddress) {
        
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
        [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
        [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
        [dic setObject:_willRemoveAddress.address_id forKey:@"address_id"];
        [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
        
        [HUD showUIBlockingIndicator];
        
        [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(DELETE_ADDRESS) params:dic
                                       completion:^(NSDictionary * json, JSONModelError * err) {
                                           
                                           @try {
                                               
                                               if(err != nil) {
                                                   
                                                   [self.view makeToast:err.localizedDescription];
                                                   
                                               } else {
                                                   
                                                   if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                       
                                                       [_addressArr removeObject:_willRemoveAddress];
                                                       [self reload];
                                                       
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
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        
        BRNAddress * address = _addressArr[indexPath.row];
        [[BRNLoginInfo shared] setDefaultAddressId:address.address_id];
        [self reload];
        
    }@catch (NSException * exception) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    @try {
        
        return  _addressArr.count;
        
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRNShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kShippingAddressControllerIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNShippingAddressCell" bundle:nil] forCellReuseIdentifier:kShippingAddressControllerIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kShippingAddressControllerIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.defaultBtn.tag = indexPath.row;
    [cell.defaultBtn addTarget:self action:@selector(removeAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    BRNAddress * address = _addressArr[indexPath.row];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@", address.firstname, address.lastname];
    cell.streetLabel.text = address.street_address;
    cell.cityLabel.text = [NSString stringWithFormat:@"%@ %@", address.city, address.state];
    cell.zipcodeLabel.text = address.address_zipcode;
    
    if([[BRNLoginInfo shared].userInfo.customers_default_address_id isEqualToString:address.address_id]) {
        
        [cell setSelected:YES];
    }
    
    return cell;
}
@end

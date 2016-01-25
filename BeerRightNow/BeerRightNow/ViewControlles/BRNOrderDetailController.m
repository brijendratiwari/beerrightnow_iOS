//
//  BRNOrderDetailController.m
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNOrderDetailController.h"
#import "BRNOrderItem.h"
#import "BRNOrderProduct.h"
#import "BRNOrderDetailCell.h"

@interface BRNOrderDetailController () {
    
    NSArray * _orderProductArr;
}

@property (weak, nonatomic) IBOutlet UILabel *deliveryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *billingCountryLabel;
@end

@implementation BRNOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self detailTask];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
    self.tableView.tableHeaderView.hidden = YES;
    self.tableView.tableFooterView.hidden = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _totalLabel.text = _orderItem.order_total;
}

-(void)detailTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    [dic setObject:_orderItem.orders_id forKey:ORDER_ID];
    
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(ORDER_DETAILS) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                              
                                                   self.tableView.tableHeaderView.hidden = NO;
                                                   self.tableView.tableFooterView.hidden = NO;
                                                   
                                                   NSDictionary * jsonDelivery = json[DATA][@"delivery"];
                                                   _deliveryNameLabel.text = jsonDelivery[@"name"];
                                                   _deliveryStreetLabel.text = jsonDelivery[@"street_address"];
                                                   _deliveryCityLabel.text = [NSString stringWithFormat:@"%@ , %@", jsonDelivery[@"city"], jsonDelivery[@"state"]];
                                                   _deliveryCountryLabel.text = jsonDelivery[@"country"];
                                                   
                                                   NSDictionary * jsonBilling = json[DATA][@"billing"];
                                                   _billingNameLabel.text = jsonBilling[@"name"];
                                                   _billingStreetLabel.text = jsonBilling[@"street_address"];
                                                   _billingCityLabel.text = [NSString stringWithFormat:@"%@ , %@", jsonBilling[@"city"], jsonBilling[@"state"]];
                                                   _billingCountryLabel.text = jsonBilling[@"country"];
                                                   
                                                   _orderProductArr = [BRNOrderProduct arrayOfModelsFromDictionaries:json[DATA][@"products"]];
                                                   
                                                   [self.tableView reloadData];
                                               }
                                           }
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    @try {
        
        return _orderProductArr.count;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BRNOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailResuableCellIdentifer];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNOrderDetailCell" bundle:nil] forCellReuseIdentifier:kOrderDetailResuableCellIdentifer];
        cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailResuableCellIdentifer];
    }
    
    BRNOrderProduct * product = _orderProductArr[indexPath.row];
    cell.nameLabel.text = product.name;
    cell.quantityLabel.text = product.qty;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[product.final_price floatValue] decimalCount:2]];
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

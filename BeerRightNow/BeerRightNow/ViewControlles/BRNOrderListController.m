//
//  BRNOrderListController.m
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNOrderListController.h"
#import "BRNOrderItem.h"
#import "BRNOrderHistoryCell.h"
#import "BRNOrderProduct.h"

#import "BRNOrderDetailController.h"

@interface BRNOrderListController () {
    
    NSArray * _orderArrs;
}

@end

@implementation BRNOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self orderHistoryTask];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
}

-(void)addCartClicked:(id)sender
{
    
    if([sender isKindOfClass:[UIButton class]]) {
        
        UIButton * button = sender;
        BRNOrderItem * item = _orderArrs[button.tag];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
        [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
        [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
        [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
        [dic setObject:item.orders_id forKey:ORDER_ID];
        
        
        [HUD showUIBlockingIndicator];
        
        [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(ORDER_DETAILS) params:dic
                                       completion:^(NSDictionary * json, JSONModelError * err) {
                                           
                                           @try {
                                               
                                               if(err != nil) {
                                                   
                                                   [self.view makeToast:[err localizedDescription]];
                                               } else {
                                                   
                                                   if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                       
                                                       NSArray * orderedProducts = [BRNOrderProduct arrayOfModelsFromDictionaries:json[DATA][@"products"]];
                                                       
                                                       for(BRNOrderProduct * product in orderedProducts) {
                                                           
                                                           [[BRNCartInfo shared] addProductToCart:product.id productCount:product.qty];
                                                       }
                                                       
                                                       [self backClicked];
                                                   }
                                               }
                                           }@catch ( NSException  * exception) {
                                               
                                               NSLog(@"%@", exception.reason);
                                           }
                                           
                                           [HUD hideUIBlockingIndicator];
                                       }];
    }
}

-(void)orderHistoryTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(ORDER_LIST) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   _orderArrs = [BRNOrderItem arrayOfModelsFromDictionaries:json[DATA]];
                                                   
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
        
        return _orderArrs.count;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BRNOrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderHistoryReusableCellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNOrderHistoryCell" bundle:nil] forCellReuseIdentifier:kOrderHistoryReusableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kOrderHistoryReusableCellIdentifier];
    }
    
    BRNOrderItem * item = (BRNOrderItem*)_orderArrs[indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.addCartBtn.tag = indexPath.row;
    [cell.addCartBtn addTarget:self action:@selector(addCartClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderIdLabel.text = item.orders_id;
    cell.billNameLabel.text = item.billing_name;
    cell.billDateLabel.text = item.date_purchased;
    cell.priceLabel.text = item.order_total;
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BRNOrderItem * orderItem = _orderArrs[indexPath.row];
    [self performSegueWithIdentifier:kOrderDetailsControllerIdentifier sender:orderItem];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:kOrderDetailsControllerIdentifier]) {
        
        BRNOrderDetailController * orderDetailController = (BRNOrderDetailController*) segue.destinationViewController;
        orderDetailController.orderItem = (BRNOrderItem*)sender;
    }
}

@end

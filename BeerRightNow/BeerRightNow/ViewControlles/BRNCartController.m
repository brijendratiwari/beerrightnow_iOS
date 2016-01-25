//
//  BRNCartController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/22/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNCartController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BRNCartCell.h"
#import "BRNCartHeaderCell.h"
#import "BRNCartResponse.h"
#import "BRNCartProduct.h"
#import "BRNSummary.h"
#import "BRNLiquor.h"
#import "BRNBeer.h"
#import "BRNOtherCharge.h"
#import "BRNShippingAddressController.h"

typedef NS_ENUM(NSInteger, BRNHoldButton){
    
    kTipPlusBtn,
    kTipMinusBtn,
    kQuantityPlusBtn,
    kQuantityMinusBtn
};

@interface BRNCartController () {
 
    BRNCartResponse * _cartResponse;
    UIButton * _holdBtn;
    NSTimer * _holdTimer;
    NSArray *notificationArr;
//    float depositAmount;
    float couponAmount;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *keyAvoidingTableView;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *_couponField;
@property (weak, nonatomic) IBOutlet UILabel *beerLabel;
@property (weak, nonatomic) IBOutlet UILabel *liquorLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *other1Label;
@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *pickupLabel;
@property (weak, nonatomic) IBOutlet UILabel *convenienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *other1View;
@property (weak, nonatomic) IBOutlet UIButton *tipMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *tipPlusBtn;
@property (weak, nonatomic) IBOutlet UIView *beerView;
@property (weak, nonatomic) IBOutlet UIView *liquorView;
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UIView *pickupView;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountTitle;
@end

@implementation BRNCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    couponAmount = 0.0f;
    
    [self initializeLeftButtonItem];
    
    _keyAvoidingTableView.dataSource = self;
    _keyAvoidingTableView.delegate = self;
    
    _keyAvoidingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _keyAvoidingTableView.allowsSelection = NO;
    
    _keyAvoidingTableView.tableFooterView.hidden = YES;
    [_discountView hideByHeight:YES];
    
    _tipMinusBtn.tag = kTipMinusBtn;
    [_tipMinusBtn addTarget:self action:@selector(tipButtonDown:) forControlEvents:UIControlEventTouchDown];
    [_tipMinusBtn addTarget:self action:@selector(tipButtonUp:) forControlEvents:UIControlEventTouchUpInside];
    [_tipMinusBtn addTarget:self action:@selector(tipButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    _tipPlusBtn.tag = kTipPlusBtn;
    [_tipPlusBtn addTarget:self action:@selector(tipButtonDown:) forControlEvents:UIControlEventTouchDown];
    [_tipPlusBtn addTarget:self action:@selector(tipButtonUp:) forControlEvents:UIControlEventTouchUpInside];
    [_tipPlusBtn addTarget:self action:@selector(tipButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self cartTask];
}

-(void)tipButtonDown:(id)sender
{
    if(![sender isKindOfClass:[UIButton class]])
        return;
    
    _holdBtn = sender;
    
    [self triggerHold];
    _holdTimer =[NSTimer scheduledTimerWithTimeInterval:REPEAT_CLICK_TIME target:self selector:@selector(triggerHold) userInfo:nil repeats:YES];
}

-(void)tipButtonUp:(id)sender
{
    if(_holdTimer) {
        [_holdTimer invalidate];
        _holdTimer = nil;
        _holdBtn = nil;
    }
}

-(void)closeBtnClicked:(id)sender
{
    if([sender isKindOfClass:[BRNCartHoldBtn class]]) {
        
        BRNCartHoldBtn * closeBtn = sender;
        if(closeBtn.cartProduct != nil) {
            
            [self removeCartProduct:closeBtn.cartProduct];
        }
    }
}


-(void)removeCartProduct:(BRNCartProduct*)cartProduct
{
    [[BRNCartInfo shared] removeProductFromCart:cartProduct.products_id];
    [self cartTask];
}


-(void)quantityBtnClicked:(BRNCartHoldBtn*)btn
{
    if(btn == nil || btn.cartProduct == nil) {
        return;
    }
    
    NSInteger quantityCount =  [btn.cartProduct.product_count integerValue];
    switch (btn.tag) {
        case kQuantityPlusBtn: {
            
            quantityCount ++;
            NSString * quantityStr = [NSString stringWithFormat:@"%ld", (long)quantityCount];
            [[BRNCartInfo shared] addProductToCart:btn.cartProduct.products_id productCount:quantityStr];
            [self cartTask];
        }
        break;
        case kQuantityMinusBtn:
            if(quantityCount > 1) {
                
                quantityCount --;
                NSString * quantityStr = [NSString stringWithFormat:@"%ld", (long)quantityCount];
                [[BRNCartInfo shared] addProductToCart:btn.cartProduct.products_id productCount:quantityStr];
                [self cartTask];
            }
        break;
        default:
        break;
    }
}

-(void) triggerHold
{
    
    if(_holdBtn == nil) {
        
        return;
    }
    
    NSInteger tipNum = [_tipLabel.text integerValue];
    
    switch (_holdBtn.tag) {
        case kTipPlusBtn:
            _tipLabel.text = [NSString stringWithFormat:@"%ld", (long)++tipNum];
            [BRNCartInfo shared].serviceTip = tipNum;
            _totalLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[self totalWithTips] decimalCount:2]];
            _priceLabel.text = _totalLabel.text;
        break;
        case kTipMinusBtn:
            if(tipNum > 0) {
                _tipLabel.text = [NSString stringWithFormat:@"%ld", (long)--tipNum];
                [BRNCartInfo shared].serviceTip = tipNum;
                _totalLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[self totalWithTips] decimalCount:2]];
                _priceLabel.text = _totalLabel.text;
            }
        break;
        default:
        break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyClicked:(id)sender {
    
    if(__couponField.text.length == 0) {
        
//        [self.view makeToast:@"Please fill coupon code."];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill coupon code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        
        [self couponTask];
    }
}

- (IBAction)shippingInfoClicked:(id)sender {
    if (notificationArr.count > 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:[notificationArr objectAtIndex:0] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }
    else {
        [BRNCartInfo shared].totalPay= [self totalWithTips];
        
        [self performSegueWithIdentifier:kShippingAddressControllerIdentifier sender:nil];
    }
}

-(void)reloadData
{
//    depositAmount = 0.0f;
    
    @try {
        
        _storeNumLabel.text = [NSString stringWithFormat:@"from %ld Stores", (long)_cartResponse.storeCount];
        _productNumLabel.text = [NSString stringWithFormat:@"%ld Products",(long)_cartResponse.productCount];
        _priceLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse total] decimalCount:2]];
        [_keyAvoidingTableView reloadData];
        
    } @catch (NSException * exception ) {
        
    }
    _keyAvoidingTableView.tableFooterView.hidden = NO;
    
    if(_cartResponse.beer.products.count == 0) {
        
        [_beerView hideByHeight:YES];
    } else {
     
        _beerLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse beersPrice] decimalCount:2]];
//        for(BRNCartProduct * cartProduct in _cartResponse.beer.products) {
//            
//            if(cartProduct.other_charges.count != 0) {
//                
//                BRNOtherCharge * otherCharge = cartProduct.other_charges[0];
//                depositAmount += otherCharge.options_values_price;
//            }
//        }
    }
    
    if(_cartResponse.liquor.products.count == 0) {
        
        [_liquorView hideByHeight:YES];
    } else {
        
        _liquorLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse liquorsPrice] decimalCount:2]];
//        for(BRNCartProduct * cartProduct in _cartResponse.liquor.products) {
//            
//            if(cartProduct.other_charges.count != 0) {
//                
//                BRNOtherCharge * otherCharge = cartProduct.other_charges[0];
//                depositAmount += otherCharge.options_values_price;
//            }
//        }
    }
    
    float taxes = [_cartResponse beersTax] + [_cartResponse liquorsTax];
    _taxLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:taxes decimalCount:2]];
    float tipDefault =[_cartResponse productsTotal] * 0.1f;
    [BRNCartInfo shared].serviceTip = tipDefault;
    _tipLabel.text = [NSString stringWithFormat:@"%d", (int)tipDefault];
    
    _convenienceLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse convenience_fee] decimalCount:2]];
    
    [_other1View hideByHeight:YES];
    if(!_cartResponse.beer.has_kegs) {
        
        [_pickupView hideByHeight:YES];
    } else {
        
//        _other1Label.text = @"Refundable Deposit";
//        _value1Label.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:depositAmount decimalCount:2]];
        _pickupLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse pickupFee] decimalCount:2]];
    }
    
    _totalLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[self totalWithTips] decimalCount:2]];
    _priceLabel.text = _totalLabel.text;
    
    [_keyAvoidingTableView.tableFooterView layoutIfNeeded];
    
    CGRect rect = _keyAvoidingTableView.tableFooterView.frame;
    [_keyAvoidingTableView.tableFooterView sizeToSubviews];
    rect.size.height = _keyAvoidingTableView.tableFooterView.frame.size.height;
    _keyAvoidingTableView.tableFooterView.frame = rect;
    
}

-(float)totalWithTips
{
    @try {
        
        float total = [_cartResponse total];
        total += [_tipLabel.text floatValue];
//        total += depositAmount;
        total += couponAmount;
        return total;
    } @catch (NSException* exception) {
        
        return 0;
    }
}

-(void)couponTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:__couponField.text forKey:@"coupon_code"];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(CHECK_COUPON_CODE) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       NSLog(@"%@ ",json);
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:err.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                               [alertView show];
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   NSString * couponCode = json[DATA][@"coupon_code"];
                                                   couponAmount = [json[DATA][@"coupon_amount"] floatValue];
                                                   NSString * couponType = json[DATA][@"coupon_type"];
                                                   if([couponType isEqualToString:@"S"]) {
                                                       
                                                       couponAmount = _cartResponse.convenience_fee;
                                                   }
                                                   
                                                   [_discountView hideByHeight:NO];
                                                   _discountTitle.text  = [NSString stringWithFormat:@"%@ (%@)", @"Discount", couponCode];
                                                   _discountLabel.text = [NSString stringWithFormat:@"-$%@",[[BRNUtils shared] convertToDecimalPointString:couponAmount decimalCount:2]];
                                                   couponAmount *= -1;
                                                   _totalLabel.text = [NSString stringWithFormat:@"$%@", [[BRNUtils shared] convertToDecimalPointString:[self totalWithTips] decimalCount:2]];
                                                   _priceLabel.text = _totalLabel.text;
                                                   
                                               } else {
                                                   
                                                   UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid coupon code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                   [alertView show];
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

-(void)cartTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:[[BRNCartInfo shared] cartData] forKey:DATA];
    
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_CART) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       notificationArr = [json valueForKey:@"notifications"];
                                       
                                       NSLog(@"Json Response ===>%@",json);
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               [self.view makeToast:err.localizedDescription];
                                               
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   _cartResponse = [[BRNCartResponse alloc] initWithDictionary:json[DATA] error:nil];
                                                   if(_cartResponse == nil) {
                                                       
                                                       UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No Products in Cart..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                                       [alertView show];
                                                       [self backClicked];
                                                   } else {
                                                       
                                                       [self reloadData];
                                                   }

                                               } else {
                                                   
                                                   UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No Products in Cart..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                                   [alertView show];
                                                   [self backClicked];
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
    if([segue.identifier isEqualToString:kShippingAddressControllerIdentifier]) {
        
        BRNShippingAddressController * shippingAddressController = (BRNShippingAddressController*)segue.destinationViewController;
        shippingAddressController.cartResponse = _cartResponse;
        shippingAddressController.fromLeftMenu = NO;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
    }@catch (NSException * exception) {
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    BRNCartHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCartReusableHeaderIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNCartHeaderCell" bundle:nil] forCellReuseIdentifier:kCartReusableHeaderIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kCartReusableHeaderIdentifier];
    }
    
    NSInteger sectionCount = [_cartResponse storeCount];
    if(sectionCount == 2) {
        
        switch (section) {
            case 0: {
                
                cell.name.text = @"Beer Products";
                cell.storeName.text = _cartResponse.beer.store;
                cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse beersPrice] decimalCount:2]];
                }
                break;
            case 1: {
                
                cell.name.text = @"Liquor Products";
                cell.storeName.text = _cartResponse.liquor.store;
                cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse liquorsPrice] decimalCount:2]];
                }
                break;
        }
    } else if(sectionCount == 1){
        
        BOOL isLiquor = _cartResponse.liquor.products.count != 0 ? YES : NO;
        if(isLiquor) {
            
            cell.name.text = @"Liquor Products";
            cell.storeName.text = _cartResponse.liquor.store;
            cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse liquorsPrice] decimalCount:2]];
        } else {
            
            cell.name.text = @"Beer Products";
            cell.storeName.text = _cartResponse.beer.store;
            cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [[BRNUtils shared] convertToDecimalPointString:[_cartResponse beersPrice] decimalCount:2]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    @try {
        
        return  [_cartResponse storeCount];
        
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSInteger rowsInSection = 0;
    
    @try {
        
        NSInteger sectionCount = [_cartResponse storeCount];
        if(sectionCount == 2) {
            
            switch (section) {
                case 0:
                    rowsInSection = _cartResponse.beer.products.count;
                    break;
                case 1:
                    rowsInSection = _cartResponse.liquor.products.count;
                    break;
            }
        } else if (sectionCount == 1) {
            
            rowsInSection = _cartResponse.beer.products.count + _cartResponse.liquor.products.count;
        }
        
    } @catch (NSException * exception) {
        
    }
    
    return rowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRNCartCell *cell = [tableView dequeueReusableCellWithIdentifier:kCartReusableCellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNCartCell" bundle:nil] forCellReuseIdentifier:kCartReusableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kCartReusableCellIdentifier];
    }
    
    BRNCartProduct * cartProduct = nil;
    NSInteger sectionCount = [_cartResponse storeCount];
    if(sectionCount == 2) {
        
        switch (indexPath.section) {
            case 0: {
                
                cartProduct = _cartResponse.beer.products[indexPath.row];
                
            }
            break;
            case 1: {
                
                cartProduct = _cartResponse.liquor.products[indexPath.row];
            }
            break;
        }
    } else if(sectionCount == 1){
        
        BOOL isLiquor = _cartResponse.liquor.products.count != 0 ? YES : NO;
        if(isLiquor) {
            
            cartProduct = _cartResponse.liquor.products[indexPath.row];
        } else {
            
            cartProduct = _cartResponse.beer.products[indexPath.row];
        }
    }
    
    cell.minusBtn.cartProduct = cartProduct;
    cell.minusBtn.tag = kQuantityMinusBtn;
    [cell.minusBtn addTarget:self action:@selector(quantityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.plusBtn.cartProduct = cartProduct;
    cell.plusBtn.tag = kQuantityPlusBtn;
    [cell.plusBtn addTarget:self action:@selector(quantityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.closeBtn.cartProduct = cartProduct;
    [cell.closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if(cartProduct) {
        
        NSString * wholeName = cartProduct.products_name;
        NSArray * names;
        if([wholeName rangeOfString:@","].length != 0) {
            
            names = [wholeName componentsSeparatedByString:@","];
        } else {
            
            names = @[wholeName, @""];
        }
        
        NSString * urlString = [cartProduct.products_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ImageCacheManager setImageView:cell.imgView withUrlString:urlString];
        cell.name.text = names[0];
        cell.model.text = names[1];
        
        if(cartProduct.other_charges.count == 0) {
            
            [cell.otherView hideByHeight:YES];
        }else {
            
            BRNOtherCharge * deposite = (BRNOtherCharge*)cartProduct.other_charges[0];
            cell.other1Label.text = deposite.products_options_name;
            [cell.other1Label setAdjustsFontSizeToFitWidth:YES];
            cell.value1Label.text = [NSString stringWithFormat:@"%@$%@", deposite.price_prefix, [[BRNUtils shared] convertToDecimalPointString:deposite.options_values_price decimalCount:2]];
            [cell.value1Label setAdjustsFontSizeToFitWidth:YES];
            
            if (cartProduct.other_charges.count > 1)
            {
                BRNOtherCharge * other = (BRNOtherCharge*)cartProduct.other_charges[1];
                cell.other2Label.text = other.products_options_name;
                [cell.other2Label setAdjustsFontSizeToFitWidth:YES];
                cell.value2Label.text = [NSString stringWithFormat:@"%@$%@", other.price_prefix, [[BRNUtils shared] convertToDecimalPointString:other.options_values_price decimalCount:2]];
                [cell.value2Label setAdjustsFontSizeToFitWidth:YES];
            }
            else
            {
                [cell.other2Label setText:@""];
                [cell.value2Label setText:@""];
            }
        }
        
        cell.quantityLabel.text = cartProduct.product_count;
        cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", @"$", cartProduct.products_price];
    }
    
    return cell;
}


@end

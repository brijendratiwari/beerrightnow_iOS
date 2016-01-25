//
//  BRNProductController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/13/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNProductController.h"
#import "BRNProduct.h"
#import "BRNProductExtra.h"
#import "BRNOtherCharge.h"

@interface BRNProductController () {
    
    BRNProductExtra * productExtra;
    BOOL _isHoldPlusBtn;

    NSTimer * _holdTimer;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *centLabel;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UILabel *other1Label;
@property (weak, nonatomic) IBOutlet UILabel *other1ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *other2Label;
@property (weak, nonatomic) IBOutlet UILabel *other2ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *alcholView;
@property (weak, nonatomic) IBOutlet UIView *originView;
@property (weak, nonatomic) IBOutlet UILabel *alcholLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@end

@implementation BRNProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateCartBadge];
}

-(void)initUI
{
    _holdTimer = nil;
    
    [self initializeLeftButtonItem];
    [self initializeRightNaviationItems:YES];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
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
        
    NSString * urlString = [_product.products_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ImageCacheManager setImageView:_productImgView withUrlString:urlString];
    
    NSString * wholeName = _product.products_name;
    NSArray * names;
    if([wholeName rangeOfString:@","].length != 0) {
        
        names = [wholeName componentsSeparatedByString:@","];
    } else {
        
        names = @[wholeName, @""];
    }
    
    _nameLabel.text = names[0];
    [_nameLabel setAdjustsFontSizeToFitWidth:YES];
    
    _contentLabel.text = names[1];
    _styleLabel.text = _product.style_name;
    [_styleLabel setAdjustsFontSizeToFitWidth:YES];
    
    _originLabel.text = _product.origin_name;
    
    NSString * wholePrice = [NSString stringWithFormat:@"%@",_product.products_price];
    NSArray * prices;
//    if([wholeName rangeOfString:@"."].length != 0) {
//        
//        //prices = [[wholePrice stringByReplacingOccurrencesOfString:@"." withString:@"," ] componentsSeparatedByString:@","];
//        prices = [wholePrice componentsSeparatedByString:@"."];
//    } else {
//        
//        prices = @[wholePrice, @"00"];
//    }
    
    if([wholePrice rangeOfString:@"."].location != NSNotFound) {
        
        //prices = [[wholePrice stringByReplacingOccurrencesOfString:@"." withString:@"," ] componentsSeparatedByString:@","];
        prices = [wholePrice componentsSeparatedByString:@"."];
    } else {
        
        prices = @[wholePrice, @"00"];
    }
    
    _dollarLabel.text = [NSString stringWithFormat:@"%@%@",@"$", prices[0]];
    _centLabel.text = prices[1];
    [_contentLabel setAdjustsFontSizeToFitWidth:YES];
    [_dollarLabel setAdjustsFontSizeToFitWidth:YES];
    
   // _descriptionLabel.text = _product.products_description;
    [_descriptionLabel setText:[self removeUnicodeFromString:_product.products_description]];
    
    if(_product.other_charges == nil || _product.other_charges.count == 0) {
        
        [_otherView hideByHeight:YES];
    } else {
        
        @try {
            
            
            BRNOtherCharge * deposite = (BRNOtherCharge*)_product.other_charges[0];
            _other1Label.text = deposite.products_options_name;
            _other1ValueLabel.text = [NSString stringWithFormat:@"%@$%@", deposite.price_prefix, [[BRNUtils shared] convertToDecimalPointString:deposite.options_values_price decimalCount:2]];
            
            BRNOtherCharge * other = (BRNOtherCharge*)_product.other_charges[1];
            _other2Label.text = other.products_options_name;
            _other2ValueLabel.text = [NSString stringWithFormat:@"%@$%@", other.price_prefix, [[BRNUtils shared] convertToDecimalPointString:other.options_values_price decimalCount:2]];
            
        }@catch (NSException * exception) {
            
        }
    }
    
    [_footerView layoutIfNeeded];
    [_contentView layoutIfNeeded];
    
    CGRect contentRect = _contentView.frame;
    contentRect.size.height = _footerView.frame.origin.y + _footerView.frame.size.height + 15;
    _contentView.frame = contentRect;
   
    [_keyAvoidingScrollView setShowsHorizontalScrollIndicator:NO];
    [_keyAvoidingScrollView contentSizeToFit];
    
    [_minusBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [_minusBtn addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [_minusBtn addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [_plusBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [_plusBtn addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [_plusBtn addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self productDescTask];
}

-(NSString *)removeUnicodeFromString:(NSString *)string
{
    NSString *test = string;
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (NSInteger i = 32; i < 127; i++)  {
        [asciiCharacters appendFormat:@"%c", (char)i];
    }
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    test = [[test componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];
    return test;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonDown:(id)sender
{
    if(sender == _plusBtn) {
        
        _isHoldPlusBtn = YES;
    } else {
        
        _isHoldPlusBtn = NO;
    }
    
    [self triggerHold];
    _holdTimer =[NSTimer scheduledTimerWithTimeInterval:REPEAT_CLICK_TIME target:self selector:@selector(triggerHold) userInfo:nil repeats:YES];
}

-(void)buttonUp:(id)sender
{
    if(_holdTimer) {
        [_holdTimer invalidate];
        _holdTimer = nil;
    }
}

-(void) triggerHold
{
    NSInteger quantityNum = [_quantityLabel.text integerValue];
    
    if(_isHoldPlusBtn) {
        
        _quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)++quantityNum];
    }else if (quantityNum > 1){
        
        _quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)--quantityNum];
    }
}


- (IBAction)addCartClicked:(id)sender {
    
    NSString * result = [[BRNCartInfo shared] addProductToCart:_product.products_id productCount:_quantityLabel.text];
    if(result == nil || result.length == 0) {
        
        return;
    }
    
    [self updateCartBadge];
    [self.view makeToast:result];
}

-(void)productDescTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:_product.products_id forKey:PRODUCT_ID];
    
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(PRODUCT_DETAILS) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               
                                               productExtra = [[BRNProductExtra alloc] initWithDictionary:json[DATA] error:NULL];
                                               if([productExtra.origin_name isEqualToString:@"-NA-"] || productExtra.origin_name.length == 0) {
                                                   
                                                   [_originView hideByWidth:YES];
                                               } else {
                                                   
                                                   _originLabel.text = productExtra.origin_name;
                                               }
                                               
                                               _alcholLabel.text = [NSString stringWithFormat:@"%@%@",productExtra.alcholol_percentage, @"%"];
                                               if([_alcholLabel.text isEqualToString:@"0%"]) {
                                                   
                                                   [_alcholView hideByWidth:YES];
                                               }
                                               
                                               
                                           } else {
                                               
                                               [self.view makeToast:@"No Product Description found..."];
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil)
                                               [self.view makeToast:[err localizedDescription]];
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
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

//
//  BRNCreditCardController.m
//  BeerRightNow
//
//  Created by Dragon on 4/28/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNCreditCardController.h"
#import "CreditCard.h"
#import "BRNExpireDateAlert.h"

@interface BRNCreditCardController ()  <UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource, ExpireDateDelegate>{
    
    NSDate * _date;
    NSDateFormatter * _dateFormatter;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyAvoidingScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *cardNumField;
@property (weak, nonatomic) IBOutlet UITextField *billingNameField;
@property (weak, nonatomic) IBOutlet UITextField *billingAddressField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *billingZipField;
@property (weak, nonatomic) IBOutlet UIButton *expiryDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UITextField *suiteField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@end

@implementation BRNCreditCardController

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
    
    [[BRNUtils shared] setBorder:_expiryDateBtn color:[UIColor whiteColor] cornerRadius:7 borderWidth:1.0f];
    [[BRNUtils shared] setBorder:_cardTypeBtn color:[UIColor whiteColor] cornerRadius:7 borderWidth:1.0f];
    
    _cardNumField.text = [[BRNCartInfo shared] cardNumber];
    _cityField.text = [[BRNCartInfo shared] billingCity];
    _suiteField.text = [[BRNCartInfo shared] billingSuite];
    _cvvField.text = [[BRNCartInfo shared] cardCVV];
    _billingNameField.text = [[BRNCartInfo shared] billingName];
    _billingAddressField.text = [[BRNCartInfo shared] billingAddres];
    _stateField.text = [[BRNCartInfo shared] billingState];
    if([[BRNCartInfo shared] billingPostCode].length == 0) {
        
        _billingZipField.text = [[BRNLoginInfo shared] zipcode];
    } else {
        
        _billingZipField.text = [[BRNCartInfo shared] billingPostCode];
    }
    _billingNameField.text = [[BRNCartInfo shared] billingName];
    _countryField.text = [[BRNCartInfo shared] billingCountry];
    
    CreditCard *card = [BRNCreditCardController cardArray][[[BRNCartInfo shared] cardType]];
    
    [_cardTypeBtn setTitle:card.cardName forState:UIControlStateNormal];
    
    _dateFormatter  = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:MONTH_YEAR_FORMATE];
    _date = [_dateFormatter dateFromString:[[BRNCartInfo shared] cardExpires]];
    [_expiryDateBtn setTitle:[[BRNCartInfo shared] cardExpires]  forState:UIControlStateNormal];
    
    
    _cardNumField.delegate = self;
    _cvvField.delegate = self;
    
    if(_fromLeftMenu) {
        
        [_reviewBtn setBackgroundColor:[UIColor redColor]];
        [_reviewBtn setImage:nil forState:UIControlStateNormal];
        [_reviewBtn setContentEdgeInsets:UIEdgeInsetsZero];
        [_reviewBtn setImageEdgeInsets:UIEdgeInsetsZero];
        [_reviewBtn setTitle:@"Save" forState:UIControlStateNormal];
        [_reviewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reviewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _reviewBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
}

+(NSArray*)cardArray
{
    static NSArray *s_cardArr = nil;
    
    @synchronized (s_cardArr) {
        
        if(s_cardArr == nil) {
            
            CreditCard * masterCard = [[CreditCard alloc] init];
            masterCard.cardName = @"Master Card";
            masterCard.cardNumLength = 16;
            masterCard.cardCVVLength = 3;
            
            CreditCard * visaCard = [[CreditCard alloc] init];
            visaCard.cardName = @"Visa";
            visaCard.cardNumLength = 16;
            visaCard.cardCVVLength = 3;
            
            CreditCard * axCard = [[CreditCard alloc] init];
            axCard.cardName = @"American Express";
            axCard.cardNumLength = 15;
            axCard.cardCVVLength = 4;
            
            CreditCard * discoverCard = [[CreditCard alloc] init];
            discoverCard.cardName = @"Discover";
            discoverCard.cardNumLength = 16;
            discoverCard.cardCVVLength = 3;
            
            s_cardArr = @[masterCard, visaCard, axCard, discoverCard];
            
        }
        return s_cardArr;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cardTypeClicked:(id)sender {
    
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.picker.delegate = self;
    pickerVC.picker.dataSource = self;
    
    //Set a title for the picker
    pickerVC.titleLabel.text = nil;
    
    //Set select and (optional) cancel blocks
    [pickerVC setSelectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
        
        NSInteger  rowIndex = [rows[0] integerValue];
        [[BRNCartInfo shared] setCardType:rowIndex];
        CreditCard * card = [BRNCreditCardController cardArray][[[BRNCartInfo shared] cardType]];
        
        [_cardTypeBtn setTitle:card.cardName forState:UIControlStateNormal];
    }];
    
    //You can enable or disable bouncing and motion effects
    pickerVC.disableBouncingWhenShowing = NO;
    pickerVC.disableMotionEffects = NO;
    pickerVC.disableBlurEffects = NO;
    
    //You can also adjust colors (enabling the following line will result in a black version of RMPickerViewController)
    pickerVC.blurEffectStyle = UIBlurEffectStyleDark;
    
    //Enable the following lines if you want a black version of RMPickerViewController but also disabled blur effects (or run on iOS 7)
    //pickerVC.tintColor = [UIColor whiteColor];
    //pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    //pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    
    //On the iPad we want to show the picker view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if([pickerVC respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        pickerVC.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
//        pickerVC.popoverPresentationController.sourceView = self.keyAvoidingScrollView;
//        pickerVC.popoverPresentationController.sourceRect = [self.keyAvoidingScrollView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerVC animated:YES completion:nil];
}

-(void)backClicked
{
    
    [self saveInfo];
    [super backClicked];
}

-(void)saveInfo
{
    [[BRNCartInfo shared]  setCardNumber:_cardNumField.text];
    [[BRNCartInfo shared]  setCardCVV:_cvvField.text];
    [[BRNCartInfo shared]  setBillingName:_billingNameField.text];
    [[BRNCartInfo shared]  setBillingAddres:_billingAddressField.text];
    [[BRNCartInfo shared]  setBillingCity:_cityField.text];
    [[BRNCartInfo shared]  setBillingState:_stateField.text];
    [[BRNCartInfo shared]  setBillingPostCode:_billingZipField.text];
    [[BRNCartInfo shared]  setBillingSuite:_suiteField.text];
    [[BRNCartInfo shared]  setBillingCountry:_countryField.text];
}

- (IBAction)expiryDateClicked:(id)sender {
    
    
    BRNExpireDateAlert * datePickerAlert = [[BRNExpireDateAlert alloc] init];
    if(_date) {
        [datePickerAlert setDate:_date];
    }
    datePickerAlert.delegate = self;
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        
        self.providesPresentationContextTransitionStyle  = YES;
        self.definesPresentationContext = YES;
        datePickerAlert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    } else {
        
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
    }
    
    [self presentViewController:datePickerAlert animated:YES completion:nil];
}

- (IBAction)reviewClicked:(id)sender {
    
    
    CreditCard * card = [BRNCreditCardController cardArray][[[BRNCartInfo shared] cardType]];
    if(card.cardNumLength != _cardNumField.text.length) {
    
        [self.view makeToast:[NSString stringWithFormat:@"Card Number should be %ld digits", (long)card.cardNumLength]];
        return;
    }
    
    if(card.cardCVVLength != _cvvField.text.length) {
        
        [self.view makeToast:[NSString stringWithFormat:@"CVV Number should be %ld digits", (long)card.cardCVVLength]];
        return;
    }
    
    if(_billingNameField.text.length == 0 || _billingAddressField.text.length == 0 || _cityField.text.length == 0 || _stateField.text.length == 0 || _countryField.text.length == 0) {
        
        [self.view makeToast:ALL_FIELDS_FILL];
        return;
    }
    
    if(_billingZipField.text.length > 7) {
        
        [self.view makeToast:VALID_ZIPCODE];
        return;
    }
    
    [self saveInfo];
    
    if(!_fromLeftMenu) {
        
        [self performSegueWithIdentifier:kConfirmOrderControllerIdentifier sender:nil];
    } else {
        
        [self backClicked];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Date Picker Delegate

-(void)onDatePicker:(NSDate *)date
{
    _date = date;
    [[BRNCartInfo shared] setCardExpires:[_dateFormatter stringFromDate:_date]];
    [_expiryDateBtn setTitle:[[BRNCartInfo shared] cardExpires] forState:UIControlStateNormal];
}

#pragma mark TextField Delegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    CreditCard *card = [BRNCreditCardController cardArray][[[BRNCartInfo shared] cardType]];
    
    if(textField == _cardNumField) {
        
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= card.cardNumLength || returnKey;
    } else if(textField == _cvvField){
        
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= card.cardCVVLength || returnKey;
    } else {
        
        return YES;
    }
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    NSLog(@"Successfully selected rows: %@", selectedRows);
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [BRNCreditCardController cardArray].count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    CreditCard * card = [BRNCreditCardController cardArray][row];
//    return card.cardName;
//}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CreditCard * card = [BRNCreditCardController cardArray][row];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        
        NSAttributedString *cardName = [[NSAttributedString alloc] initWithString:card.cardName attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return cardName;
    } else {
        
        NSAttributedString *cardName = [[NSAttributedString alloc] initWithString:card.cardName attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        return cardName;
    }
}
@end

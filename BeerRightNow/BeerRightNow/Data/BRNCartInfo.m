//
//  BRNCartInfo.m
//  BeerRightNow
//
//  Created by Dragon on 4/2/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNCartInfo.h"
#import "Server.h"
#import "Constants.h"

#define CC_CARD_TYPE @"ci_card_type"
#define CC_CARD_NUMBER @"ci_card_number"
#define CC_CVV @"ci_cvv"
//#define CC_EXPIRES_YEAR @"cc_expires_year"
//#define CC_EXPIRES_MONTH @"cc_expires_month"
#define CC_EXPIRES @"cc_expires"

#define SERVICE_TIP @"service_tip"
#define TOTAL_PAYABLE @"total_payable"

#define DELIVERY_EXPECTED @"delivery_expected"
#define DELIVERY_COMMENT @"deliver_comment"

#define BILLING_ADDRESS @"billing_address"
#define BILLING_NAME @"billing_name"
#define BILLING_CITY @"billing_city"
#define BILLING_POSTCODE @"billing_postcode"
#define BILLING_STATE @"billing_state"
#define BILLING_SUITE @"billing_suite"
#define BILLING_COUNTRY @"billing_country"

// optional
#define OPT_IS_EXECUTIVE @"opt_is_executive"
#define OPT_IS_GIFT @"opt_is_gift"
#define OPT_CUSTOMER_NUMBER @"opt_customer_number"
#define OPT_GIFT_FOR_NUMBER @"opt_gift_for_number"
#define OPT_IS_CORPORATE_ORDER @"opt_is_corporate_order"
#define OPT_OFFICE_EXTENSION @"opt_office_extension"
#define OPT_CONTACT_CELL @"opt_contact_cell"
#define OPT_SERVICE_ENTERENCE_ADDRESS @"opt_service_enterence_address"

static BRNCartInfo * g_sharedCartInfo = nil;

@implementation BRNCartInfo


+(instancetype) shared
{
    if(g_sharedCartInfo == nil)
        g_sharedCartInfo = [[BRNCartInfo alloc] init];
    
    return g_sharedCartInfo;
}

-(id)init
{
    self = [super init];
    if(self) {
        
        [self initialize];
    }
 
    return self;
}

-(void)initialize
{
    NSUserDefaults * sharedPref = [NSUserDefaults standardUserDefaults];
    
    _cardType  = [sharedPref integerForKey:CC_CARD_TYPE];
    _cardNumber = [sharedPref stringForKey:CC_CARD_NUMBER];
    _cardCVV = [sharedPref stringForKey:CC_CVV];
    
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
//    _cardExpiresYear = [sharedPref integerForKey:CC_EXPIRES_YEAR];
//    if(_cardExpiresYear == 0)
//        _cardExpiresYear = [components year];
//    
//    _cardExpiresMonth = [sharedPref integerForKey:CC_EXPIRES_MONTH];
//    if(_cardExpiresMonth)
//        _cardExpiresMonth = [components month];
    
    _cardExpires = [sharedPref stringForKey:CC_EXPIRES];
    if(_cardExpires == nil || _cardExpires.length == 0) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:MONTH_YEAR_FORMATE];
        _cardExpires = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    
    _serviceTip = [sharedPref  floatForKey:SERVICE_TIP];
    _totalPay = [sharedPref floatForKey:TOTAL_PAYABLE];
    
    _deliveryExpected = [sharedPref stringForKey:DELIVERY_EXPECTED];
    if(_deliveryExpected == nil)
        _deliveryExpected = ASAP;
    _deliveryComment = [sharedPref stringForKey:DELIVERY_COMMENT];
    
    _executive = [sharedPref  boolForKey:OPT_IS_EXECUTIVE];
    _gift = [sharedPref boolForKey:OPT_IS_GIFT];
    _customerNumber = [sharedPref stringForKey:OPT_CUSTOMER_NUMBER];
    _giftForNumber = [sharedPref stringForKey:OPT_GIFT_FOR_NUMBER];
    _corporateOrder = [sharedPref boolForKey:OPT_IS_CORPORATE_ORDER];
    _officeExtension = [sharedPref stringForKey:OPT_OFFICE_EXTENSION];
    _contactCell = [sharedPref stringForKey:OPT_CONTACT_CELL];
    _serviceEnterenceAddress = [sharedPref stringForKey:OPT_SERVICE_ENTERENCE_ADDRESS];
    
    _billingAddres = [sharedPref stringForKey:BILLING_ADDRESS];
    _billingCity = [sharedPref stringForKey:BILLING_CITY];
    if(!_billingCity) {
        
        _billingCity = [self cities][0];
    }
    _billingName = [sharedPref stringForKey:BILLING_NAME];
    _billingPostCode = [sharedPref stringForKey:BILLING_POSTCODE];
    _billingState = [sharedPref stringForKey:BILLING_STATE];
    if(!_billingState) {
        
        _billingState = DEFAULT_STATE;
    }
    _billingSuite = [sharedPref stringForKey:BILLING_SUITE];
    
    _billingCountry = [sharedPref stringForKey:BILLING_COUNTRY];
    if(!_billingCountry) {
        
        _billingCountry = DEFAULT_STATE;
    }
    
    @try {
        
        NSString * jsonCart = [sharedPref stringForKey:CART];
        if(jsonCart == nil)
            jsonCart = @"[]";
        
        cart = [[NSMutableArray alloc] init];
        NSArray * cartArr = [NSJSONSerialization JSONObjectWithData:[jsonCart dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [cart addObjectsFromArray:cartArr];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }

}

-(void)setCardType:(NSInteger)cardType
{
    _cardType = cardType;
    [[NSUserDefaults standardUserDefaults] setInteger:cardType forKey:CC_CARD_TYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCardCVV:(NSString *)cardCVV
{
    _cardCVV = cardCVV;
    [[NSUserDefaults standardUserDefaults] setObject:cardCVV forKey:CC_CVV];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCardNumber:(NSString *)cardNumber
{
    _cardNumber = cardNumber;
    [[NSUserDefaults standardUserDefaults] setObject:cardNumber forKey:CC_CARD_NUMBER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setCardExpires:(NSString *)cardExpires
{
    _cardExpires = cardExpires;
    [[NSUserDefaults standardUserDefaults] setObject:cardExpires forKey:CC_EXPIRES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//-(void)setCardExpiresYear:(NSInteger)cardExpiresYear
//{
//    _cardExpiresYear = cardExpiresYear;
//    [[NSUserDefaults standardUserDefaults] setInteger:cardExpiresYear forKey:CC_EXPIRES_YEAR];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//-(void)setCardExpiresMonth:(NSInteger)cardExpiresMonth
//{
//    _cardExpiresMonth = cardExpiresMonth;
//    [[NSUserDefaults standardUserDefaults] setInteger:cardExpiresMonth forKey:CC_EXPIRES_MONTH];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

-(void)setServiceTip:(float)serviceTip
{
    _serviceTip = serviceTip;
    [[NSUserDefaults standardUserDefaults] setFloat:serviceTip forKey:SERVICE_TIP];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setDeliveryExpected:(NSString *)deliveryExpected
{
    _deliveryExpected = deliveryExpected;
    [[NSUserDefaults standardUserDefaults] setObject:deliveryExpected forKey:DELIVERY_EXPECTED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setDeliveryComment:(NSString *)deliveryComment
{
    _deliveryComment = deliveryComment;
    [[NSUserDefaults standardUserDefaults] setObject:deliveryComment forKey:DELIVERY_COMMENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setExecutive:(BOOL)executive
{
    _executive = executive;
    [[NSUserDefaults standardUserDefaults] setBool:executive forKey:OPT_IS_EXECUTIVE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setGift:(BOOL)gift
{
    _gift = gift;
    [[NSUserDefaults standardUserDefaults] setBool:gift forKey:OPT_IS_GIFT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCustomerNumber:(NSString *)customerNumber
{
    _customerNumber = customerNumber;
    [[NSUserDefaults standardUserDefaults] setObject:customerNumber forKey:OPT_CUSTOMER_NUMBER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setGiftForNumber:(NSString *)giftForNumber
{
    _giftForNumber = giftForNumber;
    [[NSUserDefaults standardUserDefaults] setObject:giftForNumber forKey:OPT_GIFT_FOR_NUMBER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCorporateOrder:(BOOL)corporateOrder
{
    _corporateOrder = corporateOrder;
    [[NSUserDefaults standardUserDefaults] setBool:corporateOrder forKey:OPT_IS_CORPORATE_ORDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setOfficeExtension:(NSString *)officeExtension
{
    _officeExtension = officeExtension;
    [[NSUserDefaults standardUserDefaults] setObject:officeExtension forKey:OPT_OFFICE_EXTENSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setContactCell:(NSString *)contactCell
{
    _contactCell = contactCell;
    [[NSUserDefaults standardUserDefaults] setObject:contactCell forKey:OPT_CONTACT_CELL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setServiceEnterenceAddress:(NSString *)serviceEnterenceAddress
{
    _serviceEnterenceAddress = serviceEnterenceAddress;
    [[NSUserDefaults standardUserDefaults] setObject:serviceEnterenceAddress forKey:OPT_SERVICE_ENTERENCE_ADDRESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingName:(NSString *)billingName
{
    _billingName = billingName;
    [[NSUserDefaults standardUserDefaults] setObject:billingName forKey:BILLING_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingAddres:(NSString *)billingAddres
{
    _billingAddres = billingAddres;
    [[NSUserDefaults standardUserDefaults] setObject:billingAddres forKey:BILLING_ADDRESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingCity:(NSString *)billingCity
{
    _billingCity = billingCity;
    [[NSUserDefaults standardUserDefaults] setObject:billingCity forKey:BILLING_CITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingSuite:(NSString *)billingSuite
{
    _billingSuite = billingSuite;
    [[NSUserDefaults standardUserDefaults] setObject:billingSuite forKey:BILLING_SUITE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingCountry:(NSString *)billingCountry {
    
    _billingCountry = billingCountry;
    [[NSUserDefaults standardUserDefaults] setObject:billingCountry forKey:BILLING_COUNTRY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingState:(NSString *)billingState
{
    _billingState = billingState;
    [[NSUserDefaults standardUserDefaults] setObject:billingState forKey:BILLING_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBillingPostCode:(NSString *)billingPostCode
{
    _billingPostCode = billingPostCode;
    [[NSUserDefaults standardUserDefaults] setObject:billingPostCode forKey:BILLING_POSTCODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setTotalPay:(float)totalPay
{
    _totalPay = totalPay;
    [[NSUserDefaults standardUserDefaults] setFloat:totalPay forKey:TOTAL_PAYABLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clear
{
    NSUserDefaults * sharedPref = [NSUserDefaults standardUserDefaults];
    
    [sharedPref removeObjectForKey:CC_CARD_TYPE];
    [sharedPref removeObjectForKey:CC_CARD_NUMBER];
    [sharedPref removeObjectForKey:CC_CVV];
//    [sharedPref removeObjectForKey:CC_EXPIRES_MONTH];
//    [sharedPref removeObjectForKey:CC_EXPIRES_YEAR];
    [sharedPref removeObjectForKey:CC_EXPIRES];
    
    [sharedPref removeObjectForKey:SERVICE_TIP];
    [sharedPref removeObjectForKey:TOTAL_PAYABLE];
    
    [sharedPref removeObjectForKey:DELIVERY_EXPECTED];
    [sharedPref removeObjectForKey:DELIVERY_COMMENT];
    
    [sharedPref removeObjectForKey:OPT_CONTACT_CELL];
    [sharedPref removeObjectForKey:OPT_CUSTOMER_NUMBER];
    [sharedPref removeObjectForKey:OPT_GIFT_FOR_NUMBER];
    [sharedPref removeObjectForKey:OPT_IS_CORPORATE_ORDER];
    [sharedPref removeObjectForKey:OPT_IS_EXECUTIVE];
    [sharedPref removeObjectForKey:OPT_IS_GIFT];
    [sharedPref removeObjectForKey:OPT_OFFICE_EXTENSION];
    [sharedPref removeObjectForKey:OPT_SERVICE_ENTERENCE_ADDRESS];
    
    [sharedPref removeObjectForKey:BILLING_ADDRESS];
    [sharedPref removeObjectForKey:BILLING_CITY];
    [sharedPref removeObjectForKey:BILLING_NAME];
    [sharedPref removeObjectForKey:BILLING_POSTCODE];
    [sharedPref removeObjectForKey:BILLING_STATE];
    [sharedPref removeObjectForKey:BILLING_SUITE];
    [sharedPref removeObjectForKey:BILLING_COUNTRY];
    
    [sharedPref synchronize];
    
    [self initialize];
}

-(void)orderProcessed
{
    NSUserDefaults * sharedPref = [NSUserDefaults standardUserDefaults];
    
    [sharedPref removeObjectForKey:SERVICE_TIP];
    [sharedPref removeObjectForKey:TOTAL_PAYABLE];
    
    [sharedPref removeObjectForKey:DELIVERY_EXPECTED];
    [sharedPref removeObjectForKey:DELIVERY_COMMENT];
    
    [sharedPref removeObjectForKey:OPT_CONTACT_CELL];
    [sharedPref removeObjectForKey:OPT_CUSTOMER_NUMBER];
    [sharedPref removeObjectForKey:OPT_GIFT_FOR_NUMBER];
    [sharedPref removeObjectForKey:OPT_IS_CORPORATE_ORDER];
    [sharedPref removeObjectForKey:OPT_IS_EXECUTIVE];
    [sharedPref removeObjectForKey:OPT_IS_GIFT];
    [sharedPref removeObjectForKey:OPT_OFFICE_EXTENSION];
    [sharedPref removeObjectForKey:OPT_SERVICE_ENTERENCE_ADDRESS];
    
    [sharedPref synchronize];
    
    [self removeCarts];
    [self initialize];
}

-(void)removeCarts
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CART];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self initialize];
}

-(NSString*)cartData
{
    @try {
        
        if ([BRNCartInfo shared].saveLiquoeInCart)
        {
            
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cart
                                                           options:0
                                                             error:nil];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
        return @"[]";
    }
}

-(NSInteger)productNumberInCart
{
    
    @try {
        
        return [cart count];
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
        return 0;
    }
}

-(void)removeProductFromCart:(NSString*)productId
{
    
    @try {
        
        for (id object in cart) {
            
            if([object isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary * cartDict = object;
                
                NSString * cartProudctId  = [cartDict objectForKey:PRODUCT_ID];
                if([cartProudctId isEqualToString:productId]) {
                    
                    [cart removeObject:object];
                    break;
                }
                
            }
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cart
                                                           options:0
                                                             error:nil];
        NSString* jsonCart = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[NSUserDefaults standardUserDefaults] setObject:jsonCart forKey:CART];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
}

-(NSString*)addProductToCart:(NSString*)productId productCount:(NSString*)productCount
{
    
    NSString * reason = nil;
    
    @try {
        
        NSMutableDictionary * productDict = nil;
        
        for(id object in cart) {
            
            if([object isKindOfClass:[NSMutableDictionary class]]) {
                
                NSMutableDictionary * objDict = object;
                NSString * cartProudctId = [object objectForKey:PRODUCT_ID];
                if([cartProudctId isEqualToString:productId]) {
                    
                    productDict = objDict;
                    break;
                }
                
            }
        }
        
        if(productDict == nil) {
            
            productDict = [[NSMutableDictionary alloc] init];
            [productDict setObject:productId forKey:PRODUCT_ID];
            [productDict setObject:productCount forKey:PRODUCT_COUNT];
            
            [cart addObject:productDict];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cart
                                                               options:0
                                                                 error:nil];
            NSString* jsonCart = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [[NSUserDefaults standardUserDefaults] setObject:jsonCart forKey:CART];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            reason = @"Product added to Cart...";
            
        } else {
            
            NSString * cartProductCount = [productDict objectForKey:PRODUCT_COUNT];
            
            if([cartProductCount isEqualToString:productCount]) {
                
                reason = @"Product already in Cart";
            } else {
                
                [productDict setObject:productCount forKey:PRODUCT_COUNT];
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cart
                                                                   options:0
                                                                     error:nil];
                NSString* jsonCart = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [[NSUserDefaults standardUserDefaults] setObject:jsonCart forKey:CART];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                reason = @"Product updated in Cart...";
            }
        }
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@", exception.reason);
    }
    
    return reason;
}

-(NSArray*)cities {
    
    static NSArray * cityArrr = nil;
    if(!cityArrr) {
        
        cityArrr = @[@"Alabama", @"Alaska", @"American Samoa", @"Arizona", @"Arkansas", @"Armed Forces Africa", @"Armed Forces Americas", @"Armed Forces Canada" ,@"Armed Forces Europe", @"Armed Forces Middle East",@"Armed Forces Pacific", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Federated States Of Micronesia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Marshall Islands", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Northen Mariana Islands", @"Ohio", @"Oklahoma", @"Oregon", @"Palau", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virgin Islands", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    }
    
    return cityArrr;
}

//-(NSArray*)states {
//    
//    static NSArray * stateArr = nil;
//    if(!stateArr) {
//        
//    }
//    
//    return stateArr;
//}

@end

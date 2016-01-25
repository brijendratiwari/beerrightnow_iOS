//
//  CreditCard.h
//  BeerRightNow
//
//  Created by Dragon on 4/28/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject

@property (nonatomic, strong) NSString *  cardName;
@property (nonatomic) NSInteger cardNumLength;
@property (nonatomic) NSInteger cardCVVLength;

@end

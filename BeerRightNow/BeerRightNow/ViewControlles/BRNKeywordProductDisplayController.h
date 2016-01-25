//
//  BRNProductDisplayController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRNRightFilterController.h"

@class BRNSection;
@class BRNType;

@interface BRNKeywordProductDisplayController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSString * keyword;

@end

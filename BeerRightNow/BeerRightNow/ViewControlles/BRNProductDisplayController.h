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

@interface BRNProductDisplayController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, RightFilterDelegate>

@property (nonatomic, weak) BRNSection * section;
@property (nonatomic, strong) BRNType * type;

@end

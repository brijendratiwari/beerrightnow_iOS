//
//  BRNRightFilterController.h
//  BeerRightNow
//
//  Created by dukce pak on 4/13/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BRNFilterMode){
    
    kFilterBrands,
    kFilterProducers,
    kFilterPrice,
    kFilterType
};

@class BRNSection;
@class BRNType;
@protocol RightFilterDelegate <NSObject>

-(void)onWillApply;
-(void)onFilter:(NSArray*) products pages:(NSInteger)pages isNew:(BOOL)isNew;
-(void)onError;
@end

@interface BRNRightFilterController : UIViewController <UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate >

@property (nonatomic, weak) id<RightFilterDelegate> delegate;

-(void)initWith:(BRNSection*) section type:(BRNType*)type delegate:(id)delegate;
-(void)openRightFilter:(BRNFilterMode) filterMode;
-(void)performTask:(NSInteger)pages;


@end

//
//  BRNProductCollectionCell.h
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNProductCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productSize;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@end

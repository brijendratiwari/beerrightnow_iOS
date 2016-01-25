//
//  BRNAlert.m
//  BeerRightNow
//
//  Created by dukce pak on 4/17/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNAlert.h"

@interface BRNAlert ()

@end

@implementation BRNAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showInView:(UIView*)targetView animated:(BOOL)animated
{
    _animated = animated;
    
    [targetView addSubview:self.view];
    
    self.view.frame = targetView.frame;
    
//    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.view
//                                                                      attribute:NSLayoutAttributeLeading
//                                                                      relatedBy:0
//                                                                         toItem:targetView
//                                                                      attribute:NSLayoutAttributeLeft
//                                                                     multiplier:1.0
//                                                                       constant:0];
//    [targetView addConstraint:leftConstraint];
//    
//    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.view
//                                                                       attribute:NSLayoutAttributeTrailing
//                                                                       relatedBy:0
//                                                                          toItem:targetView
//                                                                       attribute:NSLayoutAttributeRight
//                                                                      multiplier:1.0
//                                                                        constant:0];
//    [targetView addConstraint:rightConstraint];
//    
//    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.view
//                                                                     attribute:NSLayoutAttributeTop
//                                                                     relatedBy:0
//                                                                        toItem:targetView
//                                                                     attribute:NSLayoutAttributeTop
//                                                                    multiplier:1.0
//                                                                      constant:0];
//    [targetView addConstraint:topConstraint];
//    
//    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view
//                                                                        attribute:NSLayoutAttributeBottom
//                                                                        relatedBy:0
//                                                                           toItem:targetView
//                                                                        attribute:NSLayoutAttributeBottom
//                                                                       multiplier:1.0
//                                                                         constant:0];
//    [targetView addConstraint:bottomConstraint];

//    [targetView setNeedsUpdateConstraints];
//    [targetView.superview updateConstraints];
    
    if(_animated) {
        
        [self fadeIn];
    }

}

-(void)removeView
{
    if(_animated)
    [self fadeOut];
    else
    [self.view removeFromSuperview];
    
}

- (void)fadeIn {
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut {
    [UIView animateWithDuration:.35 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self.view removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

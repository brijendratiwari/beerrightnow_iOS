//
//  BRNSharePhotoController.m
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSharePhotoController.h"

@interface BRNSharePhotoController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@end

@implementation BRNSharePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    
    [self initializeLeftButtonItem];
    
    [_imgView setImage:_image];
    
    _clickBtn.layer.cornerRadius = _clickBtn.frame.size.width / 2.0f;
    _clickBtn.layer.masksToBounds = YES;

}
- (IBAction)clicked:(id)sender {
    
    [self shareWith:_image];
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

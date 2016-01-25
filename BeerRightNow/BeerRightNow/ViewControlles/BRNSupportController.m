//
//  BRNSupportController.m
//  BeerRightNow
//
//  Created by Dragon on 4/29/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSupportController.h"

@interface BRNSupportController ()

@end

@implementation BRNSupportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
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

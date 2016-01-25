//
//  BRNSignConfirmController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/16/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNSignConfirmController.h"
#import "BRNSignInfo.h"

@interface BRNSignConfirmController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation BRNSignConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
    [[BRNUtils shared] setBorder:_infoView color:[UIColor lightGrayColor] cornerRadius:7 borderWidth:0.5f];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _signInfo.firstName, _signInfo.lastName];
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@-%@",_signInfo.streetAddress, _signInfo.city, _signInfo.state, _signInfo.zipcode];
    
    _phoneLabel.text = _signInfo.phone;
    _emailLabel.text = _signInfo.email;
    
}
- (IBAction)doneClicked:(id)sender {
    
    [self performSegueWithIdentifier:kReturnedIdentifier sender:nil];
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

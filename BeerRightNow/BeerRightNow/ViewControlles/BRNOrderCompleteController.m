//
//  BRNOrderCompleteController.m
//  BeerRightNow
//
//  Created by Dragon on 4/29/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNOrderCompleteController.h"
#import "BRNCameraAlert.h"

#import "BRNSharePhotoController.h"
#import "BRNInvitePartyController.h"

@interface BRNOrderCompleteController () <CameraAlertDelegate> {
    
    BOOL _isInvite;
}

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@end

@implementation BRNOrderCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
    _orderIdLabel.text = [NSString stringWithFormat:@"Number is %@", _orderId];
}

-(void)backClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cameraClicked:(id)sender {
    
    BRNCameraAlert * cameraAlert = [[BRNCameraAlert alloc] init];
    cameraAlert.delegate = self;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        
        self.providesPresentationContextTransitionStyle  = YES;
        self.definesPresentationContext = YES;
        cameraAlert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    } else {
        
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:cameraAlert animated:YES completion:nil];
}
- (IBAction)giveClicked:(id)sender {
    
    _isInvite = YES;
    [self performSegueWithIdentifier:kInvitePartyControllerIdentifier sender:nil];
}
- (IBAction)partyClicked:(id)sender {
    
    _isInvite = NO;
    [self performSegueWithIdentifier:kInvitePartyControllerIdentifier sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:kSharePhotoControllerIdentifier]) {
        
        BRNSharePhotoController * shareController = (BRNSharePhotoController*)segue.destinationViewController;
        shareController.image = (UIImage*)sender;
    } else if ([segue.identifier isEqualToString:kInvitePartyControllerIdentifier]) {
        
        BRNInvitePartyController * partyController = (BRNInvitePartyController*)segue.destinationViewController;
        partyController.isInvite = _isInvite;
    }
}

#pragma mark Camera Alert Delegate

-(void)onShare:(UIImage *)image
{
    [self performSegueWithIdentifier:kSharePhotoControllerIdentifier sender:image];
}

@end

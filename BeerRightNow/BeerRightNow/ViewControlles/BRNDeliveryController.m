//
//  BRNDeliveryController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNDeliveryController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BRNDeliveryGiftCell.h"
#import "BRNDeliveryOrderCell.h"
#import "BRNCreditCardController.h"
#import "BRNCartResponse.h"

@interface BRNDeliveryController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    BRNDeliveryOrderCell * orderCell;
    BRNDeliveryGiftCell *giftCell;
    
    NSString * _yourRole;
}

@property (weak, nonatomic) IBOutlet UITextView *specialText;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *keyAvoidingTableView;

@end

@implementation BRNDeliveryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}


-(void)initUI
{
    [self initializeLeftButtonItem];
    
    _keyAvoidingTableView.dataSource = self;
    _keyAvoidingTableView.delegate = self;
    
    [[BRNUtils shared] setBorder:_specialText color:[UIColor blackColor] cornerRadius:5 borderWidth:0.5f];
    
    _yourRole = ORDERING_SELF;
}

-(void)reload
{
    [self saveInfo];
    
    [self.keyAvoidingTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)paymentClicked:(id)sender {
    
    [self saveInfo];
    [self performSegueWithIdentifier:kAddCreditControllerIdentifier sender:nil];
}

-(void)saveInfo
{
    [BRNCartInfo shared].customerNumber = giftCell.phoneField.text;
    [BRNCartInfo shared].giftForNumber = giftCell.receipentField.text;
    [BRNCartInfo shared].officeExtension = orderCell.officeField.text;
    [BRNCartInfo shared].contactCell = orderCell.contactField.text;
    [BRNCartInfo shared].serviceEnterenceAddress = orderCell.serviceEntranceField.text;
    [BRNCartInfo shared].deliveryComment = _specialText.text;
}

-(void)backClicked
{
    
    [self saveInfo];
    [super backClicked];
}


-(void)switchValueChanged:(id)sender
{
    @try {
        
        if([sender isKindOfClass:[UISwitch class]]) {
            
            UISwitch * senderSwitch = sender;
            if(senderSwitch.tag == 1) {
                
                [BRNCartInfo shared].gift = ![BRNCartInfo shared].gift;
                [self reload];
            } else if (senderSwitch.tag == 2) {
                
                [BRNCartInfo shared].corporateOrder = ![BRNCartInfo shared].corporateOrder;
                [self reload];
            }
            
        }
    } @catch (NSException * exception) {
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:kAddCreditControllerIdentifier]) {
        
        BRNCreditCardController * creditController = (BRNCreditCardController*)segue.destinationViewController;
        creditController.fromLeftMenu = NO;
    }
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    NSLog(@"Successfully selected rows: %@", selectedRows);
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString * item;
    
    switch (row) {
        case 0:
            item = ORDERING_SELF;
            break;
            
        case 1:
            item = EXECUTIVE_ASSISTANT;
            break;
        case 2:
            item = COORDINATOR;
            break;
        case 3:
            item = EVENT_PLANNER;
            break;
    }
    
    NSAttributedString *atrributedItem = [[NSAttributedString alloc] initWithString:item attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return atrributedItem;
    
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    NSString * item;
//    
//    switch (row) {
//        case 0:
//            item = ORDERING_SELF;
//            break;
//            
//        case 1:
//            item = EXECUTIVE_ASSISTANT;
//            break;
//        case 2:
//            item = COORDINATOR;
//            break;
//        case 3:
//            item = EVENT_PLANNER;
//            break;
//    }
//    
//    return item;
//}

#pragma mark Delivery Time Alert

-(void)onDeliveryTime:(NSString *)expectedTime
{
    [BRNCartInfo shared].deliveryExpected = expectedTime;

    [self reload];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0: {
            BRNDeliveryTimeAlert * deliveryTimeAlert = [[BRNDeliveryTimeAlert alloc] init];
            deliveryTimeAlert.cartResponse = self.cartResponse;
            deliveryTimeAlert.delegate = self;
            if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
                
                self.providesPresentationContextTransitionStyle  = YES;
                self.definesPresentationContext = YES;
                deliveryTimeAlert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                
            } else {
                
                self.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [self presentViewController:deliveryTimeAlert animated:YES completion:nil];
        }
            break;
        case 3: {
            RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
            pickerVC.picker.delegate = self;
            pickerVC.picker.dataSource = self;
            
            //Set a title for the picker
            pickerVC.titleLabel.text = nil;
            
            //Set select and (optional) cancel blocks
            [pickerVC setSelectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {

                NSInteger rowIndex = [rows[0] integerValue];
                switch ((long)rowIndex) {
                    case 0:
                        _yourRole = ORDERING_SELF;
                        break;
                        
                    case 1:
                        _yourRole = EXECUTIVE_ASSISTANT;
                        break;
                    case 2:
                        _yourRole = COORDINATOR;
                        break;
                    case 3:
                        _yourRole = EVENT_PLANNER;
                        break;
                }
                [self reload];
            }];
            
            //You can enable or disable bouncing and motion effects
            pickerVC.disableBouncingWhenShowing = NO;
            pickerVC.disableMotionEffects = NO;
            pickerVC.disableBlurEffects = NO;
            
            //You can also adjust colors (enabling the following line will result in a black version of RMPickerViewController)
            pickerVC.blurEffectStyle = UIBlurEffectStyleDark;
            
            //Enable the following lines if you want a black version of RMPickerViewController but also disabled blur effects (or run on iOS 7)
            //pickerVC.tintColor = [UIColor whiteColor];
            //pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
            //pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
            
            //On the iPad we want to show the picker view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
            //(Of course only if we are running on iOS 8 or later)
            if([pickerVC respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                //First we set the modal presentation style to the popover style
                pickerVC.modalPresentationStyle = UIModalPresentationPopover;
                
                //Then we tell the popover presentation controller, where the popover should appear
                pickerVC.popoverPresentationController.sourceView = self.keyAvoidingTableView;
                pickerVC.popoverPresentationController.sourceRect = [self.keyAvoidingTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
            
            //Now just present the picker view controller using the standard iOS presentation method
            [self presentViewController:pickerVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat rowHeight = 0.0f;
    switch (indexPath.row) {
        case 1:
            if([BRNCartInfo shared].gift)
                rowHeight = 122.0f;
            else
                rowHeight = 44.0f;
            break;
        case 2:
            if([BRNCartInfo shared].corporateOrder)
                rowHeight = 160.0f;
            else
                rowHeight = 44.0f;
            break;
        default:
            rowHeight = 44.0f;
            break;
    }
    
    return rowHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * baseCell;
    
    switch (indexPath.row) {
        case 1: {
            
            giftCell = [tableView dequeueReusableCellWithIdentifier:kDeliveryGiftReusableCellIdentifier];
            if(giftCell == nil) {
                
                [tableView registerNib:[UINib nibWithNibName:@"BRNDeliveryGiftCell" bundle:nil] forCellReuseIdentifier:kDeliveryGiftReusableCellIdentifier];
                giftCell = [tableView dequeueReusableCellWithIdentifier:kDeliveryGiftReusableCellIdentifier];
            }
            [giftCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            giftCell.giftSwitch.tag = 1;
            [giftCell setGift:[BRNCartInfo shared].gift];
            [giftCell.giftSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            giftCell.phoneField.text = [BRNCartInfo shared].customerNumber;
            giftCell.receipentField.text = [BRNCartInfo shared].giftForNumber;
            baseCell = giftCell;
        }
            break;
        case 2: {
            
            orderCell = [tableView dequeueReusableCellWithIdentifier:kDeliveryOrderReusableCellIdentifier];
            if(orderCell == nil) {
                
                [tableView registerNib:[UINib nibWithNibName:@"BRNDeliveryOrderCell" bundle:nil] forCellReuseIdentifier:kDeliveryOrderReusableCellIdentifier];
                orderCell = [tableView dequeueReusableCellWithIdentifier:kDeliveryOrderReusableCellIdentifier];
            }
            
            [orderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            orderCell.deliverySwitch.tag = 2;
            [orderCell setOrder:[BRNCartInfo shared].corporateOrder];
            [orderCell.deliverySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            orderCell.officeField.text = [BRNCartInfo shared].officeExtension;
            orderCell.contactField.text = [BRNCartInfo shared].contactCell;
            orderCell.serviceEntranceField.text = [BRNCartInfo shared].serviceEnterenceAddress;
            baseCell = orderCell;
        }
            break;
            
        default: {
            
            static NSString *cellIdentifier = @"DeliveryCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 0) {
                
                cell.textLabel.text = @"Delivery Time";
                cell.detailTextLabel .text = [BRNCartInfo shared].deliveryExpected;
                [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
            } else {
                
                cell.textLabel.text = @"Your Role";
                cell.detailTextLabel.text = _yourRole;
            }
            
            baseCell = cell;
        }
            break;
    }
    return baseCell;
}

@end

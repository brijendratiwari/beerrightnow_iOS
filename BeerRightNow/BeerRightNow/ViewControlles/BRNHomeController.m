//
//  BRNHomeController.m
//  BeerRightNow
//
//  Created by Dragon on 4/3/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNHomeController.h"
#import "BRNTypeController.h"
#import "BRNProductDisplayController.h"

#import "BRNSection.h"
#import "BRNType.h"

@interface BRNHomeController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *browsingAt;
@property (strong, nonatomic) NSArray * sectionArr;

@end

@implementation BRNHomeController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self productSectionTask];
}

-(void)initUI
{
    [self initializeRightNaviationItems:YES];
    
    _browsingAt.text = [NSString stringWithFormat:@"%@%@", @"You are browsing: ", [BRNLoginInfo shared].zipcode];
    
    CGRect headerRect = self.headerView.frame;
    headerRect.size.height = self.view.frame.size.height * 0.42;
    self.headerView.frame = headerRect;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCartBadge];
    [[BRNFlowManager shared] setLeftMenuController:YES];
    [[BRNFlowManager shared] setPanMode:MFSideMenuPanModeDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BRNFlowManager shared] setLeftMenuController:NO];
}

- (IBAction)productSectionTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    
    if(self.refreshControl != nil) {
    
        [self.refreshControl beginRefreshing];
    } else {
        
        [HUD showUIBlockingIndicator];
    }
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_PRODUCT_SECTIONS) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil) {
                                               
                                               UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[err localizedDescription] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                               [alert show];
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   NSLog(@"json data===>%@",json[DATA]);
                                                   _sectionArr = [BRNSection arrayOfModelsFromDictionaries:json[DATA]];
                                                   [self.tableView reloadData];
                                               } else {
                                                   
                                                   UIAlertView* alert = [[UIAlertView alloc] initWithTitle:json[DATA][MESSAGE] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                                   [alert show];
                                               }
                                               
                                           }
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                       }
                                       
                                       if(self.refreshControl != nil) {
                                        
                                           [self.refreshControl endRefreshing];
                                       }
                                       else {
                                           
                                           [HUD hideUIBlockingIndicator];
                                       }
                                   }];
}

-(void) productTypeOnSectionTask :(BRNSection*) section
{
    
    if(section == nil)
        return;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:section.sectionid forKey:SECTION_ID];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_PRODUCT_TYPE_ON_SECTION) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               
                                               NSArray * typeArr = [BRNType arrayOfModelsFromDictionaries:json[DATA]];
                                               
                                               if(typeArr.count > 1) {
                                                   
                                                   NSDictionary * params = [[NSDictionary alloc] initWithObjects:@[section, typeArr] forKeys:@[SECTION_ID, TYPE_ID]];
                                                   [self performSegueWithIdentifier:kTypeControllerIdentifier sender:params];

                                               } else {
                                                   NSDictionary * params = [[NSDictionary alloc] initWithObjects:@[section, typeArr.firstObject] forKeys:@[SECTION_ID, TYPE_ID]];
                                                   [self performSegueWithIdentifier:kProductDisplayControllerIdentifier1 sender:params];
                                               }
                                               
                                           } else {
                                               
                                               [self.view makeToast:json[DATA][MESSAGE]];
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil)
                                               [self.view makeToast:[err localizedDescription]];
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
}

- (IBAction)homeClicked:(id)sender
{
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)zipcodeClicked:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Changing zipcode will clear out your cart!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

-(IBAction)returnedHome:(UIStoryboardSegue*)seque
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [[BRNLoginInfo shared] setZipcode:nil];
        [[BRNFlowManager shared] willShowHome];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kTypeControllerIdentifier]) {
        
        if([sender isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * params = (NSDictionary*)sender;
            
            BRNTypeController * typeController = (BRNTypeController*)segue.destinationViewController;
            typeController.section = (BRNSection*) [params objectForKey:SECTION_ID];
            typeController.typeArr = (NSArray*)[params objectForKey:TYPE_ID];
        }
    } else if ([segue.identifier isEqualToString:kProductDisplayControllerIdentifier1]) {
        
        if([sender isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * params = (NSDictionary*)sender;
            
            BRNProductDisplayController * productDisplayController = (BRNProductDisplayController*)segue.destinationViewController;
            productDisplayController.section = (BRNSection*) [params objectForKey:SECTION_ID];
            productDisplayController.type = (BRNType*)[params objectForKey:TYPE_ID];
            NSLog(@"sdgfdsgdfghdg");
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        BRNSection * section = (BRNSection*)_sectionArr[indexPath.row];
        [self productTypeOnSectionTask:section];
    }
    @catch (NSException *exception) {
    }
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
    @try {
        
        return _sectionArr.count;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SectionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    BRNSection * section = _sectionArr[indexPath.row];
    cell.textLabel.text = section.name;
    
    return cell;
}

@end

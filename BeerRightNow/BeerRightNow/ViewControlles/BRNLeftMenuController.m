//
//  BRNLeftMenuController.m
//  BeerRightNow
//
//  Created by Dragon on 4/3/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNLeftMenuController.h"
#import "BRNLoginInfo.h"
#import "BRNFlowManager.h"
#import "BRNUserInfo.h"
#import "Server.h"
#import "Constants.h"

#import "BRNKeywordProductDisplayController.h"
#import "BRNShippingAddressController.h"
#import "BRNCreditCardController.h"
#import "BRNSupportController.h"
#import "BRNOrderListController.h"
#import "BRNTakeBreakController.h"

@interface BRNLeftMenuController () {
    
    BOOL _keyboardShown;
}

@property (weak, nonatomic) IBOutlet UILabel *usrName;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation BRNLeftMenuController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI
{
    _searchBar.delegate = self;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    tapGesture.delegate = self;
    
    [self.view addGestureRecognizer:tapGesture];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _keyboardShown = NO;
    
    _usrName.text = [NSString stringWithFormat:@"%@ %@", [BRNLoginInfo shared].userInfo.customers_firstname, [BRNLoginInfo shared].userInfo.customers_lastname];
}

- (void)keyboardWill:(NSNotification *)notification {
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        _keyboardShown = YES;
    } else {
        
        _keyboardShown = NO;
    }
}

-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}

- (IBAction)logoutClicked:(id)sender {
    
    [self hideKeyBoard];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Are you sure want to logout?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [[BRNLoginInfo shared] setLogined:NO];
        [[BRNFlowManager shared] willShowHome];
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView] && !_keyboardShown) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 1: {
            BRNShippingAddressController * shippingController = (BRNShippingAddressController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kShippingAddressControllerID];
            shippingController.fromLeftMenu = YES;
            [self.menuContainerViewController.centerViewController pushViewController:shippingController animated:YES];
        }
        break;
        case 2: {
            
            BRNOrderListController * orderController  = (BRNOrderListController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kOrderHistoryControllerID];
            [self.menuContainerViewController.centerViewController pushViewController:orderController animated:YES];
        }
        break;
        case 3: {
            BRNCreditCardController * cardController  = (BRNCreditCardController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kCreditCardControllerID];
            cardController.fromLeftMenu = YES;
            [self.menuContainerViewController.centerViewController pushViewController:cardController animated:YES];
        }
        break;
        case 4: {
            
            BRNSupportController * supportController = (BRNSupportController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kSupportControllerIdentifier];
            [self.menuContainerViewController.centerViewController pushViewController:supportController animated:YES];
        }
        break;
        case 5: {
            
            BRNTakeBreakController * takeController = (BRNTakeBreakController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kTakeBreakControllerIdentifier];
            [self.menuContainerViewController.centerViewController pushViewController:takeController animated:YES];
        }
        break;
        default:
        break;
    }
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

#pragma mark - UISearchBarDelegate

//- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
//    
//    [aSearchBar resignFirstResponder];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    
    // When the search button is tapped, add the search term to recents and conduct the search.
    [self hideKeyBoard];
    
    NSString *searchString = [self.searchBar text];
    
    BRNKeywordProductDisplayController * keywordController = (BRNKeywordProductDisplayController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kKeywordProductDisplayControllerIdentifier];
    
    keywordController.keyword = searchString;
    
    [self.menuContainerViewController.centerViewController pushViewController:keywordController animated:YES];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

@end

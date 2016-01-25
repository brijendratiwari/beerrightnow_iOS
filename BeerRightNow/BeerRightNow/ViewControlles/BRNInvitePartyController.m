//
//  BRNInvitePartyController.m
//  BeerRightNow
//
//  Created by Dragon on 4/30/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNInvitePartyController.h"
#import "BRNContactCell.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BRNContactInfo.h"

@interface BRNInvitePartyController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate , UISearchBarDelegate> {
    
    BOOL _keyboardShown;
    NSMutableArray * _contactArr;
    NSArray * _searchArr;
}

@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchField;
@end

@implementation BRNInvitePartyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self getAddressBook];
//    [self getContactList];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    
    [[BRNUtils shared] setBorder:_msgView color:[UIColor lightGrayColor] cornerRadius:7.0f borderWidth:0.5f];
    
    if(_isInvite) {
        
        self.navigationItem.title = @"Invite Friends";
    } else {
        
        self.navigationItem.title = @"Having Party";
    }
    
    _searchField.delegate = self;

    _tableView.allowsMultipleSelection = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _keyboardShown = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    tapGesture.delegate = self;
    
    [self.view addGestureRecognizer:tapGesture];
    
}
- (IBAction)sendClicked:(id)sender {
    
    NSArray * indexPathArr = [_tableView indexPathsForSelectedRows];
    
    if(indexPathArr == nil || indexPathArr.count == 0) {
        
//        [self.view makeToast:@"Please Select"];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please Select" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [paramDic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [paramDic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [paramDic setObject:[BRNLoginInfo shared].userInfo.customers_id forKey:CUSTOMER_ID];
    [paramDic setObject:_msgTextView.text forKey:@"message"];
    
    NSMutableArray * jsonArr = [[NSMutableArray alloc] init];
    
    for (NSIndexPath * indexPath in indexPathArr) {
        
        BRNContactInfo * contactInfo;
        if(_searchField.text.length != 0) {
            
            contactInfo = _searchArr[indexPath.row];
        } else {
            
            contactInfo = _contactArr[indexPath.row];
        }
        
        NSString * fullName = [NSString stringWithFormat:@"%@_%@", contactInfo.personFirstName, contactInfo.personLastName];
        NSString * number;
        if(contactInfo.iphoneNumber == nil || contactInfo.iphoneNumber.length == 0) {
            
            number = contactInfo.mobileNumber;
        } else {
            
            number = contactInfo.iphoneNumber;
        }
        
        NSDictionary * contactDic = [NSDictionary dictionaryWithObjectsAndKeys:fullName, @"name" , number, @"number", nil];
        [jsonArr addObject:contactDic];
    }
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:nil];
    [paramDic setObject:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] forKey:DATA];
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(_isInvite ? INVITE : INVITE_TO_PARTY) params:paramDic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if(err != nil && json == nil) {
                                               
//                                               [self.view makeToast:[err localizedDescription]];
                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:[err localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                               [alertView show];
                                           } else {
                                               
                                               if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                                   
                                                   UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Sent SMS" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                   [alertView show];
                                               } else {
                                                   
                                                   UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Sending SMS is failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                   [alertView show];
                                               }
                                           }
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
}

- (NSMutableArray*)getContactList{
    NSMutableArray* aryContact = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //        dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        aryContact = [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        aryContact = [self getContactsWithAddressBook:addressBook];
    }
    return aryContact;
}

#define key_name @"key_name"
#define key_phone @"key_phone"
#define key_photo @"key_photo"

// Get the contacts.
- (NSMutableArray*)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    NSMutableArray* aryContact = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if(firstName == nil)
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:key_name];
        else if(lastName == nil)
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:key_name];
        else
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:key_name];
        
        NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(ref);
        if (imgData) {
            UIImage* img = [UIImage imageWithData:imgData];
            [dOfPerson setObject:img forKey:key_photo];
            
        }
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:key_phone];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:key_phone];
                break ;
            }
            
        }
        NSString* strPhone = [dOfPerson objectForKey:key_phone];
        if( strPhone == nil )
            continue;
        
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strPhone = [strPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        if (strPhone.length == 11 && [[strPhone substringToIndex:1] isEqualToString:@"1"] == YES) {
            strPhone = [strPhone substringFromIndex:1];
        }
        [dOfPerson setObject:strPhone forKey:key_phone];
        
        [dOfPerson setValue:@"0" forKey:@"Checked"];
        [aryContact addObject:dOfPerson];
        
    }
    
    [aryContact sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key_name ascending:YES]]];
    return aryContact;
}

-(void)getAddressBook
{
    _contactArr = [[NSMutableArray alloc] init];
    _searchArr = [[NSArray alloc] init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //        dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
    }
    
    if(!accessGranted) {
        
        return;
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    for ( int i = 0; i < nPeople; i++ )
    {
        BRNContactInfo * contactInfo = [[BRNContactInfo alloc] init];
        ABRecordRef personRef = CFArrayGetValueAtIndex( allPeople, i );
        contactInfo.personFirstName = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonFirstNameProperty));
        contactInfo.personLastName = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonLastNameProperty));
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(personRef, kABPersonPhoneProperty);
        
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            
            if ([(NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneNumbers, (long)i)) isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                NSString * number = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, (long)i));
                number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                contactInfo.mobileNumber = number;
            } else if ([(NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneNumbers, (long)i)) isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]) {
                NSString * number = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, (long)i));
                number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                contactInfo.iphoneNumber = number;
            }
            
        }
        
        [_contactArr addObject:contactInfo];
        CFRelease(phoneNumbers);
    }
    [self.tableView reloadData];
}

-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}

- (void)keyboardWill:(NSNotification *)notification {
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        _keyboardShown = YES;
    } else {
        
        _keyboardShown = NO;
    }
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    if(_searchField.text.length != 0) {
        
        return _searchArr.count;
    } else {
        
        return _contactArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRNContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactInfoResuableCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNContactCell" bundle:nil] forCellReuseIdentifier:kContactInfoResuableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kContactInfoResuableCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(_searchField.text.length != 0) {
        
        BRNContactInfo * contactInfo = _searchArr[indexPath.row];
        cell.contactLabel.text = [NSString stringWithFormat:@"%@_%@", contactInfo.personFirstName, contactInfo.personLastName];
        if(contactInfo.mobileNumber == nil || contactInfo.mobileNumber.length == 0) {
            
            cell.phoneLabel.text = contactInfo.iphoneNumber;
        } else {
            
            cell.phoneLabel.text = contactInfo.mobileNumber;
        }
    } else {
        
        BRNContactInfo * contactInfo = _contactArr[indexPath.row];
        cell.contactLabel.text = [NSString stringWithFormat:@"%@_%@", contactInfo.personFirstName, contactInfo.personLastName];
        if(contactInfo.mobileNumber == nil || contactInfo.mobileNumber.length == 0) {
            
            cell.phoneLabel.text = contactInfo.iphoneNumber;
        } else {
            
            cell.phoneLabel.text = contactInfo.mobileNumber;
        }
    }
    
    return cell;
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_tableView] && !_keyboardShown) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

#pragma mark Search Methods

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"personFirstName contains[c] %@ || personLastName contains[c] %@ || mobileNumber contains[c] %@ || iphoneNumber contains[c] %@", searchText, searchText, searchText, searchText];
    _searchArr = [_contactArr filteredArrayUsingPredicate:resultPredicate];
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                                         objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    return YES;
//}

#pragma mark - UISearchBarDelegate

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self filterContentForSearchText:searchText scope:[[self.searchField scopeButtonTitles] objectAtIndex:[self.searchField selectedScopeButtonIndex]]];
    
    [_tableView reloadData];
}

@end

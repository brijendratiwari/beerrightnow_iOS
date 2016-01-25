//
//  BRNRightFilterController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/13/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNRightFilterController.h"
#import "BRNFilterCell.h"

#import "BRNFilterItem.h"
#import "BRNSection.h"
#import "BRNType.h"
#import "BRNProduct.h"

#define SECTION_ID_2 @"2"
#define SECTION_ID_3 @"3"

@interface BRNRightFilterController () {
    
    BRNSection * _section;
    BRNType * _type;
    BRNFilterMode _filter;
    BOOL isNew;
    NSInteger _page;
    
    NSMutableArray * _tmpSelectedItems;
    BRNFilterMode _tmpFilter;
    BOOL _keyboardShown;
    CGPoint point;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchField;

@property (strong, nonatomic) NSArray * itemArr;
@property (strong, nonatomic) NSArray * searchItemArr;

@property (strong,nonatomic) NSArray* selectedItems;
@end

@implementation BRNRightFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterTask {
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    
    NSString *api;
    switch (_tmpFilter) {
        case kFilterBrands:
            [dic setObject:_type.type_id forKey:@"type_id"];
            api = GET_BRANDS;
            break;
            
        case kFilterPrice:
            api = GET_PRICE_RANGE;
            break;
            
        case kFilterType:
            [dic setObject:_section.sectionid forKey:@"section_id"];
            if([_section.sectionid isEqualToString:SECTION_ID_2] || [_section.sectionid isEqualToString:SECTION_ID_3]) {
                
                api = GET_STYLE_TYPE_NAME;
            } else {
                
                api = GET_TYPE;
            }
            break;
            
        case kFilterProducers:
            [dic setObject:_section.sectionid forKey:@"section_id"];
            api = GET_PRODUCERS;
            break;
    }
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(api) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               if(_tmpFilter == kFilterType && ([_section.sectionid isEqualToString:SECTION_ID_2] || [_section.sectionid isEqualToString:SECTION_ID_3])) {
                                                   
                                                   NSArray * array = json[DATA];
                                                   NSMutableArray* nameArrs = [[NSMutableArray alloc] init];
                                                   for (id item in array) {
                                                       
                                                       if([item isKindOfClass:[NSString class]]) {
                                                           
                                                           BRNNameFilterItem * nameItem = [[BRNNameFilterItem alloc] init];
                                                           nameItem.name = (NSString*)item;
                                                           [nameArrs addObject:nameItem];
                                                       }
                                                   }
                                                   
                                                   _itemArr = [nameArrs sortedArrayUsingSelector:@selector(compare:)];
                                                   [_tableView reloadData];
                                               } else {
                                                   
                                                   NSMutableArray * array = [[NSMutableArray alloc] init];
                                                   
                                                   NSDictionary * dic = json[DATA];
                                                   NSEnumerator *enumerator = [dic keyEnumerator];
                                                   id key;
                                                   while((key = [enumerator nextObject])) {
                                                       
                                                       BRNFilterItem * filterItem = [[BRNFilterItem alloc] init];
                                                       filterItem.name = (NSString*)[dic objectForKey:key];
                                                       filterItem.keyId = key;
                                                       [array addObject:filterItem];
                                                   }
                                                   
                                                   _itemArr = [array sortedArrayUsingSelector:@selector(compare:)];
                                                   [_tableView reloadData];
                                               }
                                               
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil)
                                               [self.view makeToast:[err localizedDescription]];
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                   }];
    
}

-(void)applyTask
{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:_type.type_id forKey:@"type_id"];
    [dic setObject:[NSNumber numberWithInteger:_page].stringValue forKey:PAGE];
    
    switch (_filter) {
        case kFilterBrands:
        for (id object in _selectedItems) {
            
            if ([object isKindOfClass:[BRNFilterItem class]]) {
                
                BRNFilterItem* filterItem = (BRNFilterItem*) object;
                [dic setObject:filterItem.keyId forKey:@"brand_id[]"];
                
            }
        }
        break;
        case kFilterPrice:
        for (id object in _selectedItems) {
            
            if ([object isKindOfClass:[BRNFilterItem class]]) {
                
                BRNFilterItem* filterItem = (BRNFilterItem*) object;
                [dic setObject:filterItem.keyId forKey:@"price_range_id"];
            }
        }
        break;
        case kFilterType:
        for (id object in _selectedItems) {
            
            BRNNameFilterItem * nameFilter = (BRNNameFilterItem*)object;
            
            if ([_section.sectionid isEqualToString:SECTION_ID_2]
                || [_section.sectionid isEqualToString:SECTION_ID_3]) {
                
                [dic setObject:nameFilter.name forKey:@"style_type_name"];
            }  else if ([object isKindOfClass:[BRNFilterItem class]]) {
                
                BRNFilterItem * filterItem = (BRNFilterItem*) object;
                [dic setObject:filterItem.keyId forKey:@"style_id[]"];
            }
        }
        break;
        case kFilterProducers:
        for (id object in _selectedItems) {
            
            if ([object isKindOfClass:[BRNFilterItem class]]) {
                
                BRNFilterItem *filterItem = (BRNFilterItem*) object;
                [dic setObject:filterItem.keyId forKey:@"producer_id[]"];
            }
        }
        break;
    }
    
    [HUD showUIBlockingIndicator];
    if(_delegate && [_delegate respondsToSelector:@selector(onWillApply)]) {
        
        [_delegate onWillApply];
    }
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(SEARCH_RESULT) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               NSInteger totalPages = [((NSNumber*)json[@"pagination"][@"total_pages"]) integerValue];
                                               NSArray * arrs = [BRNProduct arrayOfModelsFromDictionaries:json[DATA]];
                                               
                                               if(_delegate && [_delegate respondsToSelector:@selector(onFilter:pages:isNew:)]) {
                                                   
                                                   [_delegate onFilter:arrs pages:totalPages isNew:isNew];
                                               }
                                           } else {
                                               
                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:json[MESSAGE] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                               [alertView show];
                                               if(_delegate && [_delegate respondsToSelector:@selector(onError)]) {
                                                   
                                                   [_delegate onError];
                                               }
                                           }
                                           
                                       } @catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           }
                                           
                                           if(_delegate && [_delegate respondsToSelector:@selector(onError)]) {
                                               
                                               [_delegate onError];
                                           }
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                       if(self.menuContainerViewController.menuState == MFSideMenuStateRightMenuOpen) {
                                           
                                           [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
                                       }
                                   }];
    
}


-(void)applyTaskWithBody
{
    
    NSMutableString * params = [[NSMutableString alloc] init];
    [params appendFormat:@"%@=%@&", DISTRITUBTOR_ID, [BRNLoginInfo shared].distributorId];
    [params appendFormat:@"%@=%@&", LRN_DISTRIBUTOR_ID, [BRNLoginInfo shared].lrnDistributorId];
    [params appendFormat:@"%@=%@&", ZIP_CODE, [BRNLoginInfo shared].zipcode];
    [params appendFormat:@"%@=%@&", PAGE, [NSNumber numberWithInteger:_page].stringValue];
    [params appendFormat:@"%@=%@&", @"type_id", _type.type_id];
    
    switch (_filter) {
        case kFilterBrands:
            for (id object in _selectedItems) {
            
                if ([object isKindOfClass:[BRNFilterItem class]]) {
                
                    BRNFilterItem* filterItem = (BRNFilterItem*) object;
                    [params appendFormat:@"%@=%@&", @"brand_id[]", filterItem.keyId];
                }
            }
        break;
        case kFilterPrice:
            for (id object in _selectedItems) {
                
                if ([object isKindOfClass:[BRNFilterItem class]]) {
                    
                    BRNFilterItem* filterItem = (BRNFilterItem*) object;
                    [params appendFormat:@"%@=%@&", @"price_range_id", filterItem.keyId];
                }
            }
        break;
        case kFilterType:
            for (id object in _selectedItems) {
                
                BRNNameFilterItem * nameFilter = (BRNNameFilterItem*)object;
                
                if ([_section.sectionid isEqualToString:SECTION_ID_2]
                    || [_section.sectionid isEqualToString:SECTION_ID_3]) {
                    
                    [params appendFormat:@"%@=%@&", @"style_type_name", nameFilter.name];
                }  else if ([object isKindOfClass:[BRNFilterItem class]]) {
                    
                    BRNFilterItem * filterItem = (BRNFilterItem*) object;
                    [params appendFormat:@"%@=%@&", @"style_id[]", filterItem.keyId];
                }
            }
        break;
        case kFilterProducers:
            for (id object in _selectedItems) {
                
                if ([object isKindOfClass:[BRNFilterItem class]]) {
                    
                    BRNFilterItem *filterItem = (BRNFilterItem*) object;
                    [params appendFormat:@"%@=%@&", @"producer_id[]", filterItem.keyId];
                }
            }
        break;
    }
    
    [HUD showUIBlockingIndicator];
    if(_delegate && [_delegate respondsToSelector:@selector(onWillApply)]) {
        
        [_delegate onWillApply];
    }
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(SEARCH_RESULT) bodyString:params
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {

                                               NSInteger totalPages = [((NSNumber*)json[@"pagination"][@"total_pages"]) integerValue];
                                               NSArray * arrs = [BRNProduct arrayOfModelsFromDictionaries:json[DATA]];
                                               
                                               if(_delegate && [_delegate respondsToSelector:@selector(onFilter:pages:isNew:)]) {
                                                   
                                                   [_delegate onFilter:arrs pages:totalPages isNew:isNew];
                                               }
                                           } else {

                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:!json?@"No Product Found. Please Try again":json[MESSAGE] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                               [alertView show];
                                               if(_delegate && [_delegate respondsToSelector:@selector(onError)]) {
                                                   
                                                   [_delegate onError];
                                               }
                                           }
                                           
                                       } @catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           }
                                           
                                           if(_delegate && [_delegate respondsToSelector:@selector(onError)]) {
                                               
                                               [_delegate onError];
                                           }
                                       }
                                       
                                       [HUD hideUIBlockingIndicator];
                                       if(self.menuContainerViewController.menuState == MFSideMenuStateRightMenuOpen) {
                                           
                                           [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
                                       }
                                   }];
    
}

-(void)initWith:(BRNSection*) section type:(BRNType*)type delegate:(id)delegate
{
    _section = section;
    _type = type;
    _delegate = delegate;
    isNew = YES;
    _page = 1;
    _selectedItems = nil;
    _searchItemArr = [[NSArray alloc] init];
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

-(void)openRightFilter:(BRNFilterMode) filterMode
{
    
    _tmpFilter = filterMode;
    isNew = YES;
    _itemArr = nil;
    [_tableView reloadData];
    
    _tmpSelectedItems = [[NSMutableArray alloc] init];
    
    NSMutableString * string = [[NSMutableString alloc] init];
    [string appendString:@"Filter By "];
    
    switch (filterMode) {
        case kFilterBrands:
            [string appendString:@"Brands"];
            _tableView.allowsMultipleSelection = YES;
        break;
        case kFilterPrice:
            [string appendString:@"Price"];
        break;
        case kFilterProducers:
            [string appendString:@"Producers"];
            _tableView.allowsMultipleSelection = YES;
        break;
        case kFilterType:
            [string appendString:@"Type"];
        break;
    }
    
    _titleLabel.text = string;
    
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self filterTask];
    }];
}

-(void)performTask:(NSInteger)pages
{
    isNew = NO;
    _page = pages;
    
    [self applyTaskWithBody];
}

- (IBAction)applyClicked:(id)sender {
    
    if(_tmpSelectedItems == nil || _tmpSelectedItems.count == 0) {
        
        [self.view makeToast:@"Please Select Filter Item"];
        return;
    }
    
    _selectedItems = [[NSArray alloc] initWithArray:_tmpSelectedItems];
    _filter = _tmpFilter;
    
//    [self applyTask];
    [self applyTaskWithBody];
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
    @try {
        
        if(_searchField.text.length == 0) {
            
            BRNNameFilterItem * filterItem = (BRNNameFilterItem*) _itemArr[indexPath.row];
            if(![_tmpSelectedItems containsObject:filterItem]) {
                
                [_tmpSelectedItems addObject:filterItem];
            }
            
        } else {
            
            BRNNameFilterItem * filterItem = (BRNNameFilterItem*) _searchItemArr[indexPath.row];
            if(![_tmpSelectedItems containsObject:filterItem]) {
                
                [_tmpSelectedItems addObject:filterItem];
            }
        }
    } @catch (NSException * exception) {
        
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(_searchField.text.length == 0) {
            
            BRNNameFilterItem * filterItem = (BRNNameFilterItem*) _itemArr[indexPath.row];
            if([_tmpSelectedItems containsObject:filterItem]) {
                
                [_tmpSelectedItems removeObject:filterItem];
            }
        } else {
            
            BRNNameFilterItem * filterItem = (BRNNameFilterItem*) _searchItemArr[indexPath.row];
            if([_tmpSelectedItems containsObject:filterItem]) {
                
                [_tmpSelectedItems removeObject:filterItem];
            }
        }
    }@catch (NSException * exception) {
        
    }
}

- (IBAction)ResetFilter:(UIButton *)sender {
    [_tmpSelectedItems removeAllObjects];
    _searchField.text = @"";
    [self.tableView reloadData];
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
        
        if(_searchField.text.length == 0) {
            
            return _itemArr.count;
        } else {
            
            return _searchItemArr.count;
        }
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRNFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:kFilterReusableCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BRNFilterCell" bundle:nil] forCellReuseIdentifier:kFilterReusableCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kFilterReusableCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(_searchField.text.length == 0) {
        
        BRNNameFilterItem * nameItem = _itemArr[indexPath.row];
        cell.titleLabel.text = nameItem.name;
    } else {
        
        BRNNameFilterItem * nameItem = _searchItemArr[indexPath.row];
        cell.titleLabel.text = nameItem.name;
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    _searchItemArr = [_itemArr filteredArrayUsingPredicate:resultPredicate];
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

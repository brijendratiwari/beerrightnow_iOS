 //
//  BRNProductDisplayController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNProductDisplayController.h"
#import "BRNProductCollectionCell.h"
#import "BRNProductController.h"

#import "BRNKeywordProductDisplayController.h"

#import "BRNSection.h"
#import "BRNType.h"
#import "BRNProduct.h"

@interface BRNProductDisplayController () <UISearchBarDelegate>{
    
    NSInteger _totalPages;
    NSInteger _currentPage;
    MBProgressHUD * _loadingHUD;
    BOOL _keyboardShown;
    BOOL _isFilterMode;
}

@property (strong, nonatomic) NSMutableArray * productArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@end

@implementation BRNProductDisplayController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self productTask];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    [self initializeRightNaviationItems:YES];
    
    @try {
        
        self.navigationItem.title =  _type.type_name;
        
    } @catch (NSException * exception){
        
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    _searchBar.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BRNProductCollectionCell" bundle:nil] forCellWithReuseIdentifier:kProductReusableCellIdentifier];
    
    if(![_section.sectionid isEqualToString:@"1"]) {
        
        _brandBtn.hidden = YES;
    }
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    tapGesture.delegate = self;
    
    [self.view addGestureRecognizer:tapGesture];
    
    [[[BRNFlowManager shared] filterController] initWith:_section type:_type delegate:self];
    
    _currentPage = 1;
    _loadingHUD = nil;
    _productArr = nil;
    _keyboardShown = NO;
    _isFilterMode = NO;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCartBadge];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[BRNFlowManager shared] setRightFilterController:YES];
    [[BRNFlowManager shared] setPanMode:MFSideMenuPanModeNone];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[BRNFlowManager shared] setRightFilterController:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:kProductControllerIdentifier] && sender != nil && [sender isKindOfClass:[BRNProduct class]]) {
        
        BRNProductController * productController = (BRNProductController*)segue.destinationViewController;
        productController.product = sender;
        productController.navigationItem.title = _type.type_name;
    }
}

- (IBAction)priceClicked:(id)sender {

    [[[BRNFlowManager shared] filterController] openRightFilter:kFilterPrice];
}

- (IBAction)brandClicked:(id)sender {
    
    [[[BRNFlowManager shared] filterController] openRightFilter:kFilterBrands];
}

-(void)productTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:_type.type_id forKey:TYPE_ID];
    [dic setObject:[NSNumber numberWithInteger:_currentPage].stringValue forKey:PAGE];
    
    
    _loadingHUD = [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_PRODUCT_BY_TYPE) params:dic
                                   completion:^(NSDictionary * json, JSONModelError * err) {
                                       
                                       @try {
                                           
                                           if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                                               
                                               _totalPages = [((NSNumber*)json[@"pagination"][@"total_pages"]) integerValue];
                                               
                                               NSArray * arrs = [BRNProduct arrayOfModelsFromDictionaries:json[DATA]];
                                               if(_productArr == nil) {
                                                   
                                                   _productArr = [[NSMutableArray alloc] initWithArray:arrs];
                                               } else {
                                                   
                                                   [_productArr addObjectsFromArray:arrs];
                                               }
                                               
                                               [_collectionView reloadData];
                                           } else {
                                               
                                               [self.view makeToast:@"No Product Founds..."];
                                           }
                                           
                                       }@catch ( NSException  * exception) {
                                           
                                           NSLog(@"%@", exception.reason);
                                           if(err != nil) {
                                               
                                               [self.view makeToast:[err localizedDescription]];
                                           }
                                       }
                                   
                                       [HUD hideUIBlockingIndicator];
                                       _loadingHUD = nil;
                                   }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"%f",point.x);
}


#pragma mark RightFilterDelegate methods

-(void)onFilter:(NSArray*) products pages:(NSInteger)pages isNew:(BOOL)isNew
{
    if(_loadingHUD) {
        
        [HUD hideUIBlockingIndicator];
        _loadingHUD = nil;
    }
    
    if(!_isFilterMode)
    {
        _isFilterMode = YES;
    }
    
    if(isNew) {
        
        _currentPage = 1;
        _totalPages = pages;
        [_productArr removeAllObjects];
        [_collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    
    [_productArr addObjectsFromArray:products];
    [_collectionView reloadData];
}

-(void)onError
{
    if(_loadingHUD) {
        
        [HUD hideUIBlockingIndicator];
        _loadingHUD = nil;
    }
}

-(void)onWillApply
{
    if(_loadingHUD) {
        
        _loadingHUD = nil;
    }
    _loadingHUD = [HUD showUIBlockingIndicator];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    
    // When the search button is tapped, add the search term to recents and conduct the search.
    [self hideKeyBoard];
    
    NSString *searchString = [self.searchBar text];
    
    BRNKeywordProductDisplayController * keywordController = (BRNKeywordProductDisplayController*) [[BRNFlowManager shared].storyBoardForMain instantiateViewControllerWithIdentifier:kKeywordProductDisplayControllerIdentifier];
    
    keywordController.keyword = searchString;
    
    [self.navigationController pushViewController:keywordController animated:YES];
}


#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_collectionView] && !_keyboardShown) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}


#pragma mark - UICollectionView Datasource

// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    @try {
        
        return _productArr.count;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BRNProductCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kProductReusableCellIdentifier forIndexPath:indexPath];
    
    BRNProduct * product = _productArr[indexPath.row];
    
    NSString * wholeName = product.products_name;
    NSArray * names;
    if([wholeName rangeOfString:@","].length != 0) {
        
        names = [wholeName componentsSeparatedByString:@","];
    } else {
        
        names = @[wholeName, @""];
    }
    
    cell.productName.text = names[0];
    [cell.productName setAdjustsFontSizeToFitWidth:YES];
    cell.productSize.text = [((NSString*)names[1]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [cell.productSize setAdjustsFontSizeToFitWidth:YES];

    cell.productPrice.text = [NSString stringWithFormat:@"%@%@",@"$", [[BRNUtils shared] convertToDecimalPointString:[product.products_price floatValue] decimalCount:2]];
    
    NSString * urlString = [product.products_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ImageCacheManager setImageView:cell.productImgView withUrlString:urlString];
    
//    [[BRNUtils shared] setBorder:cell color:[UIColor blackColor] cornerRadius:3 borderWidth:1.0f];
    
    return cell;
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:NO];
//    [super touchesEnded:touches withEvent:event];
//}

#define MARGIN_HOR 13
#define MARGIN_VER 7
#define CELL_WIDTH_HEIGHT_RATE 1.5

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kProductControllerIdentifier sender:_productArr[indexPath.row]];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray * cellArr = [_collectionView indexPathsForVisibleItems];
    for(NSIndexPath * indexPath in cellArr) {
        
        if(indexPath.row == _productArr.count - 1 && _currentPage < _totalPages && _loadingHUD == nil) {
            
            _currentPage ++;
            if(!_isFilterMode) {
                
                [self productTask];
            } else {
                
                [[[BRNFlowManager shared] filterController] performTask:_currentPage];
            }
            break;
        }
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    NSInteger cols = size.width >= 400 ? 3 : 2;
    
    float pureCellWidth = size.width - (MARGIN_HOR * 2 * cols);
    pureCellWidth /= cols;
    
    return CGSizeMake(pureCellWidth, pureCellWidth * CELL_WIDTH_HEIGHT_RATE);
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(MARGIN_VER, MARGIN_HOR, MARGIN_VER, MARGIN_HOR);
}

@end

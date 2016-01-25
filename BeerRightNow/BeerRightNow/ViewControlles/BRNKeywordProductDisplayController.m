 //
//  BRNProductDisplayController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/8/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNProductController.h"
#import "BRNProductCollectionCell.h"
#import "BRNKeywordProductDisplayController.h"

#import "BRNSection.h"
#import "BRNType.h"
#import "BRNProduct.h"

@interface BRNKeywordProductDisplayController () {
    
    NSInteger _totalPages;
    NSInteger _currentPage;
    MBProgressHUD * _loadingHUD;
    BOOL _keyboardShown;
    BOOL _isFilterMode;
}

@property (strong, nonatomic) NSMutableArray * productArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation BRNKeywordProductDisplayController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self searchTask];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    [self initializeRightNaviationItems:YES];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BRNProductCollectionCell" bundle:nil] forCellWithReuseIdentifier:kProductReusableCellIdentifier];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    tapGesture.delegate = self;
    
    [self.view addGestureRecognizer:tapGesture];
    
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
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:kProductControllerIdentifier2] && sender != nil && [sender isKindOfClass:[BRNProduct class]]) {
        
        BRNProduct * product = (BRNProduct*)sender;
        
        BRNProductController * productController = (BRNProductController*)segue.destinationViewController;
        productController.product = product;
        productController.navigationItem.title = product.products_name;
    }
}

- (IBAction)priceClicked:(id)sender {

    [[[BRNFlowManager shared] filterController] openRightFilter:kFilterPrice];
}

- (IBAction)brandClicked:(id)sender {
    
    [[[BRNFlowManager shared] filterController] openRightFilter:kFilterBrands];
}

-(void)searchTask
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:_keyword forKey:@"keyword"];
    [dic setObject:[NSNumber numberWithInteger:_currentPage].stringValue forKey:PAGE];
    
    
    _loadingHUD = [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(SEARCH_RESULT) params:dic
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
                                               
                                               UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry. I couldn't find that.\nLet's try something else!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                               [alertView show];
                                               [self backClicked];
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
    cell.productSize.text = [((NSString*)names[1]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    cell.productPrice.text = [NSString stringWithFormat:@"%@%@",@"$", [[BRNUtils shared] convertToDecimalPointString:[product.products_price floatValue] decimalCount:2]];
    [cell.productName setAdjustsFontSizeToFitWidth:YES];
    [cell.productSize setAdjustsFontSizeToFitWidth:YES];
    
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
    
    [self performSegueWithIdentifier:kProductControllerIdentifier2 sender:_productArr[indexPath.row]];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray * cellArr = [_collectionView indexPathsForVisibleItems];
    for(NSIndexPath * indexPath in cellArr) {
        
        if(indexPath.row == _productArr.count - 1 && _currentPage < _totalPages && _loadingHUD == nil) {
            
            _currentPage ++;
            if(!_isFilterMode) {
                
                [self searchTask];
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

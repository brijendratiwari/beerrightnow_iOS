//
//  BRNTypeController.m
//  BeerRightNow
//
//  Created by dukce pak on 4/6/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNTypeController.h"
#import "BRNProductDisplayController.h"

#import "BRNSection.h"
#import "BRNType.h"

@interface BRNTypeController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@end

@implementation BRNTypeController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI
{
    [self initializeLeftButtonItem];
    [self initializeRightNaviationItems:YES];
    
    @try {
        
        self.navigationItem.title =  self.section.name;
        [ImageCacheManager setImageView:_typeImgView withUrlString:self.section.image];
        
    } @catch (NSException * exception){
        
    }
    
    CGRect headerRect = self.headerView.frame;
    headerRect.size.height = self.view.frame.size.height * 0.42;
    self.headerView.frame = headerRect;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateCartBadge];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kProductDisplayControllerIdentifier2]) {
        
        if([sender isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * params = (NSDictionary*)sender;
            
            BRNProductDisplayController * productDisplayController = (BRNProductDisplayController*)segue.destinationViewController;
            productDisplayController.section = (BRNSection*) [params objectForKey:SECTION_ID];
            productDisplayController.type = (BRNType*)[params objectForKey:TYPE_ID];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        BRNType * type = (BRNType*)_typeArr[indexPath.row];
        
        NSDictionary * params = [[NSDictionary alloc] initWithObjects:@[_section, type] forKeys:@[SECTION_ID, TYPE_ID]];
        [self performSegueWithIdentifier:kProductDisplayControllerIdentifier2 sender:params];
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
        
        return _typeArr.count;
    } @catch (NSException * exception) {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TypeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    @try {
        
        BRNType * type = _typeArr[indexPath.row];
        cell.textLabel.text = type.type_name;
        
    } @catch (NSException *exception){
        
    }
    
    return cell;
}

@end

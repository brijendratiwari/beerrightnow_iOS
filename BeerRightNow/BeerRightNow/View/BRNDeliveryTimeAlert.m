//
//  BRNDeliveryTimeAlert.m
//  BeerRightNow
//
//  Created by Dragon on 4/28/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNDeliveryTimeAlert.h"
#import "BRNCartResponse.h"
#import "BRNBeer.h"
#import "BRNLiquor.h"

@interface BRNDeliveryTimeAlert () {
    
    NSDateFormatter * _dateFormatter;
    NSDateFormatter * onlyDayFormatter;
    NSDateFormatter * onlyDateFormatter;
    NSDateFormatter * onlyTimeFormatter;
    
    NSString *curretnSelectedDate;
    NSMutableArray *timeListArray,*beerTimeListArrya,*liquorTimeListArray;
    
    
    IBOutlet UIButton *dateSelectBtn,*timeSelecteBtn;
    IBOutlet UIButton *liquorDateSelectBtn,*liquorTimeSelecteBtn,*redioCartBtn,*redioLiquorBtn;
    IBOutlet UIButton *okayBtn,*cancelBtn;
    IBOutlet UIImageView *backgroundView;
    IBOutlet UIView *containerView;
    IBOutlet UILabel *dateMissMatchInfoLbl;
    BOOL isDateChanged;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (weak, nonatomic) IBOutlet RadioButton *asapRadio;
@end

@implementation BRNDeliveryTimeAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      timeListArray = [NSMutableArray array];
    
    [redioCartBtn.titleLabel setNumberOfLines:0];
    [redioLiquorBtn.titleLabel setNumberOfLines:0];
    
    
    [_asapRadio setTitle:ASAP forState:UIControlStateNormal];
    _asapRadio.selected = YES;
    _dateTimePicker.userInteractionEnabled = NO;
    

    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:DATE_FORMAT];
    
    
    onlyDayFormatter = [[NSDateFormatter alloc] init];
    [onlyDayFormatter setDateFormat:@"EEEE"];
    
    onlyDateFormatter = [[NSDateFormatter alloc] init];
    [onlyDateFormatter setDateFormat:@"MM/dd/yyy"];
    
    onlyTimeFormatter = [[NSDateFormatter alloc] init];
    [onlyTimeFormatter setDateFormat:@"HH:mm(a)"];
    
    
    //_dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _dateTimePicker.datePickerMode = UIDatePickerModeDate;
    [_dateTimePicker setMinimumDate: [NSDate date]];
    isDateChanged =YES;
    
   
 
}
-(void) viewDidAppear:(BOOL)animated
{
    if([UIScreen mainScreen].bounds.size.height == 480.0f)
    {
        [containerView setFrame:CGRectMake(containerView.frame.origin.x, 0, containerView.frame.size.width, containerView.frame.size.height)];
    }
    
}


-(void) changeFrameForMissDate:(BOOL)boolen
{
    if (boolen)
    {
        if (backgroundView.frame.size.height == 300 || (backgroundView.frame.size.height == 420 && redioCartBtn.isSelected))
        {
           
            [backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, 370)];
            [_dateTimePicker setFrame:CGRectMake(_dateTimePicker.frame.origin.x, backgroundView.frame.size.height-203, _dateTimePicker.frame.size.width, _dateTimePicker.frame.size.height)];
            [_timePickerView setFrame:CGRectMake(_timePickerView.frame.origin.x, backgroundView.frame.size.height-203, _timePickerView.frame.size.width, _timePickerView.frame.size.height)];
            [okayBtn setFrame:CGRectMake(okayBtn.frame.origin.x, backgroundView.frame.size.height-46, okayBtn.frame.size.width, okayBtn.frame.size.height)];
            [cancelBtn setFrame:CGRectMake(cancelBtn.frame.origin.x, backgroundView.frame.size.height-46, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
            
            [redioCartBtn setSelected:YES];
            [redioLiquorBtn setSelected:NO];
            [dateMissMatchInfoLbl setHidden:NO];
            [redioLiquorBtn setHidden:NO];
            [redioCartBtn setHidden:NO];
            [liquorDateSelectBtn setHidden:YES];
            [liquorTimeSelecteBtn setHidden:YES];
            [_dateTimePicker setHidden:YES];
            [_timePickerView setHidden:YES];
        }
        else if (backgroundView.frame.size.height == 370 && redioLiquorBtn.isSelected)
        {
            
            [backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, 420)];
            [_dateTimePicker setFrame:CGRectMake(_dateTimePicker.frame.origin.x, backgroundView.frame.size.height-203, _dateTimePicker.frame.size.width, _dateTimePicker.frame.size.height)];
            [_timePickerView setFrame:CGRectMake(_timePickerView.frame.origin.x, backgroundView.frame.size.height-203, _timePickerView.frame.size.width, _timePickerView.frame.size.height)];
            [okayBtn setFrame:CGRectMake(okayBtn.frame.origin.x, backgroundView.frame.size.height-46, okayBtn.frame.size.width, okayBtn.frame.size.height)];
            [cancelBtn setFrame:CGRectMake(cancelBtn.frame.origin.x, backgroundView.frame.size.height-46, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
           
            [dateMissMatchInfoLbl setHidden:NO];
            [redioLiquorBtn setHidden:NO];
            [redioCartBtn setHidden:NO];
            [self onDateSelecteBtn:liquorDateSelectBtn];
            
            
        }
    }
    else
    {
        if (backgroundView.frame.size.height == 420 || backgroundView.frame.size.height == 370)
        {
            [BRNCartInfo shared].deliveryLiquorExpected = nil;
            [backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, 300)];
            [_dateTimePicker setFrame:CGRectMake(_dateTimePicker.frame.origin.x, backgroundView.frame.size.height-203, _dateTimePicker.frame.size.width, _dateTimePicker.frame.size.height)];
            [_timePickerView setFrame:CGRectMake(_timePickerView.frame.origin.x, backgroundView.frame.size.height-203, _timePickerView.frame.size.width, _timePickerView.frame.size.height)];
            [okayBtn setFrame:CGRectMake(okayBtn.frame.origin.x, backgroundView.frame.size.height-46, okayBtn.frame.size.width, okayBtn.frame.size.height)];
            [cancelBtn setFrame:CGRectMake(cancelBtn.frame.origin.x, backgroundView.frame.size.height-46, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
            [liquorDateSelectBtn setHidden:YES];
            [liquorTimeSelecteBtn setHidden:YES];
            [dateMissMatchInfoLbl setHidden:YES];
            [redioLiquorBtn setHidden:YES];
            [redioCartBtn setHidden:YES];
            
        }
        
        if (_asapRadio.isSelected)
        {
            [BRNCartInfo shared].deliveryLiquorExpected = nil;
            [backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, 100)];
            [okayBtn setFrame:CGRectMake(okayBtn.frame.origin.x, backgroundView.frame.size.height-46, okayBtn.frame.size.width, okayBtn.frame.size.height)];
            [cancelBtn setFrame:CGRectMake(cancelBtn.frame.origin.x, backgroundView.frame.size.height-46, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
            
        }
        else if (backgroundView.frame.size.height == 100)
        {
            [BRNCartInfo shared].deliveryLiquorExpected = nil;
            [backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, 300)];
            [_dateTimePicker setFrame:CGRectMake(_dateTimePicker.frame.origin.x, backgroundView.frame.size.height-203, _dateTimePicker.frame.size.width, _dateTimePicker.frame.size.height)];
            [_timePickerView setFrame:CGRectMake(_timePickerView.frame.origin.x, backgroundView.frame.size.height-203, _timePickerView.frame.size.width, _timePickerView.frame.size.height)];
            [okayBtn setFrame:CGRectMake(okayBtn.frame.origin.x, backgroundView.frame.size.height-46, okayBtn.frame.size.width, okayBtn.frame.size.height)];
            [cancelBtn setFrame:CGRectMake(cancelBtn.frame.origin.x, backgroundView.frame.size.height-46, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) changeButtonColor:(UIButton *)btn
{
    [dateSelectBtn setBackgroundColor:[UIColor darkGrayColor]];
    [timeSelecteBtn setBackgroundColor:[UIColor darkGrayColor]];
    [liquorDateSelectBtn setBackgroundColor:[UIColor darkGrayColor]];
    [liquorTimeSelecteBtn setBackgroundColor:[UIColor darkGrayColor]];
    [btn setBackgroundColor: [UIColor colorWithRed:22/255.f green:103/255.f blue:150/255.f alpha:1.0]];
    
}

-(IBAction)onDateSelecteBtn:(UIButton *)sender
{
    [_dateTimePicker setHidden:NO];
    [_timePickerView setHidden:YES];
    [_dateTimePicker setTag:sender.tag];
    [self changeButtonColor:sender];
    
    
}

-(IBAction)onTimeSelecteBtn:(UIButton *)sender
{
    [self changeButtonColor:sender];
    if (sender.tag == 0)
    {
        [dateSelectBtn setTitle:[onlyDateFormatter stringFromDate:_dateTimePicker.date] forState:UIControlStateNormal];
    }
    else
    {
        [liquorDateSelectBtn setTitle:[onlyDateFormatter stringFromDate:_dateTimePicker.date] forState:UIControlStateNormal];

    }
    [_dateTimePicker setHidden:YES];
    [_timePickerView setHidden:NO];
    [_timePickerView setTag:sender.tag];
    int todaysDate = 0;
    if ([[onlyDateFormatter stringFromDate:_dateTimePicker.date] isEqualToString:[onlyDateFormatter stringFromDate:[NSDate date]]])
    {
        NSLog(@"this is today");
        todaysDate = 1;
    }
    if (isDateChanged)
    {
        isDateChanged = NO;
        if (sender.tag == 0)
        {
            [timeSelecteBtn setTitle:@"Select Time" forState:UIControlStateNormal];
            [self getDistributorworkinghours:[onlyDayFormatter stringFromDate:_dateTimePicker.date] isToday:todaysDate ForBeer:1];
        }
        else
        {
            [liquorTimeSelecteBtn setTitle:@"Select Time" forState:UIControlStateNormal];
            [self getDistributorworkinghours:[onlyDayFormatter stringFromDate:_dateTimePicker.date] isToday:todaysDate ForBeer:0];
        }
    }
    else
    {
        if (sender.tag == 0)
        {
            [timeListArray removeAllObjects];
            [timeListArray addObjectsFromArray:beerTimeListArrya];
        }
        else
        {
            [timeListArray removeAllObjects];
            [timeListArray addObjectsFromArray:liquorTimeListArray];
        }
        [_timePickerView reloadAllComponents];
    }
}



-(IBAction)onDatePickerValueChanged:(UIDatePicker *)sender
{
    isDateChanged = YES;
    if (sender.tag == 0)
    {
        [timeSelecteBtn setTitle:@"Select Time" forState:UIControlStateNormal];
        [dateSelectBtn setTitle:[onlyDateFormatter stringFromDate:sender.date] forState:UIControlStateNormal];
    }
    else
    {
        [liquorTimeSelecteBtn setTitle:@"Select Time" forState:UIControlStateNormal];
        [liquorDateSelectBtn setTitle:[onlyDateFormatter stringFromDate:sender.date] forState:UIControlStateNormal];

    }
    
}


- (IBAction)okClicked:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(onDeliveryTime:)]) {
        
        if(_asapRadio.isSelected) {
            
            [_delegate onDeliveryTime:ASAP];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            if ([dateSelectBtn.titleLabel.text  isEqualToString:@"Select Date"])
            {
                [self.view makeToast:@"Please select date."];
            }
            else if ([timeSelecteBtn.titleLabel.text  isEqualToString:@"Select Time"])
            {
                [self.view makeToast:@"Please select time."];
            }
            else if(![liquorTimeSelecteBtn isHidden] && [liquorDateSelectBtn.titleLabel.text  isEqualToString:@"Select Date"])
            {
                [self.view makeToast:@"Please select liquor delivery date."];
            }
            else if (![liquorTimeSelecteBtn isHidden] && [liquorTimeSelecteBtn.titleLabel.text  isEqualToString:@"Select Time"])
            {
                [self.view makeToast:@"Please select liquor delivery time."];
            }
            else
            {
//                NSDate * date = _dateTimePicker.date;
//                [_delegate onDeliveryTime:[_dateFormatter stringFromDate:date]];
                
            
                //NSString *date = [onlyDateFormatter stringFromDate:_dateTimePicker.date];
                NSString *time = timeSelecteBtn.titleLabel.text;
                time = [time stringByReplacingOccurrencesOfString:@"am" withString:@"(AM)"];
                time = [time stringByReplacingOccurrencesOfString:@"pm" withString:@"(PM)"];
                curretnSelectedDate = [NSString stringWithFormat:@"%@ %@",dateSelectBtn.titleLabel.text,time];
                
                if (![liquorDateSelectBtn isHidden]) {
                    NSString *time = liquorTimeSelecteBtn.titleLabel.text;
                    time = [time stringByReplacingOccurrencesOfString:@"am" withString:@"(AM)"];
                    time = [time stringByReplacingOccurrencesOfString:@"pm" withString:@"(PM)"];
                    [BRNCartInfo shared].deliveryLiquorExpected = [NSString stringWithFormat:@"%@ %@",liquorDateSelectBtn.titleLabel.text,time];
                    
                }
                
                [_delegate onDeliveryTime:curretnSelectedDate];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }
 
}
- (IBAction)cancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)onOptionRadioBtn:(UIButton *)sender
{
    
    [redioCartBtn setSelected:NO];
    [redioLiquorBtn setSelected:NO];
    [sender setSelected:YES];
    
    if ([redioCartBtn isSelected])
    {
        [BRNCartInfo shared].saveLiquoeInCart = YES;
        [liquorDateSelectBtn setHidden:YES];
        [liquorTimeSelecteBtn setHidden:YES];
    }
    else
    {
        [liquorDateSelectBtn setHidden:NO];
        [liquorTimeSelecteBtn setHidden:NO];
        [BRNCartInfo shared].saveLiquoeInCart = NO;
        
        
    }
    [self changeFrameForMissDate:YES];

}

- (IBAction)onRadioClicked:(id)sender {
    
    if(_asapRadio.selected) {
        
        _dateTimePicker.userInteractionEnabled = NO;
        _timePickerView.userInteractionEnabled = NO;
        liquorDateSelectBtn.userInteractionEnabled = NO;
        liquorTimeSelecteBtn.userInteractionEnabled = NO;
        [dateSelectBtn setEnabled:NO];
        [timeSelecteBtn setEnabled:NO];
        [redioCartBtn setEnabled:NO];
        [redioLiquorBtn setEnabled:NO];
        
        
       
        
        [_dateTimePicker setHidden:YES];
        [_timePickerView setHidden:YES];
        [liquorDateSelectBtn setHidden:YES];
        [liquorTimeSelecteBtn setHidden:YES];
        [dateSelectBtn setHidden:YES];
        [timeSelecteBtn setHidden:YES];
        [redioCartBtn setHidden:YES];
        [redioLiquorBtn setHidden:YES];
        [dateMissMatchInfoLbl setHidden:YES];

        [self changeFrameForMissDate:NO];
    
        
    } else {
        
        _dateTimePicker.userInteractionEnabled = YES;
        _timePickerView.userInteractionEnabled = YES;
        liquorDateSelectBtn.userInteractionEnabled = YES;
        liquorTimeSelecteBtn.userInteractionEnabled = YES;
        [dateSelectBtn setEnabled:YES];
        [timeSelecteBtn setEnabled:YES];
        [redioCartBtn setEnabled:YES];
        [redioLiquorBtn setEnabled:YES];
        
        
        
        [dateMissMatchInfoLbl setHidden:YES];
        [_dateTimePicker setHidden:NO];
        [_timePickerView setHidden:NO];
        [liquorDateSelectBtn setHidden:YES];
        [liquorTimeSelecteBtn setHidden:YES];
        [dateSelectBtn setHidden:NO];
        [timeSelecteBtn setHidden:NO];
        [redioCartBtn setHidden:YES];
        [redioLiquorBtn setHidden:YES];
        [self onDateSelecteBtn:dateSelectBtn];
        [self changeFrameForMissDate:NO];
    }
}

-(void)getDistributorworkinghours:(NSString *)dayName isToday:(int) today ForBeer:(int) isBeer
{
    dayName = [dayName uppercaseString];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[BRNLoginInfo shared].distributorId forKey:DISTRITUBTOR_ID];
    [dic setObject:[BRNLoginInfo shared].lrnDistributorId forKey:LRN_DISTRIBUTOR_ID];
    [dic setObject:[BRNLoginInfo shared].zipcode forKey:ZIP_CODE];
    [dic setObject:dayName forKey:DAY_NAME];
    if (today)
    {
      [dic setObject:[NSNumber numberWithInt:1] forKey:IS_TODAY];
    }
    //NSLog(@"sending data dict===>%@",dic);
    
    [HUD showUIBlockingIndicator];
    
    [JSONHTTPClient postJSONFromURLWithString:REQUEST_URL(GET_DISTRIBUTOR_WORKING_HOUR) params:dic completion:^(NSDictionary * json, JSONModelError * err) {
        NSLog(@"Response : %@",json);
        @try {
            
            if(err != nil) {
                
                [self.view makeToast:err.localizedDescription];
                
            } else {
                
                if([json[STATUS] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                    
                    //NSLog(@"response ===>%@",json[DATA]);
                    if (json[DATA][[BRNLoginInfo shared].distributorId])
                    {
                        beerTimeListArrya = [json[DATA][[BRNLoginInfo shared].distributorId][@"delivery_time"][dayName] valueForKey:@"time"];
                        
                    }
                    if (json[DATA][[BRNLoginInfo shared].lrnDistributorId])
                    {
                        liquorTimeListArray = [json[DATA][[BRNLoginInfo shared].lrnDistributorId][@"delivery_time"][dayName] valueForKey:@"time"];
                    }
                    if (isBeer)
                    {
                        [timeListArray removeAllObjects];
                        [timeListArray addObjectsFromArray:beerTimeListArrya];
                    }
                    else
                    {
                        [timeListArray removeAllObjects];
                        [timeListArray addObjectsFromArray:liquorTimeListArray];
                    }
                    if (_cartResponse.beer.products.count ==0 && _cartResponse.liquor.products.count != 0)
                    {
                        [timeListArray removeAllObjects];
                        [timeListArray addObjectsFromArray:liquorTimeListArray];
                    }
                    // [self pickerView:_timePickerView didSelectRow:0 inComponent:0];
                    [_timePickerView reloadAllComponents];
                    
                } else {
                    
                    [self.view makeToast:json[MESSAGE]];
                }
            }
            
        }@catch ( NSException  * exception) {
            
            NSLog(@"%@", exception.reason);
            if(err != nil) {
                
                [self.view makeToast:[err localizedDescription]];
            }
        }
        
        [HUD hideUIBlockingIndicator];
    }];
    
}


#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    
    if (pickerView.tag == 0)
    {
        [timeSelecteBtn setTitle:[[timeListArray objectAtIndex:row] stringByReplacingOccurrencesOfString:@" (Midnight)" withString:@""] forState:UIControlStateNormal];
        if ([_timePickerView isHidden])
        {
            [timeSelecteBtn setTitle:@"Select Time" forState:UIControlStateNormal];
        }
        
        
        if (_cartResponse.beer.products.count == 0 || _cartResponse.liquor.products.count == 0)
        {
            [self changeFrameForMissDate:NO];
        }
        else if(_cartResponse.beer.products.count !=0 && _cartResponse.liquor.products.count !=0)
        {
            if ([liquorTimeListArray containsObject:[beerTimeListArrya objectAtIndex:row]])
            {
                [self changeFrameForMissDate:NO];
                
            }
            else
            {
                [self changeFrameForMissDate:YES];
            }
        }
        
        
        
    }
    else if (pickerView.tag == 1 && _cartResponse.liquor.products.count != 0)
    {
        [liquorTimeSelecteBtn setTitle:[[timeListArray objectAtIndex:row] stringByReplacingOccurrencesOfString:@" (Midnight)" withString:@""] forState:UIControlStateNormal];
        if ([_timePickerView isHidden])
        {
            [liquorTimeSelecteBtn setTitle:@"Select Time" forState:UIControlStateNormal];
        }
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [timeListArray count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [timeListArray objectAtIndex:row];
    
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

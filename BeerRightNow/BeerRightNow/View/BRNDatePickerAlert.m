//
//  BRNDatePickerAlert.m
//  BeerRightNow
//
//  Created by dukce pak on 4/17/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNDatePickerAlert.h"

@interface BRNDatePickerAlert () {

    NSDate * _date;
    UIDatePickerMode _pickerMode;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation BRNDatePickerAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_date) {
        
        [_datePicker setDate:_date animated:YES];
    }
    
    _datePicker.datePickerMode = _pickerMode;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
    [_backgroundView addGestureRecognizer:tapRecognizer];
    
    
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    _pickerMode = datePickerMode;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
}

- (void)backgroundViewTapped:(UIGestureRecognizer *)sender {
    
    [self cancelClicked:sender];
}

- (IBAction)okClicked:(id)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(onDatePicker:)]) {
        
        [_delegate onDatePicker:_datePicker.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end

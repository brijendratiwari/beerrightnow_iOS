//
//  BRNExpireDateAlert.m
//  BeerRightNow
//
//  Created by dukce pak on 5/27/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNExpireDateAlert.h"
#import "SRMonthPicker.h"

@interface BRNExpireDateAlert () {
    
    NSDate * _date;
}

@property (weak, nonatomic) IBOutlet SRMonthPicker *expirePicker;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation BRNExpireDateAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_date) {
        
        [_expirePicker setDate:_date];
    }
    
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    _expirePicker.minimumYear = dateComponents.year;
    _expirePicker.maximumYear = dateComponents.year + 30;
    _expirePicker.yearFirst = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
    [_backgroundView addGestureRecognizer:tapRecognizer];
    
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)backgroundViewTapped:(UIGestureRecognizer *)sender {
    
    [self cancelClicked:sender];
}


- (void)setDate:(NSDate *)date
{
    _date = date;
}

- (IBAction)okClicked:(id)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(onDatePicker:)]) {
        
        [_delegate onDatePicker:_expirePicker.date];
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

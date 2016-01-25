//
//  BRNTakeBreakController.m
//  BeerRightNow
//
//  Created by dukce pak on 5/28/15.
//  Copyright (c) 2015 jon. All rights reserved.
//

#import "BRNTakeBreakController.h"
#import "AppDelegate.h"

@interface BRNTakeBreakController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation BRNTakeBreakController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

//#define TAKE_URL @"http://www.iwantbeerrightnow.com/blog"
#define TAKE_URL @"https://www.iwantbeerrightnow.com/blog/"


-(void)initUI
{
    [self initializeLeftButtonItem];
    
    _webView.delegate = self;
    NSString *htmlString = ((AppDelegate *)[UIApplication sharedApplication].delegate).takeBreak;
    
    if (htmlString) {
        [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:TAKE_URL]];
    }
    else{
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:TAKE_URL]]];
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

#pragma mark UIWebView Delegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [HUD showUIBlockingIndicator];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [HUD hideUIBlockingIndicator];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [HUD hideUIBlockingIndicator];
}

@end

//
//  DetailWebViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "DetailWebViewController.h"

@interface DetailWebViewController ()

@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webString]]];
}
@end

//
//  WHSixWebViewDetailController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHSixWebViewDetailController.h"

@interface WHSixWebViewDetailController ()<UIWebViewDelegate>

@end

@implementation WHSixWebViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlString]]];
    web.delegate = self;
    [self.view addSubview:web];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByTagName('iframe')[0].style.display = 'none'"];
}

@end

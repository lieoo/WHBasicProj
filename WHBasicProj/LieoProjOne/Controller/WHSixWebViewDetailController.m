//
//  WHSixWebViewDetailController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHSixWebViewDetailController.h"

@interface WHSixWebViewDetailController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,copy)NSString *dataString;
@end

@implementation WHSixWebViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
   self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if (!_isHTMLString) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlString]]];
    }else{
        [self.webView loadHTMLString:_webUrlString baseURL:nil];
    }
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    if (self.isThree){
        [self UrlDataString];
    }
}


- (void)UrlDataString{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:@"http://app.lh888888.com/Api/Whole/three"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *htm5String = dicJson[@"data"];
            htm5String  = [htm5String stringByReplacingOccurrencesOfString:@"www.89888999.com" withString:@""];
            [self.webView loadHTMLString:htm5String baseURL:nil];
            hud.label.text = @"加载成功";
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            hud.label.text = @"加载失败,请稍候再试";
            [hud hideAnimated:YES afterDelay:1.5];
            [self popoverPresentationController];
        }
    }];
    [dataTask resume];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByTagName('iframe')[0].style.display = 'none'"];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.location.href = document.documentElement.getElementsByClassName('body')[0].getElementsByClassName('top')[0].style.display = 'none';"]];
}

@end

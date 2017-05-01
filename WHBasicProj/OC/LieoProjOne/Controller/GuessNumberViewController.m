//
//  GuessNumberViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "GuessNumberViewController.h"

@interface GuessNumberViewController ()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,copy)NSString *string;
@property (nonatomic,assign)BOOL isclickShare;

@end

@implementation GuessNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequst];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    
    self.view.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(DEVICEWIDTH/2-50, 100, 100, 40)];
    [button setTitle:@"开始分析" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    [button addTarget:self action:@selector(sendRequst) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 170, DEVICEWIDTH - 32, 200)];
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.nameLabel];
}
-(void)clickEvent{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    [hud hideAnimated:YES afterDelay:2];
    [self performSelector:@selector(notInstallQQ) withObject:nil afterDelay:2];
    self.isclickShare = YES;
    [self sendRequst];
    
}
- (void)notInstallQQ{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"您没有安装任何可分享的平台软件" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)sendRequst{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    if (!self.isclickShare) {
    hud.label.text = @"分享一下 运气更好哦！";
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:@"http://app.lh888888.com/award/specail_number.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dicJson);
            self.nameLabel.text = dicJson[@"content"][@"title"];
            if (self.isclickShare) {
                self.nameLabel.text = [self.nameLabel.text stringByAppendingString:dicJson[@"content"][@"post_content"]];
            }
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
@end

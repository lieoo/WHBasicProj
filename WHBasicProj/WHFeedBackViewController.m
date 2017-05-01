//
//  WHFeedBackViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/29.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHFeedBackViewController.h"

@interface WHFeedBackViewController ()<UITextViewDelegate>
@property (nonatomic, strong ) UITextView *textf;
@property (nonatomic, strong ) UITextView *infosf;


@end

@implementation WHFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(236, 236, 236);

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 70, DEVICEWIDTH-32, 30)];
    label.text = @"您的意见和需求，是我们进步的动力";
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 10;
    [self.view addSubview:label];
    
    self.textf = [[UITextView alloc]initWithFrame:CGRectMake(16, 100, DEVICEWIDTH - 32, 30)];
    self.textf.layer.cornerRadius = 10;
    self.textf.delegate = self;
    self.textf.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textf];      
    
    
    self.infosf = [[UITextView alloc]initWithFrame:CGRectMake(16, 150, DEVICEWIDTH - 32, 300)];
//    self.infosf.placeholder = @"您的意见或者手机APP使用过程中出现的错误";
    self.infosf.font = [UIFont systemFontOfSize:12];
    self.infosf.backgroundColor = [UIColor whiteColor];
    self.infosf.layer.cornerRadius = 10;
    self.infosf.delegate = self;
    [self.view addSubview:self.infosf];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    confirmBtn.frame = CGRectMake(16, 490, DEVICEWIDTH-32, 30);
    confirmBtn.backgroundColor = RGB(202, 79, 65);
    confirmBtn.layer.cornerRadius = 10;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];

}
- (void)sendRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:@"http://app.lh888888.com/Award/api/nav/type_id/1.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            hud.label.text = @"提交成功";
            [hud hideAnimated:YES afterDelay:1.5];
            self.infosf.text = @"";
            self.textf.text = @"";
        }else{
            hud.label.text = @"提交失败,请稍候再试";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
    [dataTask resume];
}
- (void)btnClick{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hideAnimated:YES afterDelay:2];
    [self sendRequest];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.textf) {
        if(textView.text.length == 0){
            textView.text = @"请输入手机号";
            textView.textColor = [UIColor grayColor];
        }
    }
    if (textView == self.infosf) {
        if(textView.text.length == 1){
            textView.text = @"请输入内容";
            textView.textColor = [UIColor grayColor];
        }
    }
   
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入内容"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
@end

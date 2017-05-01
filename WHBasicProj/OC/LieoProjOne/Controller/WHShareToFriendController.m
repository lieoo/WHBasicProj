//
//  WHShareToFriendController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/29.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHShareToFriendController.h"
#import "HMScannerController.h"
#import <MessageUI/MessageUI.h>
@interface WHShareToFriendController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation WHShareToFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
    NSString *cardName = @"https://vipwanhaohui.com/";
    UIImage *avatar = [UIImage imageNamed:@""];
    
    [HMScannerController cardImageWithCardName:cardName avatar:avatar scale:0.2 completion:^(UIImage *image) {

        UIImageView* Vimage = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICEWIDTH/2-100, 150, 200, 200)];
        [Vimage setImage:image];
        [self.view addSubview:Vimage];
    }];
    
    UILabel *infosLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEVICEWIDTH/2-100, 350, DEVICEWIDTH - 100, 40)];
    infosLabel.font = [UIFont systemFontOfSize:12];
    infosLabel.text = @"您可以扫描二维码或者分享下载应用";
    [self.view addSubview:infosLabel];
    
    NSArray *imgArray = @[@"share_platform_wechat",@"share_platform_wechattimeline",@"share_platform_imessage",@"share_platform_qqfriends"];
    NSArray *labelArray = @[@"微信好友",@"朋友圈",@"短信",@"QQ"];
    for (NSInteger i = 0; i<4; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake(DEVICEWIDTH/4*i+25, 450, 40, 40);
        button.tag = i;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArray[i]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(DEVICEWIDTH/4*i+20, 500, 50, 20);
        label.text = [NSString stringWithFormat:@"%@",labelArray[i]];
        [self.view addSubview:label];
    }
}
- (void)share:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    if (sender.tag == 2) {
        [self showMessageView:nil title:@"" body:@"我在这里看资讯喔!快来！"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您没有安装有效客户端" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
    }
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

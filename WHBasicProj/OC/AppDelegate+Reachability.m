//
//  AppDelegate+Reachability.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "AppDelegate+Reachability.h"
#import "WHTabBarController.h"

@interface AppDelegate()
    
//    UIAlertController *_alertCon;

@end

@implementation AppDelegate (Reachability)
+(void)reachabilityWithContrller:(AppDelegate *)currentDelegate{
    // 监听网络状况
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
//                [self noNetWork];
                //                [KVNProgress showErrorWithStatus:@"请开启允许蜂窝网络使用"];
                [[NSNotificationCenter defaultCenter]postNotificationName:WHNONETWORKNOTICESTRING object:nil];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi环境已经连接");
                [[NSNotificationCenter defaultCenter]postNotificationName:WHWIFINETWORKIONLINENOTICESTRING object:nil];
//                if (![[self getCurrentVC] isKindOfClass:[WHTabBarController class]]) {
////                    [self addRootViewController];
//                }else
//                {   [_alertCon dismissViewControllerAnimated:YES completion:^{
//
//                }];
//                    [KVNProgress showSuccessWithStatus:@"wifi环境已经连接"];

//                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [[NSNotificationCenter defaultCenter]postNotificationName:WHCELLUARNETWORKONLINENOTICESTRING object:nil];
                
//                if (![[self getCurrentVC] isKindOfClass:[webViewTabBarController class]]) {
//                    [self addRootViewController];
//                }else
//                {
//                    [_alertCon dismissViewControllerAnimated:YES completion:^{
//                        
//                    }];
//                    [KVNProgress showSuccessWithStatus:@"手机网络已经连接"];
//                }
                break;
            default:
                break;
        }
    }];
    [mgr startMonitoring];

}

//- (void)noNetWork{
//    _alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络失去连接" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *exit = [UIAlertAction actionWithTitle:@"点击退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //退出程序
//        [self exitApp];
//    }];
//    
//    UIAlertAction *canle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [_alertCon addAction:exit];
//    [_alertCon addAction:canle];
//    
//    [self.window.rootViewController presentViewController:_alertCon animated:YES completion:nil];
//}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end

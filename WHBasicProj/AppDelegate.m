//
//  AppDelegate.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMengMessage.h"
#import "AppDelegate+Reachability.h"
#import "AppDelegate+UMengMobClick.h"
#import "WHTabBarController.h"
#import "WHNewsViewController.h"
#import "PXGetDataTool.h"
#import "webViewTabBarController.h"

@interface AppDelegate ()

@property (nonatomic,strong) ScottAlertViewController *alertCon;

@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noNetWork) name:WHNONETWORKNOTICESTRING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wifiOnline) name:WHWIFINETWORKIONLINENOTICESTRING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(celluarNetOnline) name:WHCELLUARNETWORKONLINENOTICESTRING object:nil];
    
    [AppDelegate reachabilityWithContrller:self];
    [AppDelegate addUmengMessage:launchOptions WithDelegate:self];
    [AppDelegate addUMMobClick]; //统计
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    return YES;
}

#pragma mark --- 网络状态
- (void)noNetWork{
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"网络断开连接" message:@"请检查网络或者蜂窝网络使用权限"];
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"点击退出" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        [self exitApp];
    }]];
    
    _alertCon = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    _alertCon.tapBackgroundDismissEnable = YES;
    [self.window.rootViewController presentViewController:_alertCon animated:YES completion:nil];

}
-(void)wifiOnline{
    [self canOnlineWithType:@"wifi环境已经连接"];
}
-(void)celluarNetOnline{
    [self canOnlineWithType:@"蜂窝数据环境已经连接"];
}
-(void)canOnlineWithType:(NSString *)typeString{
    [_alertCon dismissViewControllerAnimated:YES];
    if (![[self getCurrentVC] isKindOfClass:[WHTabBarController class]]) {
        [self addRootViewController];
    }else{
        [_alertCon dismissViewControllerAnimated:YES completion:nil];
        [KVNProgress showSuccessWithStatus:typeString];
    }
}
-(void)addRootViewController{
    
    WKProgressHUD *hud = [WKProgressHUD showInView:[UIApplication sharedApplication].keyWindow withText:@"等待加载" animated:YES];

    [PXGetDataTool X_POST:COMPANYURL parameters:COMPANYPARA success:^(id responseObject) {
        if (responseObject == NULL) {
            WHTabBarController *vc = [[WHTabBarController alloc]init];
            self.window.rootViewController = vc;
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:@"responseObject"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            webViewTabBarController *web = [[webViewTabBarController alloc] init];
            [[UIApplication sharedApplication].delegate window].rootViewController = web;
        }
        [hud dismiss:YES];
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)exitApp{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
//     [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:[UIApplication sharedApplication].keyWindow cache:NO];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

#pragma mark -获取当前显示的界面
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
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

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

@end

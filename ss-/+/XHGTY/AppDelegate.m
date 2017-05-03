//
//  AppDelegate.m
//  XHGTY
//
//  Created by 杨健 on 2016/11/15.
//  Copyright © 2016年 杨健. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "ThirdSDKDefine.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WebViewController.h"
#import "WXApi.h"
#import "HttpTools.h"
#import "UMessage.h"
#import "SVProgressHUD.h"

// 引入JPush功能所需头文件
#import "AppModel.h"
#import "JPUSHService.h"


#import "DHGuidePageHUD.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MytabBarViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ScottAlertController.h"
#import "KVNProgress.h"
#import "PXGetDataTool.h"
#import "webViewTabBarController.h"
#import "WKProgressHUD.h"
#import <KVNProgress/KVNProgress.h>

#import "AppDelegate+UMengMessage.h"
#import "AppDelegate+Reachability.h"
#import "AppDelegate+UMengMobClick.h"

#import "HomeViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


//static NSString *appKey = @"dcd205f49eadbac179b60c1e";
//static NSString *channel = @"App Store";

#define COMPANYURL @"http://169.56.130.9/index/index/"
#define COMPANYPARA @{@"app_id":@"1232596884"}

@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic,strong)UIStoryboard *story;
@property (nonatomic,strong) ScottAlertViewController *alertCon;


@end

@implementation AppDelegate


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

//    if (![[self getCurrentVC] isKindOfClass:[MytabBarViewController class]]) {
//        [self addRootViewController];
//    }else{
        [_alertCon dismissViewControllerAnimated:YES completion:nil];
        [KVNProgress showSuccessWithStatus:typeString];
//    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addRootViewController];
    });
}

-(void)addRootViewController{
    
    WKProgressHUD *hud = [WKProgressHUD showInView:[UIApplication sharedApplication].keyWindow withText:@"等待加载" animated:YES];
    
    [PXGetDataTool X_POST:COMPANYURL parameters:COMPANYPARA success:^(id responseObject) {
        if (responseObject == nil) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Other" bundle:[NSBundle mainBundle]];
            MytabBarViewController *nvc = [story instantiateViewControllerWithIdentifier:@"tabbarViewController"];
            self.window.rootViewController = nvc;
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

-(void)savadata{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]stringByAppendingFormat:@"/Caches"];
    NSString * file = [NSString stringWithFormat:@"%@/userAccount.shouchang",path];
    if(![NSArray arrayWithContentsOfFile:file]){
    NSArray * arrary = @[@{@"time":@"2017-04-05",@"haoma":@[@"03",@"04",@"10",@"15",@"21",@"31",@"07"],@"qishu":@"2017041",@"kjtime":@"04-02 21:30"}];
      [arrary writeToFile:file atomically:YES];
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenSt = [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenSt:%@",deviceTokenSt);
}
/**
 *  广告点击事件 回调
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AMapServices sharedServices].apiKey = GDMapKey;
    [[UINavigationBar appearance] setBarTintColor:[[UIColor alloc] initWithRed:237/255.0 green:31/255.0 blue:65/255.0 alpha:1]];
//    [self shareSDKInterGration];
    
    application.statusBarHidden = NO;
    
    
    [[UITabBar appearance]setTintColor:[UIColor redColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSForegroundColorAttributeName:[UIFont systemFontOfSize:32]}];
    
    
    //   [self setXh];
    
    //    [UMessage startWithAppkey:UMKey launchOptions:launchOptions httpsEnable:YES ];
    //    [UMessage openDebugMode:YES];
    
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Other" bundle:[NSBundle mainBundle]];
//    MytabBarViewController *nvc = [story instantiateViewControllerWithIdentifier:@"tabbarViewController"];
//    self.window.rootViewController = nvc;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noNetWork) name:WHNONETWORKNOTICESTRING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wifiOnline) name:WHWIFINETWORKIONLINENOTICESTRING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(celluarNetOnline) name:WHCELLUARNETWORKONLINENOTICESTRING object:nil];
    
    [AppDelegate reachabilityWithContrller:self];
    [AppDelegate addUmengMessage:launchOptions WithDelegate:self];
    [AppDelegate addUMMobClick]; //统计
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
}
@end

//
//  AppDelegate+UMengMessage.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "AppDelegate+UMengMessage.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>


@end
@implementation AppDelegate (UMengMessage)

+(void)addUmengMessage:(NSDictionary*)launchOptions WithDelegate:(AppDelegate*)appDelegate{
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if(version.doubleValue < 10.0) {
        //初始化
        [UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
        //注册通知
        [UMessage registerForRemoteNotifications];
        //为通知添加按钮
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        
        [UMessage registerForRemoteNotifications:categories];
    } else {
        //初始化
        [UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
        //注册通知
        [UMessage registerForRemoteNotifications];
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //设置代理
        center.delegate=appDelegate;
        //授权
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                
            } else {
                //点击不允许
            }
        }];
        
        //为通知添加按钮
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }

}

@end


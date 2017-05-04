//
//  AppDelegate+UMengMobClick.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "AppDelegate+UMengMobClick.h"

@implementation AppDelegate (UMengMobClick)

+(void)addUMMobClick{
    [MobClick setLogEnabled:YES];
    
    UMConfigInstance.appKey = APPKEY;
    
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];
}

@end

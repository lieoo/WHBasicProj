//
//  WHProjHeaderPCH.h
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#ifndef WHProjHeaderPCH_h
#define WHProjHeaderPCH_h

#import "UMMobClick/MobClick.h"
#import "UMessage.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIView+WebCache.h>
#import <KVNProgress.h>
#import "ScottAlertController.h"
#import "WKProgressHUD.h"
#import "WHBasicViewController.h"


#define COMPANYURL @"http://169.56.130.9/index/index/"
#define COMPANYPARA @{@"app_id":@"1231918561"}
#define APPKEY @"5906d2e3b27b0a49b700152d"
#define SECRET @"hgi1grvyjmtdyme3ckfrynef5zfiynrj"
#define gameURL @""


#define DEVICEWIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICEHEIGHT [UIScreen mainScreen].bounds.size.height
#define RATIO_WIDHT320 [UIScreen mainScreen].bounds.size.width/320.0
#define RATIO_HEIGHT568 [UIScreen mainScreen].bounds.size.height/568.0

#define NAV_STATUS_HEIGHT 64
#define TABBAR_HEIGHT 49

//颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)
#define RGB3(v) RGB(v,v,v)
#define BASE_COLOR RGB(4, 175, 255)
#define randomColor RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define WHCELLUARNETWORKONLINENOTICESTRING @"WHCELLUARNETWORKONLINE"
#define WHWIFINETWORKIONLINENOTICESTRING @"WHWIFINETWORKIONLINE"
#define WHNONETWORKNOTICESTRING @"WHNONETWORK"

#endif /* WHProjHeaderPCH_h */

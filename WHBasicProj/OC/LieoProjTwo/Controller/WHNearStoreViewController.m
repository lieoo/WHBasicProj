//
//  WHNearStoreViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/5/1.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHNearStoreViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UIView+empty.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface WHNearStoreViewController ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UIView *notLocationView;

@end

@implementation WHNearStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLocationManager];
    [self startSerialLocation];
}

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)startSerialLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    //定位错误
    NSLog(@"定位错误 %s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"定位失败，请开启定位";
    [hud hideAnimated:YES afterDelay:1.5];
    [self setUpNotLocationView];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    [self.notLocationView removeFromSuperview];
    CGFloat lat = location.coordinate.latitude;
    CGFloat lon = location.coordinate.longitude;
    if (lat && lon) {
        [self.locationManager stopUpdatingLocation];
    }
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

-(void)setUpNotLocationView {
    [self.view addEmptyView:@{@"imageUrl":@"empty-icon",@"title":@"暂时查询不到轨迹信息"}];
}
- (void)tapNotLocationView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud bringSubviewToFront:self.view];
    [hud hideAnimated:YES afterDelay:1.5];
    [self.view removeEmptyView];
}
@end

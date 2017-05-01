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

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface WHNearStoreViewController ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation WHNearStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLocationManager];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}


@end

//
//  WHTabBarController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHTabBarController.h"

@interface WHTabBarController ()

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@end

@implementation WHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"WHNewsViewController",
                                   kTitleKey  : @"资讯",
                                   kImgKey    : @"TabMessageIcon",
                                   kSelImgKey : @"TabMessageIcon"},
                                 
                                 @{kClassKey  : @"WHProFileViewController",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"profile-group-icon",
                                   kSelImgKey : @"profile-group-icon"}
                                 ];
    
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [UIImage imageNamed:dict[kSelImgKey]];
        
        [self addChildViewController:nav];
    }];
}

@end

//
//  WHTabBarController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHTabBarController.h"
#import "BasicNavController.h"

@interface WHTabBarController ()

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@end
@interface WHTabBarController ()

@property (nonatomic, strong) NSArray *childItemsArray;


@end
@implementation WHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //项目统一使用一个资源，仅需要在此判断进入第几个App即可
    
    NSString *whichProj = @"one";
    
    
    if ([whichProj isEqualToString:@"one"]) {
        self.childItemsArray = @[
                                     @{kClassKey  : @"WHNewsViewController",
                                       kTitleKey  : @"资讯",
                                       kImgKey    : @"tab1_1",
                                       kSelImgKey : @"tab1_2"},
                                     
                                     @{kClassKey  : @"WHProFileViewController",
                                       kTitleKey  : @"个人中心",
                                       kImgKey    : @"tab2_1",
                                       kSelImgKey : @"tab2_2"},
                                     
                                     @{kClassKey  : @"WHShareToFriendController",
                                       kTitleKey  : @"分享给好友",
                                       kImgKey    : @"tab3_1",
                                       kSelImgKey : @"tab3_2"},
                                     
                                     @{kClassKey  : @"WHMoreFuncViewController",
                                       kTitleKey  : @"更多",
                                       kImgKey    : @"tab4_1",
                                       kSelImgKey : @"tab4_2"}
                                     ];

    }else if ([whichProj isEqualToString:@"two"]){
        self.childItemsArray = @[
                                 @{kClassKey  : @"WHNewsViewController",
                                   kTitleKey  : @"资讯",
                                   kImgKey    : @"tab1_1",
                                   kSelImgKey : @"tab1_2"},
                                 
                                 @{kClassKey  : @"WHProFileViewController",
                                   kTitleKey  : @"个人中心",
                                   kImgKey    : @"tab2_1",
                                   kSelImgKey : @"tab2_2"},
                                 ];
    }
    
    
    [self.childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        WHBasicViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [UIImage imageNamed:dict[kSelImgKey]];
        
        [self addChildViewController:nav];
    }];
}

-(BOOL)shouldAutorotate{
    return NO;
}
//支持的方向 因为界面A我们只需要支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

//
//  BasicNavController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/29.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "BasicNavController.h"

@interface BasicNavController ()

@end

@implementation BasicNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortraitUpsideDown];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice]performSelector:@selector(setOrientation:)
                                      withObject:(id)@(UIInterfaceOrientationPortraitUpsideDown)];
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)shouldAutorotate{
//    if ([self.topViewController isKindOfClass:[SSPushRotateVC class]]) {
        return [self.topViewController shouldAutorotate];
//    }
//    return NO; // RotateAblePushController自动旋转交给改控制器自己控制，其他控制器则不支撑自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    if ([self.topViewController isKindOfClass:[SSPushRotateVC class]]) {
//        return [self.topViewController supportedInterfaceOrientations];
//    } else {
        return UIInterfaceOrientationMaskPortrait; // RotateAblePushController所支持旋转交给改控制器自己处理，其他控制器则只支持竖屏
//    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return  UIInterfaceOrientationPortrait;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

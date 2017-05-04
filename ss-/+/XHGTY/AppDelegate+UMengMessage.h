//
//  AppDelegate+UMengMessage.h
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UMengMessage)

+(void)addUmengMessage:(NSDictionary*)launchOptions WithDelegate:(AppDelegate *)appDelegate;
@end

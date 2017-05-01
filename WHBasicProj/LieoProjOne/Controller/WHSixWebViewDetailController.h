//
//  WHSixWebViewDetailController.h
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHSixWebViewDetailController : UIViewController
@property (nonatomic,copy)NSString *webUrlString;
@property (nonatomic,assign)BOOL isThree;//三期内必出 需要请求Url 需要单独判断
@property (nonatomic,assign)BOOL isHTMLString;
@end

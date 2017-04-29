//
//  LotteryZoneViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "LotteryZoneViewController.h"
#import "LotteryZoneDataModel.h"
#import <MJExtension/MJExtension.h>
#import "LotteryZoneDetailViewController.h"

@interface LotteryZoneViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)LotteryZoneDataModel *model;

@end

@implementation LotteryZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNetRequest];
    
}
-(void)setUpNetRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:@"http://app.lh888888.com/Award/Api/lottery.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
               NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            LotteryZoneDataModel *model = [LotteryZoneDataModel mj_objectWithKeyValues:dicJson];
            _dataArray = model.content;
            hud.label.text = @"加载成功";
            [hud hideAnimated:YES afterDelay:1.5];
            [self setUpUI];
            
        }else{
            hud.label.text = @"加载失败,请稍候再试";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
    [dataTask resume];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)setUpUI{
    int totalColumns = 3;
    CGFloat cellW = DEVICEWIDTH/3-8;
    CGFloat cellH = 40;
    CGFloat margin =(self.view.frame.size.width - totalColumns * cellW) / (totalColumns + 1);
    
    CGFloat deviceY = 70;
    
    for(int index = 0; index < 13; index++) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        [button setBackgroundImage:[UIImage imageNamed:@"bbtnback~iphone"] forState:UIControlStateNormal];
        button.imageView.contentMode = UIImageResizingModeTile;
        [button setTitle:_dataArray[index][@"alias"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin+20);
        button.frame = CGRectMake(cellX, cellY+deviceY, cellW, cellH);
        button.alpha = 0;
        [self.view addSubview:button];
        [UIView animateWithDuration:1 animations:^{
            button.alpha = 1;
        }];
    }

}
-(void)touchButton:(UIButton *)sender{
    NSString *requestUrl = _dataArray[sender.tag][@"api_url"];
    LotteryZoneDetailViewController *lottery = [[LotteryZoneDetailViewController alloc]init];
    lottery.requestURL = requestUrl;
    [self.navigationController pushViewController:lottery animated:YES];
}
-(NSMutableArray *)dataArray{
    if (_dataArray) return _dataArray;
    NSMutableArray *dataArray = [NSMutableArray array];
    _dataArray = dataArray;
    return _dataArray;
}
@end

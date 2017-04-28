//
//  WHSixNewsController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHSixNewsController.h"
#import "WHDataSixDetailModel.h"
#import <MJExtension/MJExtension.h>
#import "WHSixWebViewDetailController.h"
@interface WHSixNewsController ()
@property (nonatomic,strong)WHDataSixDetailModel *model;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation WHSixNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpNetRequest];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    self.title = @"资料大全";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)setUpNetRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:@"http://app.lh888888.com/Api/Whole/Menu_List"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            self.model = [WHDataSixDetailModel mj_objectWithKeyValues:responseObject];
            self.dataSource = self.model.data;
//            _dataSource = [WHDataSixDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self setUpHomePage];
            NSLog(@"%lu",(unsigned long)_dataSource.count);
            hud.label.text = @"加载成功";
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            hud.label.text = @"加载失败,请稍候再试";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
    [dataTask resume];
}
- (void)setUpHomePage{
    
    int totalColumns = 3;
    CGFloat cellW = DEVICEWIDTH/3-2;
    CGFloat cellH = cellW;
    CGFloat margin =(self.view.frame.size.width - totalColumns * cellW) / (totalColumns + 1);
    
    CGFloat deviceY = 65;
    UIView *buttonBGView = [[UIView alloc]initWithFrame:CGRectMake(0, margin+deviceY-2, DEVICEWIDTH, cellH *3+5)];
    buttonBGView.backgroundColor = [UIColor grayColor];
    buttonBGView.alpha = 0.3;
    [self.view addSubview:buttonBGView];
    
    for(int index = 0; index < _dataSource.count; index++) {
        UILabel *nameLabel = [[UILabel alloc]init];
        UILabel *label = [[UILabel alloc]init];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
        nameLabel.tag = index;
        nameLabel.text = _dataSource[index][@"name"];
        nameLabel.font = [UIFont systemFontOfSize:45];
        nameLabel.textColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
        nameLabel.backgroundColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.userInteractionEnabled = YES;
        [nameLabel addGestureRecognizer:gest];
        label.text = _dataSource[index][@"content"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin);
        nameLabel.frame = CGRectMake(cellX, cellY+deviceY, cellW, cellH);
        label.frame = CGRectMake(cellX, CGRectGetMinY(nameLabel.frame)+CGRectGetHeight(nameLabel.frame)-30, cellW, 20);
        label.alpha = 0;
        nameLabel.alpha = 0;
        [self.view addSubview:nameLabel];
        [self.view addSubview:label];
        [UIView animateWithDuration:1 animations:^{
            nameLabel.alpha = 1;
            label.alpha = 1;
        }];
    }
}

- (void)touchLabel:(UITapGestureRecognizer *)gest{
    UILabel *label = (UILabel *)gest.view;
    NSInteger tag = label.tag;
    NSString *string =  _dataSource[tag][@"url"];
    WHSixWebViewDetailController *web = [[WHSixWebViewDetailController alloc]init];
    web.webUrlString = string;
    web.title = _dataSource[tag][@"content"];
    [self.navigationController pushViewController:web animated:YES];
}

-(NSMutableArray *)dataSource{
    if (_dataSource) return _dataSource;
    NSMutableArray *dataSource = [NSMutableArray array];
    _dataSource = dataSource;
    return _dataSource;
}
@end

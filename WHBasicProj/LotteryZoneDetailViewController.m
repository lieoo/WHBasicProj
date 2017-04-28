//
//  LotteryZoneDetailViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "LotteryZoneDetailViewController.h"
#import "LotteryZoneDetailTableViewCell.h"
@interface LotteryZoneDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LotteryZoneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNetRequest];
    
    [self.view addSubview:self.tableView];
}

-(void)setUpNetRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:self.requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            _dataSource = dicJson[@"data"];
            hud.label.text = @"加载成功";
            [hud hideAnimated:YES afterDelay:1.5];
            [self.tableView reloadData];
        }else{
            hud.label.text = @"加载失败,请稍候再试";
            [hud hideAnimated:YES afterDelay:1.5];
            [self popoverPresentationController];
        }
    }];
    [dataTask resume];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LotteryZoneDetailTableViewCell *cell = [[LotteryZoneDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.expectLabel.text = [NSString stringWithFormat:@"第%@期",_dataSource[indexPath.row][@"expect"]];
    cell.opencode.text = _dataSource[indexPath.row][@"opencode"];
    cell.opentime.text = [NSString stringWithFormat:@"开奖时间:%@",_dataSource[indexPath.row][@"opentime"]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableView *)tableView{
    if (_tableView) return _tableView;
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DEVICEWIDTH, DEVICEHEIGHT - 64) style:UITableViewStylePlain];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    table.tableFooterView = [[UIView alloc]init];
    table.delegate = self;
    table.dataSource = self;
    _tableView = table;
    return _tableView;
}
@end

//
//  WHNoDataTableViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/29.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHNoDataTableViewController.h"

@interface WHNoDataTableViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation WHNoDataTableViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = RGB(236, 236, 236);
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    [hud hideAnimated:YES afterDelay:2];
    [self performSelector:@selector(loadNoDataTableView) withObject:nil afterDelay:2];
}
- (void)loadNoDataTableView{
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

-(UITableView *)tableView{
    if (_tableView) return _tableView;
    UITableView *table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    table.tableFooterView = [UIView new];
    table.tableHeaderView = [self headerView];
    table.dataSource = self;
    table.delegate = self;
    _tableView = table;
    return _tableView;
}
-(UIView *)headerView{
    UIView *headerView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    headerView.backgroundColor = RGB3(226);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICEWIDTH/2-50, DEVICEHEIGHT/2-50, 100, 100)];
    [imageV setImage:[UIImage imageNamed:@"no_data"]];
    [headerView addSubview:imageV];
    return headerView;
}

@end

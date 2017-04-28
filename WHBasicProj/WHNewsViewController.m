//
//  WHNewsViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHNewsViewController.h"
#import <SDCycleScrollView.h>
#import "TXScrollLabelView.h"
#import "DetailWebViewController.h"
#import "PMElasticRefresh.h"
#import <MJExtension/MJExtension.h>
#import "WHDataModel.h"
#import "WHSixNewsController.h"

@interface WHNewsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSArray *imgArray;
@property (nonatomic,strong)NSArray *slideBannerArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)TXScrollLabelView *scrollLabelView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)WHDataModel *model;

@end

@implementation WHNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    [self.view addSubview:self.tableView];
    
//    [self.view addSubview:self.scrollLabelView];
    [self.view addSubview:self.cycleScrollView];
    
    [self setUpNetRequest];
    
//    [self setUpBanner];
    
   }
-(void)touchButton:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 0) {
        [self.navigationController pushViewController:[WHSixNewsController new] animated:YES];
    }else if (sender.tag == 1){
        
    }else if (sender.tag == 2){
        
    }else if (sender.tag == 3){
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)setUpNetRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"http://app.lh888888.com/Award/api/nav/type_id/1.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            self.model = [WHDataModel mj_objectWithKeyValues:responseObject];
            _dataSource = self.model.content;
            [self setUpHomePage];
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
    
    CGFloat deviceY;
    if (DEVICEWIDTH == 320) {
        deviceY = 200;
    }else{
        deviceY = 240;
    }
    UIView *buttonBGView = [[UIView alloc]initWithFrame:CGRectMake(0, margin+deviceY-2, DEVICEWIDTH, cellH *3+1)];
    buttonBGView.backgroundColor = [UIColor grayColor];
    buttonBGView.alpha = 0.3;
    [self.view addSubview:buttonBGView];
    
    for(int index = 0; index < _dataSource.count; index++) {
        NSString *imageName = _dataSource[index][@"label"];
        UIButton *button = [[UIButton alloc]init];
        UILabel *label = [[UILabel alloc]init];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        label.text = _dataSource[index][@"label"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin);
        button.frame = CGRectMake(cellX, cellY+deviceY, cellW, cellH);
        label.frame = CGRectMake(cellX, CGRectGetMinY(button.frame)+CGRectGetHeight(button.frame)-20, cellW, 20);
        label.alpha = 0;
        button.alpha = 0;
        [self.view addSubview:button];
        [self.view addSubview:label];
        [UIView animateWithDuration:1 animations:^{
            button.alpha = 1;
            label.alpha = 1;
        }];
    }
}
-(TXScrollLabelView *)scrollLabelView{
    if (_scrollLabelView ) return _scrollLabelView;
    NSString *scrollTitle = @"周四302比赛推迟\n广西快3停售\n大乐透5亿加奖活动\n关于增加“鲁11选5”销售开奖期次公告";
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:TXScrollLabelViewTypeFlipNoRepeat velocity:TXScrollLabelViewTypeUpDown options:UIViewAnimationOptionCurveEaseInOut];
    scrollLabelView.scrollVelocity = 3;
    scrollLabelView.scrollTitleColor = [UIColor blackColor];
    scrollLabelView.backgroundColor = [UIColor whiteColor];
    CGFloat bannerY;
    if (DEVICEWIDTH == 320) {
        bannerY = 165;
    }else{
        bannerY = 205;
    }
    scrollLabelView.frame = CGRectMake(0, bannerY, DEVICEWIDTH, 30);
    [scrollLabelView beginScrolling];
    _scrollLabelView = scrollLabelView;
    return _scrollLabelView;
}
- (SDCycleScrollView*)cycleScrollView{
    if (_cycleScrollView) return _cycleScrollView;
    CGFloat cycleH;
    if (DEVICEWIDTH == 320) {
        cycleH = 190;
    }else{
        cycleH = 247;
    }
//    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH,cycleH)];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DEVICEWIDTH, cycleH) imageURLStringsGroup:self.imgArray];
    cycleScrollView.autoScrollTimeInterval = 2.5;
    cycleScrollView.delegate = self;
//    cycleScrollView.dotColor = [UIColor blueColor];
    cycleScrollView.showPageControl = NO;
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = cycleScrollView;
    return _cycleScrollView;
}
//
//-(UIView *)headerView{
//    if (_headerView) return _headerView;
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 240)];
//    [view addSubview:self.cycleScrollView];
//    [view addSubview:self.scrollLabelView];
//    _headerView = view;
//    return _headerView;
//}

#pragma mark --- DataSource && Delegeta

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSource.count;
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    DetailWebViewController *web = [[DetailWebViewController alloc]init];
    web.webString = self.slideBannerArray[index];
    [self.navigationController pushViewController:web animated:YES];
}
-(void)setUpBanner{
    CGFloat cycleH;
    if (DEVICEWIDTH == 320) {
         cycleH = 140;
    }else{
        cycleH = 200;
    }
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DEVICEWIDTH, cycleH) imageURLStringsGroup:self.imgArray];
    self.cycleScrollView.delegate = self;
    self.tableView.tableHeaderView = self.headerView;
}

//-(UITableView *)tableView{
//    if (_tableView) return _tableView;
//    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.tableFooterView = [[UIView alloc]init];
//    [tableView pm_RefreshHeaderWithBlock:^{
//        [self performSelector:@selector(endRefresh) withObject:nil afterDelay:2.5];
//    }];
//    _tableView = tableView;
//    return _tableView;
//}
-(void)endRefresh{
    [_tableView endRefresh];
}
-(NSArray *)imgArray{
    if (_imgArray) return _imgArray;
    NSArray *array = @[@"https://clientimages.letoula.com/banner/20170419164213396.png",
                       @"https://clientimages.letoula.com/banner/20170426150909435.png",
                       @"https://clientimages.letoula.com/banner/20170426103234548.png",
                       @"https://clientimages.letoula.com/banner/20170330195829988.png"];
    _imgArray = array;
    return _imgArray;
}

-(NSArray *)slideBannerArray{
    if (_slideBannerArray) return _slideBannerArray;
    NSArray *array = @[@"https://m.letoula.com/promotion/201704/dlt_addprize.html",
                      @"https://m.letoula.com/promotion/201704/autozh.html",
                      @"https://m.letoula.com/promotion/201704/autozh.html",
                      @"https://m.letoula.com/promotion/201704/autozh.html"];
    _slideBannerArray = array;
    return _slideBannerArray;
}
-(NSMutableArray *)dataSource{
    if (_dataSource) return _dataSource;
    NSMutableArray *dataSource = [NSMutableArray array];
    _dataSource = dataSource;
    return _dataSource;
}


@end

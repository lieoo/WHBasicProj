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
#import "GuessNumberViewController.h"
#import "WHSixWebViewDetailController.h"
#import "LotteryZoneViewController.h"
#import "DHGuidePageHUD.h"

@interface WHNewsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSArray *imgArray;
@property (nonatomic,strong)NSArray *slideBannerArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)TXScrollLabelView *scrollLabelView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)WHDataModel *model;
@property (nonatomic,strong)UIButton *centerButton;
@end

@implementation WHNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.scrollLabelView];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
    [self.view addSubview:self.cycleScrollView];
    [self.view addSubview:self.centerButton];
    [self setUpNetRequest];
    [self setUpNavButton];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        [self setStaticGuidePage];
//    }
}


- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"01",@"02",@"03",@"04"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:YES];
    guidePage.slideInto = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:guidePage];
}


-(void)touchButton:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 0) {
        [self.navigationController pushViewController:[WHSixNewsController new] animated:YES];
    }else if (sender.tag == 1){
        WHSixWebViewDetailController *web = [[WHSixWebViewDetailController alloc]init];
        web.title = @"三期内必出";
        web.isThree = YES;
        [self.navigationController pushViewController:web animated:YES];
    }else if (sender.tag == 2){
        WHSixWebViewDetailController *web = [[WHSixWebViewDetailController alloc]init];
        web.title = @"开奖记录查询";
        web.isHTMLString = YES;
        NSURL *url = [NSURL URLWithString:@"http://app.lhst6.com/ziliao/chaxun.php"];
        web.webUrlString = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self.navigationController pushViewController:web animated:YES];
    }else if (sender.tag == 3){
        DetailWebViewController *web = [[DetailWebViewController alloc]init];
        web.webString = @"https://api.1396six.com/mobile/Voteinfoweb/27558";
        web.title = @"生肖投票";
        [self.navigationController pushViewController:web animated:YES];
    }else if (sender.tag == 4){
        GuessNumberViewController *g = [[GuessNumberViewController alloc]init];
        [self.navigationController pushViewController:g animated:YES];
    }else if (sender.tag == 5){
        WHSixWebViewDetailController *web = [[WHSixWebViewDetailController alloc]init];
        web.webUrlString = @"http://app.lhst6.com/kaijiangzhibo/";
        web.title = @"开奖资料";
        [self.navigationController pushViewController:web animated:YES];
    }else if (sender.tag == 6){
        LotteryZoneViewController *lo = [[LotteryZoneViewController alloc]init];
        lo.title = @"彩票开奖专区";
        [self.navigationController pushViewController:lo animated:YES];
    }else if (sender.tag == 7){
        DetailWebViewController *web = [[DetailWebViewController alloc]init];
        web.webString = @"https://api.1396six.com/mobile/Voteinfoweb/27560";
        web.title = @"波色预测";
        [self.navigationController pushViewController:web animated:YES];
    }else if (sender.tag == 8){
        DetailWebViewController *web = [[DetailWebViewController alloc]init];
        web.webString = @"https://api.1396six.com/mobile/Voteinfoweb/27559";
        web.title = @"波色单双预测";
        [self.navigationController pushViewController:web animated:YES];

    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)setUpNetRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
        [button setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        label.text = _dataSource[index][@"label"];
        if (index == 3) {
            label.text = @"波色生肖投票";
            [button setImage:[UIImage imageNamed:@"indexicon4"] forState:UIControlStateNormal];
        }
        if (index == 7) {
            label.text = @"波色体育投票";
        }
        if (index == 8) {
            label.text = @"波色单双投票";
            [button setImage:[UIImage imageNamed:@"indexicon5"] forState:UIControlStateNormal];
        }
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
-(void)touchNavButton:(UIButton *)sender{
    
    if (sender.tag == 10) {
        DetailWebViewController *web = [[DetailWebViewController alloc]init];
        web.webString = @"https://api.1396six.com/mobile/live?token=122709d0c99842669b87bf9ea1a1f27a&rnd=0416";
        web.title = @"开奖直播";
        [self.navigationController pushViewController:web animated:YES];

    }else if (sender.tag == 11){
        DetailWebViewController *web = [[DetailWebViewController alloc]init];
        web.webString = @"http://client.310win.com/aspx/ChartList.aspx?_t=1493444074.721861";
        web.title = @"图表资料";
        [self.navigationController pushViewController:web animated:YES];
    }else{
        DetailWebViewController *web = [[DetailWebViewController alloc]init];
        web.webString = @"https://api.1396six.com/mobile/Statistics?c=100";
        web.title = @"六合统计";
        [self.navigationController pushViewController:web animated:YES];
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
        bannerY = 135;
    }else{
        bannerY = 175;
    }
    scrollLabelView.frame = CGRectMake(0, bannerY, DEVICEWIDTH, 30);
    [scrollLabelView beginScrolling];
    _scrollLabelView = scrollLabelView;
    return _scrollLabelView;
}
- (void)setUpNavButton{
    
    CGFloat w = DEVICEWIDTH/3;
    CGFloat bannerY;
    if (DEVICEWIDTH == 320) {
        bannerY = 150;
    }else{
        bannerY = 195;
    }
    NSArray *nameArray = @[@"开奖直播",@"免费资料",@"六合统计"];
    
    for (NSInteger i=0 ; i<3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake((i*w)+40, bannerY, 30, 30);
        btn.tag = 10+i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"nav%ld",i+1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchNavButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(btn.mj_x-10, btn.mj_y+20, 50, 30);
        label.text = [NSString stringWithFormat:@"%@",nameArray[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:label];
    }
}
- (SDCycleScrollView*)cycleScrollView{
    if (_cycleScrollView) return _cycleScrollView;
    CGFloat cycleH;
    if (DEVICEWIDTH == 320) {
        cycleH = 150;
    }else{
        cycleH = 207;
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DEVICEWIDTH, cycleH) imageURLStringsGroup:self.imgArray];
    cycleScrollView.autoScrollTimeInterval = 2.5;
    cycleScrollView.delegate = self;
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

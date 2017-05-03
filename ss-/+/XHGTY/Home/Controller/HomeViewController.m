//
//  HomeViewController.m
//  NewPuJing
//
//  Created by 杨健 on 2016/11/17.
//  Copyright © 2016年 杨健. All rights reserved.
//

#import "HomeViewController.h"
#import "FXHomeMenuCell.h"
#import "FXHomeMenuCycleView.h"
#import "FXLottery.h"
#import "FXWebViewController.h"
#import "VideoDrawViewController.h"
#import "RecordViewController.h"
#import "LotteryDistrViewController.h"
#import "LHDQViewController.h"
#import "ThreeViewController.h"
#import "TieBieViewController.h"
#import "FXNoNetWorkView.h"
#import "FXAd.h"
#import "FXWebViewController.h"
#import "TYBFViewController.h"

#import "HttpTools.h"
#import "AppURLdefine.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "AppDefine.h"
#import "GoucaiViewController.h"
#import "XHGTY-swift.h"
#import "HallCollectionViewCell.h"
#import "XYHeardView.h"
#import "ForumViewController.h"
#define kItemMargin 2
#import "CpMapViewController.h"
#import "HallCollectionViewCell.h"
#import "LoginViewController.h"
#import "DHGuidePageHUD.h"
#import "WebViewController.h"
#import "JXModel.h"
#import "AppModel.h"
#import "FXNLViewController.h"
#import "FXViewController.h"
#import "HomegpcCollectionViewCell.h"
#import "gpcModel.h"
#import "MNXHViewController.h"
#import "MessageRuntime.h"
/*
 足彩
 http://lhc.lh888888.com/Sports.aspx#
 
 */

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,requestNetWorDelegate,FXHomeMenuSelectedDelegate,UIAlertViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)FXHomeMenuCycleView *cycleView;

@property (nonatomic,strong)NSArray<FXLottery*> *totalLotters;

@property (nonatomic,strong)NSMutableArray *Ads;
/**网络链接失败*/
@property (nonatomic,strong)FXNoNetWorkView *nonetWorkView;

@property(nonatomic,strong) NSMutableArray<gpcModel *> * gpcArray;
@end

@implementation HomeViewController

static NSString *const cellID = @"cellID";
static NSString *const gpcID = @"gpcID";
-(NSMutableArray *)Ads{
    if (_Ads == nil) {
        _Ads = [NSMutableArray array];
    }
    return _Ads;
}
-(void)addyindaoyue{
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
//        
//        
//        [self setStaticGuidePage];
//        
//    }
}
-(void)addActionView{
    
    
//  
////    [HttpTools getWithPathsuccess:^(id JSON) {
////        dispatch_async(dispatch_get_main_queue(), ^{
//<<<<<<< Updated upstream
////            NSLog(@"有活动的时候开启");
//=======
//////            NSLog(@"有活动的时候开启");
//>>>>>>> Stashed changes
////        MessageRuntime * message  =  [[MessageRuntime alloc] init];
////        [message receiveRemoteNotificationuserInfo:JSON needLoginView:^(BOOL needlogin, UIViewController *viewController) {
////            [self presentViewController:viewController animated:NO completion:nil];
////        }];
//<<<<<<< Updated upstream
////            
//=======
////    
//>>>>>>> Stashed changes
////        });
////    } :^(NSError *error) {
////        
////    }];
//<<<<<<< Updated upstream
//
//=======
//    
//>>>>>>> Stashed changes
}
#pragma mark - 设置APP静态图片引导页
//- (void)setStaticGuidePage {
//    NSArray *imageNameArray = @[@"bei-1",@"bei-2",@"bei-3"];
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:[UIScreen mainScreen].bounds imageNameArray:imageNameArray buttonIsHidden:YES];
//    guidePage.slideInto = YES;
//    __weak __typeof (self) weak = self;
//    guidePage.removeFromeSuperViewBlock = ^(){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
//        [weak addActionView];
//    };
//    [window addSubview:guidePage];
//}


- (FXNoNetWorkView *)nonetWorkView{
    if (_nonetWorkView == nil) {
        _nonetWorkView = [FXNoNetWorkView noNetWorkView];
    }
    return _nonetWorkView;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    kSendNotify(@"首页消失", nil);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.totalLotters.count){
        kSendNotify(@"首页出现", nil);
    }
    _gpcArray = [[NSMutableArray alloc] init];
//    [self getgpcData];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Categories"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Message"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)leftClick{

    NSUserDefaults * defa = [NSUserDefaults standardUserDefaults];
    if ([defa valueForKey:@"account"]){
        [SVProgressHUD showWithStatus:@"您已经登录了！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        LoginViewController * login = [[UIStoryboard storyboardWithName:@"Other" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    
    }

}
-(void)rightClick{
  
    FXViewController * noti = [[UIStoryboard storyboardWithName:@"Other" bundle:nil] instantiateViewControllerWithIdentifier:@"FXViewController"];
    noti.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:noti animated:YES];
    
}
-(void)addsomething{
    if([AppModel setJinShaVc] && [[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]){
        [self addActionView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addyindaoyue];
    [self performSelector:@selector(addsomething)];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"大厅";
    self.nonetWorkView.delegate = self;
           [self setBannar];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomegpcCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gpcID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[XYHeardView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"heard"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  
    layout.minimumLineSpacing = kItemMargin;
 //   layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 80);
    layout.minimumInteritemSpacing = kItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(kItemMargin, kItemMargin, kItemMargin, kItemMargin);
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
           [self setBannar];
    }];
    [self loadNewItems];
    
}

//-(void)getgpcData{
//   [HttpTools GETWithPath:@"http://news.zhuoyicp.com/h5/gp/json.json" parms:nil success:^(id JSON){
//       if (JSON != nil){
//           _gpcArray = [gpcModel mj_objectArrayWithKeyValuesArray:JSON];
//           dispatch_async(dispatch_get_main_queue(), ^{
//                 [self.collectionView reloadData];
//           });
//         
//       }
//   } :^(NSError *error) {
//       
//   }];
//
//}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CGFloat itemW = (kScreenW - 4 * kItemMargin) / 3;
            CGFloat itemH = itemW+5;
      
            return CGSizeMake(itemW, itemH);
        }
            break;
            
        default:
            return CGSizeMake(self.view.width, 100);
            break;
    }

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return CGSizeMake(self.view.frame.size.width, 80);
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_gpcArray.count == 0){
        return 1;
    }
    return  2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.totalLotters.count;
            break;
            
        default:
            return _gpcArray.count;
            break;
    }

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            HallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            
            cell.lotteryName = self.totalLotters[indexPath.row].label;
            return cell;
        }
            break;
            
        default:
        {
            HomegpcCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gpcID forIndexPath:indexPath];
            if(_gpcArray.count > indexPath.row){
                cell.model = _gpcArray[indexPath.row];
            }
      //      cell = self.totalLotters[indexPath.row].label;
            return cell;
        }
            break;
    }
    

}

- (void)requestNetWorkAgain{
    [self.nonetWorkView removeFromSuperview];
    [self loadNewItems];
}
-(void)setBannar{

    [HttpTools POSTWithPath:@"http://soa.woying.com/Common/home_img" parms:nil success:^(id JSON) {
        [self.collectionView.mj_header endRefreshing];
                if ([JSON isKindOfClass:[NSArray class]]){
                 NSArray * array = JSON;
                    [self.Ads removeAllObjects];
                    for (NSDictionary * dic  in array) {
                        FXAd * model = [[FXAd alloc] init];
                        model.img = dic[@"ImgUrl"];
                        model.url = dic[@"AritleUrl"];
                        [self.Ads addObject:model];
                    }
             
               _cycleView.totalAds =self.Ads;
                }else{
                    NSString * str = [[NSBundle mainBundle] pathForResource:@"HomeType" ofType:@"geojson"];
                    NSDictionary * JSON = [NSDictionary dictionaryWithContentsOfFile:str];
                    self.Ads = [FXAd mj_objectArrayWithKeyValuesArray:JSON[@"ad"]];
                    _cycleView.totalAds =self.Ads;
                }
                
                
    } :^(NSError *error) {
          [self.collectionView.mj_header endRefreshing];
        NSString * str = [[NSBundle mainBundle] pathForResource:@"HomeType" ofType:@"geojson"];
        NSDictionary * JSON = [NSDictionary dictionaryWithContentsOfFile:str];
        self.Ads = [FXAd mj_objectArrayWithKeyValuesArray:JSON[@"ad"]];
        _cycleView.totalAds =self.Ads;
    }];
 

}
- (void)loadNewItems{
    
    NSString * str = [[NSBundle mainBundle] pathForResource:@"HomeType" ofType:@"geojson"];
    NSDictionary * JSON = [NSDictionary dictionaryWithContentsOfFile:str];
    
    
    
    [self.nonetWorkView removeFromSuperview];
    self.totalLotters = [FXLottery mj_objectArrayWithKeyValuesArray:JSON[@"content"]];
    
    [self.collectionView reloadData];
    
   
    
    
    _cycleView = [FXHomeMenuCycleView homeMenuCycleView];
    _cycleView.delegate = self;
  //  _cycleView.totalAds =self.Ads;
    
    self.cycleView = _cycleView;
    
    [self.collectionView addSubview:self.cycleView];
    self.collectionView.contentInset = UIEdgeInsetsMake(kScreenW * 3/8 , 0, 0, 0);
    
    
}

- (void)fxHomeMenuSelected:(NSString *)url{
    FXWebViewController *webVC = [[FXWebViewController alloc]init];
    webVC.accessUrl = url;
    if([url isEqualToString:@""]){
        return;
    }
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.titleName = @"活动";
    [self.navigationController pushViewController:webVC animated:YES];
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    XYHeardView * view;
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"heard" forIndexPath:indexPath];
        
    }
    return view;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            FXLottery *lottery = self.totalLotters[indexPath.item];
            
            NSString *destStr = lottery.label;
            
            if ([destStr isEqualToString:@"彩票大厅"]) {

                self.tabBarController.selectedIndex = 1;
                return;
            }else if ([destStr isEqualToString:@"彩票论坛"]){
                
      
                ForumViewController * vc = [[UIStoryboard storyboardWithName:@"Other" bundle:nil] instantiateViewControllerWithIdentifier:@"ForumViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                return;
            }else if ([destStr isEqualToString:@"彩票专区"]){
                LotteryDistrViewController *lotteryVC = [[LotteryDistrViewController alloc]init];
                lotteryVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lotteryVC animated:YES];
                return;
            }else if ([destStr isEqualToString:@"六合资料"]){
                LHDQViewController *lhVC = [[LHDQViewController alloc]init];
                lhVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lhVC animated:YES];
                return;
            }else if ([destStr isEqualToString:@"三期内必出"]){
                ThreeViewController *threeVC = [[ThreeViewController alloc]init];
                threeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:threeVC animated:YES];
                return;
            }else if ([destStr isEqualToString:@"特别号分析"]){
                TieBieViewController *tieBIEVC = [[TieBieViewController alloc]init];
                tieBIEVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tieBIEVC animated:YES];
                return;
            }else if ([destStr isEqualToString:@"体育比分"]){
                TYBFViewController *tieBIEVC = [[TYBFViewController alloc]init];
                tieBIEVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tieBIEVC animated:YES];
                return;
            }else if ([destStr isEqualToString:@"投注站"]){

                CpMapViewController * cp =  [[CpMapViewController alloc] init];
                cp.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cp animated:YES];
            }else if ([destStr isEqualToString:@"彩票资讯"]){
       
                
                FXWebViewController * web = [[FXWebViewController alloc] init];
           
                web.titleName = @"彩票资讯";
                web.accessUrl = @"http://news.soa.woying.com/";
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }
            break;
            
        default:
        {
            gpcModel * model = _gpcArray[indexPath.row];
            FXWebViewController * web =[[FXWebViewController alloc]init];
            web.titleName = model.title;
            web.accessUrl = model.contentUrl;
            web.hidesBottomBarWhenPushed = YES;
            web.isneed = YES;
            [self.navigationController pushViewController:web animated:YES];
            

        }
            break;
    }
    
}



@end

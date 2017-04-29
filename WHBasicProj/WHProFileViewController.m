//
//  WHProFileViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/27.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHProFileViewController.h"
#import "WHProFileTableViewCell.h"
#import "WHNoDataTableViewController.h"
@interface WHProFileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITextField *userNameTF;
@property (nonatomic,strong)UITextField *userPswTF;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *imageDataSource;
@property (nonatomic,strong)UIButton *loginButton;

@end

@implementation WHProFileViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(236, 236, 236);
    
    if (![self islogin]){
        [self setUpLoginUI];//未登录
    }else{
        [self setUpLogonUI];//已登录
    }
}
- (void)setUpLoginUI{
    //圆形icon 图标
    UIImageView *circleImageView = [[UIImageView alloc]init];
    circleImageView.frame = CGRectMake(DEVICEWIDTH/2-50, 100, 100, 100);
    [circleImageView setImage:[UIImage imageNamed:@"AppIcons40x40"]];
    circleImageView.layer.cornerRadius = 20;
    circleImageView.clipsToBounds = YES;
    [self.view addSubview:circleImageView];
    
    UILabel *userNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 249, 100, 50)];
    userNamelabel.text = @"          用户名:";
    userNamelabel.adjustsFontSizeToFitWidth = YES;
    userNamelabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userNamelabel];
    
    UIImageView *userNameImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 260, 30, 30)];
    [userNameImageV setImage:[UIImage imageNamed:@"newiconp2"]];
    [self.view addSubview:userNameImageV];
    
    UILabel *userPWD = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 100, 50)];
    userPWD.text = @"          密  码:";
    userPWD.adjustsFontSizeToFitWidth = YES;
    userPWD.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userPWD];
    
    UIImageView *userPWDImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 310, 30, 30)];
    [userPWDImageV setImage:[UIImage imageNamed:@"newiconp1"]];
    [self.view addSubview:userPWDImageV];
    
    _userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 249, DEVICEWIDTH-100, 50)];
    _userNameTF.placeholder = @"请输入用户名";
    _userNameTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_userNameTF];
    
    _userPswTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 300, DEVICEWIDTH-100, 50)];
    _userPswTF.placeholder = @"请输入密码";
    _userPswTF.secureTextEntry = YES;
    _userPswTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_userPswTF];
    
    _loginButton = [[UIButton alloc]init];
    _loginButton.frame = CGRectMake(DEVICEWIDTH/2-150, 400, 300, 50);
    _loginButton.layer.cornerRadius = 15;
    [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [_loginButton addTarget: self action:@selector(loginbunClick) forControlEvents:UIControlEventTouchUpInside];
    _loginButton.backgroundColor = RGB(232, 78, 32);
    [self.view addSubview:_loginButton];
    
    UIButton *regisBtn = [[UIButton alloc]init];
    [regisBtn setTitle:@"想要注册?" forState:UIControlStateNormal];
    regisBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regisBtn addTarget:self action:@selector(regisBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [regisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    regisBtn.frame = CGRectMake(15, 500, 100, 20);
    [self.view addSubview:regisBtn];
}
- (void)setUpLogonUI{
    
    [self.view addSubview:self.tableView];
}

- (void)loginbunClick{
    NSString *messaget = @"";
    if (_userNameTF.text.length == 0)messaget = @"请输入用户名";
    if (_userPswTF.text.length == 0)messaget = @"请输入密码";
    if (messaget.length!=0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:messaget delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![_userPswTF.text isEqualToString: @"appletest"] && ![_userPswTF.text isEqualToString:@"appletest"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"账号或者密码输入错误" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"登录中...";
    [hud hideAnimated:YES afterDelay:2];
    [[NSUserDefaults standardUserDefaults]setObject:@"islogin" forKey:@"islogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSelector:@selector(refreshPage) withObject:nil afterDelay:2];
}

- (void)refreshPage{
    [self setUpLogonUI];//已登录
}
- (void)regisBtnClick{
    NSString *title = @"我们目前仅采用邀请用户的形式开通账户，暂不支持用户注册";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
    [alert show];
}

- (BOOL)islogin{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"islogin"] length]) return YES;
    return NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WHProFileTableViewCell *cell = [[WHProFileTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.nameLabel.text = _dataSource[indexPath.row];
    [cell.headImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageDataSource[indexPath.row]]]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WHNoDataTableViewController *vc = [[WHNoDataTableViewController alloc]init];
    vc.noDataString = _dataSource[indexPath.row];
    vc.title = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableView{
    if (_tableView) return _tableView;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -40, DEVICEWIDTH, DEVICEHEIGHT) style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self headerView];
    tableView.tableFooterView = [[UIView alloc]init];
    _tableView = tableView;
    return  _tableView;
}
-(NSMutableArray *)dataSource{
    if (_dataSource) return _dataSource;
    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:@[@"我的粉丝",@"我的关注"]];
    NSMutableArray *imageSource = [NSMutableArray arrayWithArray:@[@"newicon3",@"newicon5"]];
    _imageDataSource = imageSource;
    _dataSource = dataSource;
    return _dataSource;
}
-(UIView *)headerView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 250)];
    headerView.backgroundColor = RGB(23, 31, 54);
    
    UIImageView *headerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 100, 100, 100)];
    [headerImageV setImage: [UIImage imageNamed:@"AppIcons40x40"]];
    headerImageV.layer.cornerRadius = 8;
    headerImageV.clipsToBounds = YES;
    [headerImageV.layer setMasksToBounds:YES];
    [headerImageV.layer setCornerRadius:10];
    [headerImageV.layer setBorderWidth:1];
    [headerImageV.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [headerView addSubview:headerImageV];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 110, 100, 30)];
    nameLabel.text = @"appletest";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:nameLabel];
    
    UILabel *jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 160, 100, 30)];
    jobLabel.text = @"长工";
    jobLabel.font = [UIFont systemFontOfSize:15];
    jobLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:jobLabel];
    
    UILabel *inviteLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEVICEWIDTH - 160, 209, 140, 30)];
    inviteLabel.text = @"邀请码: 43167071";
    inviteLabel.textColor = [UIColor whiteColor];
    inviteLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:inviteLabel];
    
    UIImageView *qrImageV = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICEWIDTH - 40, 210, 30, 30)];
    [qrImageV setImage:[UIImage imageNamed:@"qrcode600"]];
    [headerView addSubview:qrImageV];
    return headerView;
}
@end

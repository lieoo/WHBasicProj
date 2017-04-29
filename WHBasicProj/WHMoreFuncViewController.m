//
//  WHMoreFuncViewController.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/29.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHMoreFuncViewController.h"
#import "WHProFileTableViewCell.h"
#import "WHFeedBackViewController.h"
@interface WHMoreFuncViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong ) NSMutableArray *imageDataArray;


@end

@implementation WHMoreFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:105.0f/255.0f green:183.0f/255.0f blue:244.0f/255.0f alpha:1];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WHProFileTableViewCell *cell = [[WHProFileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.nameLabel.text = _dataArray[indexPath.row];
    [cell.headImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageDataArray[indexPath.row]]]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[WHFeedBackViewController new] animated:YES];
    }
}

- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

- (NSMutableArray *)dataArray{
    if (_dataArray) return _dataArray;
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [dataSource addObjectsFromArray:@[@"免责声明",@"意见反馈",@"清理缓存",@"帮助中心",@"关于应用"]];
    NSMutableArray *imageDataSour = [NSMutableArray array];
    [imageDataSour addObjectsFromArray:@[@"newicon1",@"newicon2",@"newicon_0001_6",@"cleardisk",@"newicon_0002_5"]];
    _imageDataArray = imageDataSour;
    _dataArray = dataSource;
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView) return _tableView;
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    return _tableView;
}
@end

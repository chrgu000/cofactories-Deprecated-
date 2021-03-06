
//
//  PurchaseHistoryPublicVC.m
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PurchaseHistoryPublicVC.h"
#import "PurchaseMPTableViewCell.h"
#import "PurchasePublicHistoryModel.h"
#import "PHPDetailViewController.h"
#import "NeedMaterialViewController.h"
#import "MJRefresh.h"

@interface PurchaseHistoryPublicVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView        *_tableView;
    NSMutableArray     *_dataArray;
    int                _refrushCount;

}

@end

@implementation PurchaseHistoryPublicVC
static NSString * const reuseIdentifier = @"cellIdentifier";



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isMe) {
        self.navigationItem.title = @"查看求购";
           [self creatTableView];
        [self setupRefreshZHAO];
    } else {
        self.navigationItem.title = @"历史发布";
           [self creatTableView];
        [self setupRefreshGUTao];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    _tableView.tableFooterView = [[UIView alloc] init];
    _refrushCount = 1;
    _dataArray = [@[] mutableCopy];
    
    if (self.isMe) {
        //请求查看求购页面
        [HttpClient searchMaterialBidWithKeywords:nil type:nil page:1 completionBlock:^(NSDictionary *responseDictionary) {
            NSArray *array = (NSArray *)responseDictionary[@"responseObject"];
            for (NSDictionary *dictionary in array) {
                //SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
                PurchasePublicHistoryModel *search = [PurchasePublicHistoryModel getModelWith:dictionary];
                [_dataArray addObject:search];
            }
            [_tableView reloadData];
        }];
    } else {
        [HttpClient checkHistoryPublishWithPage:1 completionBlock:^(NSDictionary *responseDictionary){
            NSArray *array = (NSArray *)responseDictionary[@"responseObject"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PurchasePublicHistoryModel * model = [PurchasePublicHistoryModel getModelWith:(NSDictionary *)obj];
                [_dataArray addObject:model];
            }];
            DLog(@"_dataArray==%@",_dataArray);
            [_tableView reloadData];
        }];
    }

 
}

- (void)setupRefreshZHAO
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshingZHAO)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshingZHAO
{
    _refrushCount++;
    DLog(@"???????????%d",_refrushCount);
    [HttpClient searchMaterialBidWithKeywords:nil type:nil page:_refrushCount completionBlock:^(NSDictionary *responseDictionary) {
        NSArray *array = (NSArray *)responseDictionary[@"responseObject"];
        for (NSDictionary *dictionary in array) {
            PurchasePublicHistoryModel *search = [PurchasePublicHistoryModel getModelWith:dictionary];
            [_dataArray addObject:search];
        }
        [_tableView reloadData];
    }];
    
    [_tableView footerEndRefreshing];
}

- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 85;
    [_tableView registerClass:[PurchaseMPTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (void)setupRefreshGUTao
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshingGutao)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshingGutao
{
    _refrushCount++;
    DLog(@"???????????%d",_refrushCount);
    [HttpClient checkHistoryPublishWithPage:_refrushCount completionBlock:^(NSDictionary *responseDictionary){
        NSArray *array = (NSArray *)responseDictionary[@"responseObject"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PurchasePublicHistoryModel * model = [PurchasePublicHistoryModel getModelWith:(NSDictionary *)obj];
            [_dataArray addObject:model];
        }];
        DLog(@"_dataArray==%@",_dataArray);
        [_tableView reloadData];
    }];
    
    [_tableView footerEndRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PurchaseMPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    PurchasePublicHistoryModel *model = _dataArray[indexPath.row];
    [cell getDataWithModel:model];
    return cell;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isMe) {
        //进入查看求购详情页面
        NeedMaterialViewController *needVC = [[NeedMaterialViewController alloc] init];
        PurchasePublicHistoryModel *model = _dataArray[indexPath.row];
        needVC.oid = [NSString stringWithFormat:@"%ld", (long)model.orderID];
        needVC.photoArray = model.photoArray;
        needVC.amount = model.unit;
        needVC.isCompletion = model.isCompletion;
        needVC.needName = model.name;
        [self.navigationController pushViewController:needVC animated:YES];
        
    } else {
        PHPDetailViewController *VC = [[PHPDetailViewController alloc]init];
        VC.model = _dataArray[indexPath.row];
        
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title = @"";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

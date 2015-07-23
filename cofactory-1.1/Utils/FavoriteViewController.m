//
//  FavoriteViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "FavoriteViewController.h"

@interface FavoriteViewController ()

@property (nonatomic,retain)NSMutableArray * modelArray;

@end

@implementation FavoriteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];
    [HttpClient listFavoriteWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray=responseDictionary[@"responseArray"];
        [self.tableView reloadData];
        NSLog(@"%@",responseDictionary);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"我的收藏";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=100;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        FactoryModel*factoryModel=self.modelArray[indexPath.section];

        UIImageView*headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        NSString *imageUrlString = [NSString stringWithFormat:@"http://cofactories.bangbang93.com/storage_path/factory_avatar/%d",factoryModel.uid];
        [headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
        headerImage.clipsToBounds=YES;
        headerImage.contentMode=UIViewContentModeScaleAspectFill;
        headerImage.layer.cornerRadius=80/2.0f;
        headerImage.layer.masksToBounds=YES;
        [cell addSubview:headerImage];

        for (int i=0; i<3; i++) {
            UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (10+30*i), kScreenW-170, 20)];
            cellLabel.font=[UIFont systemFontOfSize:14.0f];
            switch (i) {
                case 0:
                {
                    cellLabel.text=factoryModel.factoryName;
                    cellLabel.textColor=[UIColor orangeColor];

                }
                    break;
                case 1:
                {
                    cellLabel.text=factoryModel.legalPerson;

                }
                    break;
                case 2:
                {
                    cellLabel.text=factoryModel.phone;

                }
                    break;

                default:
                    break;
            }
            [cell addSubview:cellLabel];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FactoryModel*factoryModel=self.modelArray[indexPath.section];
    CooperationInfoViewController*infoVC = [[CooperationInfoViewController alloc]init];
    infoVC.factoryModel=factoryModel;
    infoVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

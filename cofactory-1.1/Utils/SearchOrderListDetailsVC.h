//
//  SearchOrderListDetailsVC.h
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface SearchOrderListDetailsVC : UITableViewController
@property (nonatomic,strong) UIButton *confirmOrderButton;
@property (nonatomic,strong) UIView   *contactManufacturerView;
@property (nonatomic,assign)int oid;

@property (nonatomic,assign)int uid;//gt123
@property (nonatomic,strong) OrderModel *model;


@end
//
//  MessageDetailViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()


@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStylePlain];
    self.tableView.rowHeight=150;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString*CellIdentifier=@"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    _messageStr = @"UINavigationController是IOS编程中比较常用的一种容器view controller，很多系统的控件(如UIImagePickerViewController)以及很多有名的APP中(如qq，系统相册等)都有用到。说是使用详解，其实我只会介绍几个自认为比较重要或者容易放错的地方进行讲解，下面让我们挨个探探究竟：";

    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenW, 20)];
    timeLabel.font=kLargeFont;
    timeLabel.textColor=[UIColor grayColor];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text = _timeString;
    [cell addSubview:timeLabel];
    
    UIFont*font=kFont;
    UILabel*messageLabel=[[UILabel alloc]init];
    messageLabel.font=font;
    messageLabel.numberOfLines=0;
    messageLabel.textColor=[UIColor blackColor];
    messageLabel.text = _messageStr;


    CGSize size = [Tools getSize:_messageStr andFontOfSize:14.0f];

    messageLabel.frame=CGRectMake(10, 10, size.width+4, size.height+5);
    [messageLabel sizeToFit];

    UIImageView *messageBgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 25, size.width+15, size.height+20)];
    messageBgView.image=[UIImage imageNamed:@"消息框"];
    messageBgView.contentMode=UIViewContentModeScaleToFill;
    [messageBgView addSubview:messageLabel];
    [cell addSubview:messageBgView];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = [Tools getSize:_messageStr andFontOfSize:14.0f];

    return size.height+80.0f;
}

- (void)dealloc
{
    DLog(@"释放内存");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
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

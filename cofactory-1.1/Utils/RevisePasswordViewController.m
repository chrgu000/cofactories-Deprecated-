//
//  RevisePasswordViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "RevisePasswordViewController.h"

@interface RevisePasswordViewController (){
    UITextField*passwordTF1;
    UITextField*passwordTF2;

}

@end

@implementation RevisePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"修改密码";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;


    passwordTF1=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 44)];
    passwordTF1.clearButtonMode=YES;
    passwordTF1.secureTextEntry=YES;
    passwordTF1.placeholder=@"6-16个字符，区分大小写";

    passwordTF2=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 44)];
    passwordTF2.clearButtonMode=YES;
    passwordTF2.secureTextEntry=YES;
    passwordTF2.placeholder=@"请您再次输入密码";

    UIButton* showBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-120, 155, 100, 30)];
    showBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13.0f];
    [showBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"select_highlight"] forState:UIControlStateSelected];
    [showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showBtn setTitle:@"显示密码" forState:UIControlStateNormal];
    [showBtn setTitle:@"隐藏密码" forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(showPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:showBtn];


    UIButton*ReviseBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 200, kScreenW-40, 35)];
    [ReviseBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ReviseBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [ReviseBtn addTarget:self action:@selector(RevisePasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:ReviseBtn];

}

- (void)showPasswordBtn:(UIButton *)sender {
    UIButton*button = (UIButton *)sender;
    button.selected=!button.selected;
    passwordTF1.secureTextEntry=!passwordTF1.secureTextEntry;
    passwordTF2.secureTextEntry=!passwordTF2.secureTextEntry;
}

- (void)RevisePasswordBtn {
    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"无接口，该功能暂不提供" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];

    [alertView show];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:{
            [cell addSubview:passwordTF1];

        }
            break;
        case 1:{
            [cell addSubview:passwordTF2];


        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
    UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW-20, 25)];
    titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    switch (section) {
        case 0:
        {
            titleLabel.text=@"旧密码";
        }
            break;
        case 1:
        {
            titleLabel.text=@"旧密码";
        }
            break;
            
        default:
            break;
    }
    [view addSubview:titleLabel];


    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01f)];
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    return view;
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

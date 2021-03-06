//
//  AddmaterialViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "AddmaterialViewController.h"
#import "MeViewController.h"

#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddmaterialViewController () <JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,retain) NSString * materialTypeStr;

@property(nonatomic,retain) UITextField * NameTF;

@property(nonatomic,retain) UITextField * UseTF;

@property(nonatomic,retain) UITextField * WidthTF;

@property(nonatomic,retain) UILabel *widthLabel;

@property(nonatomic,retain) UITextField * PriceTF;

@property(nonatomic, retain) UILabel *priceLabel;

@property(nonatomic,retain) UITextField * ExplainTF;


@property (nonatomic, strong) JKAssets  *asset;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *collectionImage;


@end

@implementation AddmaterialViewController {

    UIButton * _addImageBtn;
    UIButton *btn;
    FactoryModel  *_userModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [self netWork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        switch (self.materialType) {
        case 1:
            self.title = @"发布面料供应";
            break;
        case 2:
            self.title = @"发布辅料供应";
            break;
        case 3:
            self.title = @"发布坯布供应";
            break;

        default:
            break;
    }


    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"发布供应" forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:YES];
    [btn addTarget:self action:@selector(pushOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * setButton = [[UIBarButtonItem alloc]initWithCustomView:btn];


    self.navigationItem.rightBarButtonItem = setButton;

    self.collectionImage = [[NSMutableArray alloc]initWithCapacity:9];


    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];

    _addImageBtn = [[UIButton alloc]init];
    _addImageBtn.frame=CGRectMake(30, 7, kScreenW-60, 30);
    [_addImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [_addImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addImageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _addImageBtn.layer.masksToBounds = YES;
    _addImageBtn.layer.cornerRadius = 3;
    _addImageBtn.backgroundColor = [UIColor colorWithHexString:@"0x3bbc79"];
    [_addImageBtn addTarget:self action:@selector(addImageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)netWork {
    //解析工厂信息
    NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
    [HttpClient getUserProfileWithUid:[uid intValue] andBlock:^(NSDictionary *responseDictionary) {
        _userModel = (FactoryModel *)responseDictionary[@"model"];
    }];

}

- (void)pushOrderBtn {
    if (_userModel.factoryServiceRange == nil || _userModel.factoryAddress == nil) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"个人信息不完整" message:@"请完善信息后再继续发布" delegate:self cancelButtonTitle:@"暂不完善" otherButtonTitles:@"去完善", nil];
        alertView.tag = 222;
        [alertView show];
    } else {
        if (self.materialType == 1) {
            if (self.NameTF.text.length == 0 || self.UseTF.text.length == 0 || self.WidthTF.text.length == 0 || self.PriceTF.text.length == 0 || self.ExplainTF.text.length == 0) {
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单信息不完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            } else {
                if (self.collectionImage.count == 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定不上传图片?" message:nil delegate:self cancelButtonTitle:@"我要上传" otherButtonTitles:@"直接发布", nil];
                    alert.tag = 100;
                    [alert show];
                } else {
                    [btn setUserInteractionEnabled:NO];
                    NSArray *nameArr = @[@"面料", @"辅料", @"坯布"];
                    [HttpClient addMaterialWithType:nameArr[self.materialType - 1] name:self.NameTF.text usage:self.UseTF.text price:[self.PriceTF.text floatValue] width:self.WidthTF.text  description:self.ExplainTF.text andBlock:^(NSDictionary *responseDictionary) {
                        int statusCode = [responseDictionary[@"statusCode"] intValue];
                        DLog(@"%d", statusCode);
                        if (statusCode==200) {
                            
                            int index = [responseDictionary[@"responseObject"][@"id"] intValue];
                            if (![self.collectionImage count]==0) {
                                [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                                    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                                    NSString *oidString = [NSString stringWithFormat:@"%d",index];
                                    [HttpClient uploadMaterialImageWithImage:newImage oid:oidString type:@"sell" andblock:^(NSDictionary *dictionary) {
                                        if ([dictionary[@"statusCode"] intValue]==200) {
                                            [Tools showSuccessWithStatus:@"发布成功"];
                                            double delayInSeconds = 1.0f;
                                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                NSArray *navArray = self.navigationController.viewControllers;
                                                [self.navigationController popToViewController:navArray[3] animated:YES];
                                                
                                            });
                                            
                                            DLog(@"图片上传成功");
                                        }else{
                                            [btn setUserInteractionEnabled:YES];
                                            DLog(@"图片上传失败%@",dictionary);
                                        }
                                        
                                    }];
                                    
                                }];
                            }
                            
                            
                        } else {
                            [btn setUserInteractionEnabled:YES];
                            [Tools showErrorWithStatus:@"订单发布失败"];
                            
                        }
                        
                    }];
                }
                
                
            }
        } else {
            if (self.NameTF.text.length == 0 || self.PriceTF.text.length == 0 || self.ExplainTF.text.length == 0) {
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单信息不完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            } else {
                if (self.collectionImage.count == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定不上传图片?" message:nil delegate:self cancelButtonTitle:@"我要上传" otherButtonTitles:@"直接发布", nil];
                    alert.tag = 100;
                    [alert show];
                } else {
                    [btn setUserInteractionEnabled:NO];
                    NSArray *nameArr = @[@"面料", @"辅料", @"坯布"];
                    [HttpClient addMaterialWithType:nameArr[self.materialType - 1] name:self.NameTF.text usage:self.UseTF.text price:[self.PriceTF.text floatValue] width:self.WidthTF.text  description:self.ExplainTF.text andBlock:^(NSDictionary *responseDictionary) {
                        int statusCode = [responseDictionary[@"statusCode"] intValue];
                        DLog(@"%d", statusCode);
                        if (statusCode==200) {
                            int index = [responseDictionary[@"responseObject"][@"id"] intValue];
                            if (![self.collectionImage count]==0) {
                                
                                [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    
                                    NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                                    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                                    NSString *oidString = [NSString stringWithFormat:@"%d",index];
                                    [HttpClient uploadMaterialImageWithImage:newImage oid:oidString type:@"sell" andblock:^(NSDictionary *dictionary) {
                                        if ([dictionary[@"statusCode"] intValue]==200) {
                                            [Tools showSuccessWithStatus:@"发布成功"];
                                            double delayInSeconds = 1.0f;
                                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                NSArray *navArray = self.navigationController.viewControllers;
                                                [self.navigationController popToViewController:navArray[3] animated:YES];
                                                
                                            });
                                            DLog(@"图片上传成功");
                                        }else{
                                            [btn setUserInteractionEnabled:YES];
                                            DLog(@"图片上传失败%@",dictionary);
                                        }
                                        
                                    }];
                                    
                                }];
                            }
                            
                            
                        } else {
                            [btn setUserInteractionEnabled:YES];
                            [Tools showErrorWithStatus:@"订单发布失败"];
                            
                        }
                        
                    }];
                }
                
                
            }
        }

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSArray *nameArr = @[@"面料", @"辅料", @"坯布"];
            [HttpClient addMaterialWithType:nameArr[self.materialType - 1] name:self.NameTF.text usage:self.UseTF.text price:[self.PriceTF.text floatValue] width:self.WidthTF.text description:self.ExplainTF.text andBlock:^(NSDictionary *responseDictionary) {
                int statusCode = [responseDictionary[@"statusCode"] intValue];
                if (statusCode == 200) {
                    [Tools showSuccessWithStatus:@"发布成功"];
                    double delayInSeconds = 1.0f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        NSArray *navArray = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:navArray[3] animated:YES];
                        
                    });
                } else {
                    [Tools showErrorWithStatus:@"发布失败"];
                }
            }];
        }
    } else if (alertView.tag == 222){
        if (buttonIndex == 1) {
            DLog(@"去完善资料");
            MeViewController *meVC = [[MeViewController alloc] init];
            meVC.changeFlag = YES;
            [self.navigationController pushViewController:meVC animated:YES];
        } else {
            DLog(@"暂不完善");
        }
    }
}


- (UITextField *)createNameTF {
    if (!self.NameTF) {
        self.NameTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW/5, 0, kScreenW - kScreenW/5, 44)];
        self.NameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.NameTF.placeholder = @"(如：全棉斜纹双色布)";

    }
    return self.NameTF;
}

- (UITextField *)createUseTF {
    if (!self.UseTF) {
        self.UseTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW/5, 0, kScreenW - kScreenW/5, 44)];
        self.UseTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.UseTF.placeholder = @"请填写面料主要用途";

    }
    return self.NameTF;
}

- (UITextField *)createWidthTF {
    if (!self.WidthTF) {
        self.WidthTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW/5, 0, kScreenW - 2*kScreenW/5, 44)];
        self.WidthTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.WidthTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.WidthTF.placeholder = @"请填写数字，如3.5";

    }
    return self.WidthTF;
}
- (UILabel *)creatWidthLabel {
    if (!self.widthLabel) {
        self.widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(4*kScreenW/5, 0, kScreenW/5, 44)];
        self.widthLabel.text = @"米";
    }
    
    return self.widthLabel;
    
}

- (UITextField *)createPriceTF {
    if (!self.PriceTF) {
        self.PriceTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW/5, 0, kScreenW - 2*kScreenW/5, 44)];
        self.PriceTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.PriceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.PriceTF.placeholder = @"请填写数字，如12.3";

    }
    return self.PriceTF;
}

- (UILabel *)creatPriceLabel {
    if (!self.priceLabel) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(4*kScreenW/5, 0, kScreenW/5, 44)];
        self.priceLabel.text = @"元";
    }
    return self.priceLabel;
}

- (UITextField *)createExplainTF {
    if (!self.ExplainTF) {
        self.ExplainTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW/5, 0, kScreenW - kScreenW/5, 44)];
        self.ExplainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.ExplainTF.placeholder = @"其他说明";

    }
    return self.ExplainTF;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.materialType == 1){
        switch (section) {
            case 0:
                return 2;
                break;
            case 1:
                return 2;
                break;
            case 2:
                return 1;
                break;
            case 3:
                return 1;
                break;
            default:
                break;

        }
    }
    if (self.materialType == 2 || self.materialType == 3) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;

            case 2:
                return 1;
                break;
            case 3:
                return 1;
                break;
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:16.0f];

        if (self.materialType == 1) {
            switch (indexPath.section) {
                case 0:
                {
                    switch (indexPath.row) {
                        case 0:{
                            [self createNameTF];
                            [cell addSubview:self.NameTF];
                            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"*品 名"];
                            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
                            cell.textLabel.attributedText = labelText;
                        }
                            break;
                        case 1:{
                            [self createUseTF];
                            [cell addSubview:self.UseTF];
                            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"*用 途"];
                            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
                            cell.textLabel.attributedText = labelText;

                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;

                case 1:
                {
                    switch (indexPath.row) {
                        case 0:{
                            [self createPriceTF];
                            [cell addSubview:self.PriceTF];
                            [self creatPriceLabel];
                            [cell addSubview:self.priceLabel];
                            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"*价 格"];
                            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
                            cell.textLabel.attributedText = labelText;
                        }
                            break;
                        case 1:{
                            [self createWidthTF];
                            [cell addSubview:self.WidthTF];
                            [self creatWidthLabel];
                            [cell addSubview:self.widthLabel];
                            
                            
                            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"*门 幅"];
                            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
                            cell.textLabel.attributedText = labelText;
                        }
                            break;

                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }

        if (self.materialType == 2 || self.materialType == 3) {
            switch (indexPath.section) {
                case 0:
                {
                    switch (indexPath.row) {
                        case 0:{
                            [self createNameTF];
                            [cell addSubview:self.NameTF];
                            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"*品 名"];
                            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
                            cell.textLabel.attributedText = labelText;
                        }
                            break;

                        default:
                            break;
                    }
                }
                    break;

                case 1:
                {
                    switch (indexPath.row) {
                        case 0:{

                            [self createPriceTF];
                            [cell addSubview:self.PriceTF];
                            [self creatPriceLabel];
                            [cell addSubview:self.priceLabel];
                            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@"*价 格"];
                            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
                            cell.textLabel.attributedText = labelText;                        }
                            break;

                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }

        if (indexPath.section == 2) {

            if (indexPath.row == 0) {
                [self createExplainTF];
                [cell addSubview:self.ExplainTF];
                cell.textLabel.text = @"  说 明";

                DLog(@"farme=%@",NSStringFromCGRect(cell.textLabel.frame));
            }

        }
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                [cell addSubview:_addImageBtn];
                if ([self.collectionImage count]==0) {

                }else {
                    [cell addSubview:self.collectionView];
                }
            }
        }

    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==3) {
        if ([self.collectionImage count]==0) {
            return 44;
        }
        if (0<[self.collectionImage count] && [self.collectionImage count]<4) {
            return kScreenW/3+50;
        }
        if (3<[self.collectionImage count] && [self.collectionImage count]<7) {
            return 2*kScreenW/3+50;
        }
        if (6<[self.collectionImage count] && [self.collectionImage count]<10) {
            return kScreenW+50;
        }
    }
    return 44;
}



- (void)addImageBtn {

    if ([self.collectionImage count]== 9) {
        [Tools showErrorWithStatus:@"订单图片最多能上传9张"];
    }else {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 0;
        imagePickerController.maximumNumberOfSelection = 9 - [self.collectionImage count];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}


#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{

        DLog(@"1");
    }];
}

//下一步
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"2");

        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.asset=assets[idx];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage*image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    [self.collectionImage addObject:image];
                    if (idx == [assets count] - 1) {
                        [self collectionView];
                        [self.collectionView reloadData];
                        [self.tableView reloadData];

                        DLog(@"self.collectionImage %lu",(unsigned long)[self.collectionImage count]);
                    }
                }
            } failureBlock:^(NSError *error) {

            }];

        }];
    }];

}

//取消
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"取消");
    }];
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenW) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionImage count];

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView*imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    imageView.image = self.collectionImage[indexPath.row];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];

    UIButton*deleteBtn = [[UIButton alloc]init];
    deleteBtn.frame = CGRectMake(imageView.frame.size.width-25, 0, 25, 25);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
    [deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:deleteBtn];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.collectionImage count]];
    [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = self.collectionImage[idx]; // 图片
        [photos addObject:photo];
    }];

    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row;
    browser.photos = photos;
    [browser show];
    
}

- (void)deleteCell:(UIButton*)sender {
    DLog(@"%ld",(long)sender.tag);
    [self.collectionImage removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
    [self.tableView reloadData];

}


@end

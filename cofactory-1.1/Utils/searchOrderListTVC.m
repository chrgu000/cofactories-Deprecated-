//
//  searchOrderListTVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "searchOrderListTVC.h"
#import "Header.h"

@implementation searchOrderListTVC{
    NSArray   *_competeFactoryArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *labelBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
        labelBGView.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
        labelBGView.userInteractionEnabled = YES;
        [self addSubview:labelBGView];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW, 15)];
        self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
        self.timeLabel.textColor = [UIColor whiteColor];
        [labelBGView addSubview:self.timeLabel];
        
        self.orderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 60, 60)];
        self.orderImage.contentMode = UIViewContentModeScaleAspectFill;
        self.orderImage.layer.masksToBounds = YES;
        self.orderImage.layer.cornerRadius = 5;
        [self addSubview:self.orderImage];
        
        self.orderTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 140, 20)];
        self.orderTypeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.orderTypeLabel];
        
        self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 160, 20)];
        self.amountLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.amountLabel];
        
        self.workingTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 100, 20)];
        self.workingTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.workingTimeLabel];
        
        self.interestCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 92, (kScreenW-140)/2.0, 22)];
        self.interestCountLabel.font = [UIFont systemFontOfSize:14.0f];
        self.interestCountLabel.textColor = [UIColor orangeColor];
        self.interestCountLabel.textAlignment = 2;
        [self addSubview:self.interestCountLabel];
        
        
        self.labels = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-140)/2.0, 92, 140, 22)];
        self.labels.font = [UIFont systemFontOfSize:14.0f];
        self.labels.text = @"家厂商已投标";
        [self addSubview:self.labels];
        
        self.statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-75, 15, 65, 65)];
        self.statusImage.image = [UIImage imageNamed:@"章.jpg"];
        [self addSubview:self.statusImage];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, [UIScreen mainScreen].bounds.size.width-20, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:0.3];
        [self addSubview:lineLabel];
        
        
        self.orderDetailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.orderDetailsBtn.frame = CGRectMake(kScreenW-70, 92, 60, 22);
        [self.orderDetailsBtn setTitle:@"订单详情" forState:UIControlStateNormal];
        self.orderDetailsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.orderDetailsBtn.layer.masksToBounds = YES;
        self.orderDetailsBtn.layer.cornerRadius = 3;
        self.orderDetailsBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
        [self addSubview:self.orderDetailsBtn];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, 10)];
        backgroundView.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:0.3];
        [self addSubview:backgroundView];
        
    }
    return self;
}

- (void)getDataWithModel:(OrderModel *)model orderListType:(int)orderListType{

    [HttpClient getBidOrderWithOid:model.oid andBlock:^(NSDictionary *responseDictionary) {
        _competeFactoryArray = responseDictionary[@"responseArray"];
        if (_competeFactoryArray.count == 0) {
            self.labels.hidden = YES;
            self.interestCountLabel.hidden = YES;
        }else {
            self.labels.hidden = NO;
            self.interestCountLabel.hidden = NO;
            self.interestCountLabel.text = [NSString stringWithFormat:@"%zi",_competeFactoryArray.count];
        }
    }];
    
    
    if (model.status == 0) {
        self.statusImage.hidden = YES;
    }else {
        self.statusImage.hidden = NO;
    }
    
    NSMutableArray *arr = [Tools WithTime:model.createTime];
    self.timeLabel.text = arr[0];
    [self.orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/%d.png",PhotoAPI,model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
    self.amountLabel.text = [NSString stringWithFormat:@"订单数量 :  %d%@",model.amount,@"件"];
    
    if (orderListType == 1  )
    {
        self.orderTypeLabel.hidden = NO;
        self.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];
        self.workingTimeLabel.hidden = NO;
        self.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@天",model.workingTime];
    }else{
        self.orderTypeLabel.hidden = YES;
        self.workingTimeLabel.hidden = YES;
    }
    
    if (model.type == 1) {
        
        self.orderTypeLabel.hidden = NO;
        self.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];
        self.workingTimeLabel.hidden = NO;
        self.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@天",model.workingTime];
    }else{
        self.orderTypeLabel.hidden = YES;
        self.workingTimeLabel.hidden = YES;
    }

}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

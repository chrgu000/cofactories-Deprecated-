//
//  OrderModel.m
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {

//        NSLog(@"订单模型%@",dictionary);
        _oid = [[dictionary objectForKey:@"oid"] intValue];
        _uid = [[dictionary objectForKey:@"uid"] intValue];
        _type = [[dictionary objectForKey:@"type"] intValue];
        _accept = NO;// 需要改
        _amount = [[dictionary objectForKey:@"amount"] intValue];
        _serviceRange = [dictionary objectForKey:@"serviceRange"];
        //        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:@"createdAt"] intValue]];
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        dateFormatter.dateFormat = @"yyyy-MM-DD";// 年月日
        //        _createTime = [dateFormatter stringFromDate:date];
        _createTime=dictionary[@"createdAt"];
        _workingTime=dictionary[@"workingTime"];
        _name = dictionary[@"name"];
        _phone = dictionary[@"phone"];
        _interest = [dictionary[@"interest"] intValue];
        _status = [dictionary[@"status"] intValue];
        _facName = dictionary[@"factoryName"];
        _photoArray = dictionary[@"photo"];
        if (dictionary[@"comment"] == nil || [dictionary[@"comment"] isEqualToString:@"(null)"]) {
            _comment = @"商家未填写备注信息";
        }else{
            _comment = dictionary[@"comment"];
        }
        if (_status == 1) {
            _bidWinner = [dictionary[@"bidWinner"] intValue];
        }else{
            _bidWinner = 0;
        }
    }
    return self;
}

@end

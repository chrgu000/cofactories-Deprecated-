//
//  PurchasePublicHistoryModel.m
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PurchasePublicHistoryModel.h"

@implementation PurchasePublicHistoryModel
- (instancetype)initModelWith:(NSDictionary *)dictionary{
    
    if (self = [super init]){
        self.amount = dictionary[@"amount"];
        self.orderID = [dictionary[@"id"] integerValue];
        self.photoArray = dictionary[@"photo"];
        self.name = dictionary[@"name"];
        self.comment = dictionary[@"description"];
        self.unit = dictionary[@"unit"];
        self.type = dictionary[@"type"];
        self.creatTime = dictionary[@"createdAt"];
        self.isCompletion = [dictionary[@"status"] integerValue];
    }
    return self;
}

+(instancetype)getModelWith:(NSDictionary *)dictionary{
    return [[self alloc]initModelWith:dictionary];
}

@end

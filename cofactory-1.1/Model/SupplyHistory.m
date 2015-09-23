//
//  SupplyHistory.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/21.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SupplyHistory.h"

@implementation SupplyHistory
//如果key值写错. 会走这个方法, 防止找不到key导致崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initModelWith:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name = dictionary[@"name"];
        self.type = dictionary[@"type"];
        self.price = [dictionary[@"price"] integerValue];
        self.info = dictionary[@"description"];
        self.oid = dictionary[@"id"];
        if ([dictionary[@"photo"] count] != 0) {
            self.photo = dictionary[@"photo"][0];
        }
        self.photoArray = [NSArray arrayWithArray:dictionary[@"photo"]];
    }
    return self;
}
+(instancetype)getModelWith:(NSDictionary *)dictionary {
    return [[self alloc]initModelWith:dictionary];
}


@end

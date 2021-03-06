//
//  FactoryModel.m
//  聚工厂
//
//  Created by 唐佳诚 on 15/7/8.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "FactoryModel.h"

@implementation FactoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //DLog(@"-------%@",dictionary);
        _uid = [[dictionary objectForKey:@"uid"] intValue];
        _oid = [[dictionary objectForKey:@"oid"] intValue];
        _factoryName = [dictionary objectForKey:@"factoryName"];
        _factoryType = [[dictionary objectForKey:@"factoryType"] intValue];
        _hasTruck =[[dictionary objectForKey:@"hasTruck"] intValue];
        _name = [dictionary objectForKey:@"name"];
        
        switch (_factoryType) {
            case 0:
                _factoryFreeTime = nil;
                _factoryFreeStatus = nil;
   
                break;
            case 1:
                _factoryFreeTime = dictionary[@"factoryFreeTime"];
                _factoryFreeStatus = nil;

                break;
            case 2:
                _factoryFreeTime = nil;
                _factoryFreeStatus=[dictionary objectForKey:@"factoryFreeStatus"];

                break;
            case 3:
                _factoryFreeTime = nil;
                _factoryFreeStatus=[dictionary objectForKey:@"factoryFreeStatus"];

                break;

            default:
                break;
        }
        
        
        _tag = [NSString stringWithFormat:@"%@",dictionary[@"tag"]];

        NSArray *factorySize = [dictionary objectForKey:@"factorySize"];
        if ([factorySize[1] intValue] == 2147483647) {
            // 最大的选项
            switch (_factoryType) {
                case GarmentFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@万件以上", factorySize[0]];
                    break;
                case ProcessingFactory:
                case CuttingFactory:
                case LockButtonFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@人以上", factorySize[0]];
                    break;

                default:
                    break;
            }
        } else {
            // 范围选项
            switch (_factoryType) {
                case GarmentFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@到%@万件", factorySize[0], factorySize[1]];
                    break;
                case ProcessingFactory:
                case CuttingFactory:
                case LockButtonFactory:
                    _factorySize = [[NSString alloc] initWithFormat:@"%@到%@人", factorySize[0], factorySize[1]];

                default:
                    break;
            }
        }
        _factoryServiceRange = [dictionary objectForKey:@"factoryServiceRange"];
        _factoryAddress = [dictionary objectForKey:@"factoryAddress"];
        _factoryDescription = [dictionary objectForKey:@"factoryDescription"];
        _factoryFinishedDegree = [[dictionary objectForKey:@"factoryFinishedDegree"] intValue];
        _idCard = [dictionary objectForKey:@"idCard"];
        _distance = [[dictionary objectForKey:@"distance"] intValue];
        _phone = [dictionary objectForKey:@"phone"];
        NSDictionary*verifyDic = dictionary[@"verify"];
        _authStatus = [[verifyDic objectForKey:@"status"] intValue];
        _legalPerson = [verifyDic objectForKey:@"legalPerson"];
        
        _verifyStatus = [[verifyDic objectForKey:@"status"] intValue];
//        _hasTruck = [[dictionary objectForKey:@"hasTruck"] intValue];
        _otherTwoFactoryStatus = [[dictionary objectForKey:@"factoryFreeStatus"] intValue];
        self.facTypeOneStatus = [dictionary objectForKey:@"factoryFreeTime"];

        _city = dictionary[@"city"];
    }
    return self;
}

@end

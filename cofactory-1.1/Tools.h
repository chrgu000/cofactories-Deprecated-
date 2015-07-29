//
//  Tools.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>

@interface Tools : NSObject

//分割字符串
+ (NSMutableArray *)RangeSizeWith:(NSString *)sizeString;

+ (NSMutableArray *)WithTime:(NSString *)timeString;


+ (MBProgressHUD *)createHUD;

+ (NSString *)SizeWith:(NSString *)sizeString;

+ (BOOL)isTourist;

//song
+ (BOOL)isLogin;  //是否登录

+ (NSString *)compareIfTodayAfterDates:(NSDate *)comps;



@end

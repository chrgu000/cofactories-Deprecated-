//
//  PurchaseMPTableViewCell.h
//  cofactory-1.1
//
//  Created by gt on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchasePublicHistoryModel.h"

@interface PurchaseMPTableViewCell : UITableViewCell
- (void)getDataWithModel:(PurchasePublicHistoryModel *)model;
@end
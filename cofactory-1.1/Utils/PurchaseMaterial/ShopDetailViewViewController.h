//
//  ShopDetailViewViewController.h
//  cofactory-1.1
//
//  Created by GTF on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShopDetailViewViewController : UIViewController
@property (nonatomic,strong)FactoryModel *facModel;
- (id)initWithLookoverMaterialModel:(NSArray *)modelArray;
@end

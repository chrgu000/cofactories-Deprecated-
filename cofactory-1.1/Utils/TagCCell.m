//
//  TagCCell.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-10-11.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#define kTagCCell_Font [UIFont systemFontOfSize:14]
#define kTagCCell_Height 40.0
#define kTagCCell_Width ((kScreenW-36.0)/3)

#import "TagCCell.h"
#import "Header.h"

@interface TagCCell ()
@property (strong, nonatomic) UILabel *contentLabel;
@end

@implementation TagCCell

- (void)setCurTag:(NSString *)curTag{
    _curTag = curTag;
    if (!_curTag) {
        return;
    }
    if (!_contentLabel) {
        self.contentView.layer.cornerRadius = 2.0;
        self.layer.cornerRadius = 2.0;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (kTagCCell_Height-20)/2, kTagCCell_Width, 20)];
        _contentLabel.font = kTagCCell_Font;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.minimumScaleFactor = 0.5;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_contentLabel];
    }
    _contentLabel.text = _curTag;
    [_contentLabel setCenter:self.contentView.center];
}

- (void)setHasBeenSelected:(BOOL)hasBeenSelected{
    _hasBeenSelected = hasBeenSelected;
    if (_hasBeenSelected) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        _contentLabel.textColor = [UIColor blackColor];

    }else{

        self.backgroundColor = [UIColor colorWithHexString:@"0x3bbd79"];
        _contentLabel.textColor = [UIColor whiteColor];
    }
}
+ (CGSize)ccellSizeWithObj:(id)obj{
    CGSize ccellSize = CGSizeZero;
    if ([obj isKindOfClass:[NSString class]]) {
        ccellSize = CGSizeMake(kTagCCell_Width, kTagCCell_Height);
    }
    return ccellSize;
}
@end

//
//  CommentCell.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
        self.userImage.layer.cornerRadius = 15;
        self.userImage.clipsToBounds = YES;
        self.userImage.layer.borderWidth = 0.5;
        self.userImage.layer.borderColor = [UIColor grayColor].CGColor;
//        self.userImage.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.userImage];
        self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10, 10, (kScreenW - 80) / 2, 30)];
        self.authorLabel.font = [UIFont systemFontOfSize:13];
        self.authorLabel.textColor = [UIColor grayColor];
//        self.authorLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.authorLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.authorLabel.frame), 10, (kScreenW - 80) / 2, 30)];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
//        self.timeLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.timeLabel];
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImage.frame) + 10, CGRectGetMaxY(self.authorLabel.frame), kScreenW - 80, 50)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:14];
//        self.contentLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:self.contentLabel];
        
    }
    return self;
}


- (void)setComment:(CommentModel *)comment {
    if (_comment != comment) {
        _comment = comment;
    }
    self.authorLabel.text = comment.authour;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%ld.png",PhotoAPI,comment.uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];
    self.timeLabel.text = [Tools getUTCFormateDate:comment.time];
    CGSize size = CGSizeMake(kScreenW - 80, 0);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGRect rect = [comment.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = rect.size.height;
    self.contentLabel.frame = frame;
    self.contentLabel.text = comment.comment;

}


+ (CGFloat)heightOfCell:(CommentModel *)comment {
    CGSize size = CGSizeMake(kScreenW - 80, 0);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGRect rect = [comment.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat height = rect.size.height + 50;
    return height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

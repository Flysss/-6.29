//
//  HuifuTableViewCell.m
//  SalesHelper_A
//
//  Created by Brant on 16/2/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HuifuTableViewCell.h"
#import "UIColor+Extend.h"
#import "UIColor+HexColor.h"

@implementation HuifuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 45, 45)];
        [self.contentView addSubview:self.headImage];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];

        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
        self.huifuLabel = [[UILabel alloc] init];
         [self.contentView addSubview:self.huifuLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.lblLine = [[UILabel alloc]init];
        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
        [self.contentView addSubview:self.lblLine];
    }
    return self;
}


- (void)configTableViewWithModel:(BHMyReplyModel *)model
{
    //头像
    self.headImage.layer.cornerRadius = 45/2;
    self.headImage.layer.masksToBounds = YES;
//    if (model.iconpath != nil && ![model.iconpath isEqualToString:@""])
//    {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
//    }
    
    //姓名
    
    if (model.name == nil || [model.name isKindOfClass:[NSNull class]]) {
        model.name = @"";
    }
        CGFloat nameW = [model.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-85-55, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
    if (nameW > SCREEN_WIDTH-85) {
        nameW = SCREEN_WIDTH-85;
    }
       self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame)+9, 9, nameW, 20);
        self.nameLabel.text = model.name;
        self.nameLabel.font = Default_Font_15;
//        self.nameLabel.textColor = [UIColor hexChangeFloat:@"676767"];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"00aff0"];
    
    //时间
    CGFloat timeW = [model.addtime boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_14} context:nil].size.width;
     self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame)+9, CGRectGetMaxY(self.nameLabel.frame)+5, timeW, 20);
    self.timeLabel.font = Default_Font_14;
    self.timeLabel.textColor = [UIColor hexChangeFloat:@"dadadc"];
    self.timeLabel.text = model.addtime;
    
    
    
    //回复语
    CGFloat huiH = [model.contents boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-85, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_16} context:nil].size.height;
    self.huifuLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, CGRectGetMaxY(self.timeLabel.frame)+10, SCREEN_WIDTH-85, huiH);
    self.huifuLabel.textColor = [UIColor colorWithHexString:@"676767"];
    self.huifuLabel.font = Default_Font_16;
    self.huifuLabel.numberOfLines = 0;
    if (model.contents != nil)
    {
        self.huifuLabel.text = model.contents;
    }
   
    //内容
  
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+9, CGRectGetMinY(self.timeLabel.frame), SCREEN_WIDTH-CGRectGetMaxX(self.timeLabel.frame)+9-20, 20);
    self.contentLabel.font = Default_Font_14;
    self.contentLabel.textColor = [UIColor hexChangeFloat:@"676767"];
    if (model.posts_contents != nil)
    {        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复于%@",model.posts_contents]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aff0"] range:NSMakeRange(3, model.posts_contents.length)];
        self.contentLabel.attributedText = str;
    }
    self.lblLine.frame = CGRectMake(0, CGRectGetMaxY(self.huifuLabel.frame)+6.5, SCREEN_WIDTH, 0.5);
    
}

+ (CGFloat)heightForCell:(BHMyReplyModel *)model
{
    CGFloat huiH = [model.contents boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-85, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_16} context:nil].size.height;
    return 64+huiH+7;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
